package tests

import (
	"crypto/tls"
	"fmt"
	"path/filepath"
	"strconv"
	"strings"
	"testing"
	"time"

	"github.com/matryer/is"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"

	"github.com/gruntwork-io/terratest/modules/helm"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/random"
)

func TestHelmDashboardDeployment(t *testing.T) {
	is := is.New(t)

	// Path to the helm chart we will test
	helmChartPath, err := filepath.Abs("../charts/dashboard")
	is.NoErr(err)

	// Squelch logger unless test is run verbosely.
	helmOptLogger := logger.Discard

	if testing.Verbose() {
		helmOptLogger = logger.Default
	}

	// Set a unique namespace
	namespaceName := fmt.Sprintf("tyk-dashboard-test-%s", strings.ToLower(random.UniqueId()))

	// Setup the kubectl config and context.
	kubectlOptions := k8s.NewKubectlOptions("", "", namespaceName)

	// create and delete the namespace at the end of the test
	k8s.CreateNamespace(t, kubectlOptions, namespaceName)
	defer k8s.DeleteNamespace(t, kubectlOptions, namespaceName)

	// Setup helm values.
	options := &helm.Options{
		Logger:         helmOptLogger,
		KubectlOptions: kubectlOptions,
	}

	// Install gateway, redis and mongodb
	depEndpoints := installDashboardDeps(t, options, kubectlOptions)

	// Set gateway and other helm values for dashboard.
	options.SetValues = map[string]string{
		"gateway.endpoint": depEndpoints,
		"gateway.port":     "443",
		"service.nodePort": "30950",
	}

	// Generate a unique helm release name.
	releaseName := fmt.Sprintf(
		"dashboard-%s",
		strings.ToLower(random.UniqueId()),
	)
	defer helm.Delete(t, options, releaseName, true)

	// Deploy the dashboard chart.
	helm.Install(t, options, helmChartPath, releaseName)

	// Wait for the dashboard pods to be available.
	waitForRemoteChartPods(t, kubectlOptions, releaseName, 1)

	// Next we wait until the service is available.
	k8s.WaitUntilServiceAvailable(t, kubectlOptions, releaseName, 5, 1*time.Second)

	endpoint := "http://localhost:63974/hello"

	// Setup a TLS configuration to submit with the helper, a blank struct is acceptable
	tlsConfig := tls.Config{}

	// Test the /hello endpoint and will timeout waiting for the service to return a 200 response.
	http_helper.HttpGetWithRetryWithCustomValidation(
		t,
		endpoint,
		&tlsConfig,
		10,
		5*time.Second,
		func(statusCode int, body string) bool {
			return statusCode == 200
		},
	)
}

func installDashboardDeps(t *testing.T, helmOptions *helm.Options, kubectlOptions *k8s.KubectlOptions) string {
	var gatewayEndpoint string

	// Squelch logger unless test is run verbosely.
	helmOptLogger := logger.Discard

	if testing.Verbose() {
		helmOptLogger = logger.Default
	}

	// Add the stable repo under a random name so as not to touch existing repo configs
	uniqueName := strings.ToLower(fmt.Sprintf("tyk-helm-%s", random.UniqueId()))
	defer helm.RemoveRepo(t, helmOptions, uniqueName)
	helm.AddRepo(t, helmOptions, uniqueName, "https://helm.tyk.io/public/helm/charts/")

	// Iterate through to install all dependencies
	for _, cn := range []string{"simple-redis:6379", "simple-mongodb:27017", "tyk-headless:443"} {
		// Separate chart name and port number
		s := strings.LastIndex(cn, ":")
		chartName := cn[0:s]
		servicePort, err := strconv.Atoi(strings.Replace(cn[s:], ":", "", -1))
		if err != nil {
			t.Fatal(err)
		}

		helmChart := fmt.Sprintf("%s/%s", uniqueName, chartName)

		// Generate a unique release name
		releaseName := fmt.Sprintf(
			"%s-%s",
			chartName,
			strings.ToLower(random.UniqueId()),
		)
		helmOptLogger.Logf(t, "Installing '%s' dependency.", releaseName)

		// Install helm charts
		errI := helm.InstallE(t, helmOptions, helmChart, releaseName)
		if errI != nil {
			t.Fatal(errI)
		}

		if chartName == "tyk-headless" {
			// Wait for the gatway pods to be available.
			waitForRemoteChartPods(t, kubectlOptions, releaseName, 1)

			// Get the gateway service name.
			serviceName := fmt.Sprintf("gateway-svc-%s", releaseName)

			// Next we wait until the service is available.
			k8s.WaitUntilServiceAvailable(t, kubectlOptions, serviceName, 8, 2*time.Second)

			gatewayEndpoint = fmt.Sprintf("%s.%s.svc:%s", serviceName, kubectlOptions.Namespace, strconv.Itoa(servicePort))
		}
	}
	return gatewayEndpoint
}

func waitForRemoteChartPods(t *testing.T, kubectlOptions *k8s.KubectlOptions, releaseName string, podCount int) {
	// Get pod and wait for it to be avaialable
	// To get the pod, we need to filter it using the labels that the helm chart creates
	filters := metav1.ListOptions{
		LabelSelector: fmt.Sprintf("release=%s", releaseName),
	}
	k8s.WaitUntilNumPodsCreated(t, kubectlOptions, filters, podCount, 20, 5*time.Second)
	pods := k8s.ListPods(t, kubectlOptions, filters)
	for _, pod := range pods {
		k8s.WaitUntilPodAvailable(t, kubectlOptions, pod.Name, 20, 5*time.Second)
	}
}
