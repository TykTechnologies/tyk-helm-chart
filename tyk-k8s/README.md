## Warning: This is heavily WIP

Installation:

Create the CA certs and namespace:

	webhook/prepare.sh 

Install the tyk-k8s controller

	helm install .

Create the mutating web hook to auto-inject sidecars

	kubectl create -f ./webhook/mutatingwebhook-ca-bundle.yaml


Then test the injector with:

	kubectl create -f ./webhook/test-service.yaml 

And examine the pod created by the deployment.

To test the Ingress, you can use:

	kubectl create -f ingress-test/

Then (if you know the LB of your K8s cluster):

	martin@lady-sharrow ~/h/tyk-k8s> curl -v -H "Host: cafe.example.com" http://your-elb.domain-name.com/tea 
	*   Trying XX.XX.XX.XX...
	* TCP_NODELAY set
	> GET /tea HTTP/1.1
	> Host: cafe.example.com
	> User-Agent: curl/7.58.0
	> Accept: */*
	> 
	< HTTP/1.1 200 OK
	< Cache-Control: no-cache
	< Content-Length: 149
	< Content-Type: text/plain
	< Date: Thu, 17 Jan 2019 04:00:21 GMT
	< Expires: Thu, 17 Jan 2019 04:00:20 GMT
	< Server: nginx/1.13.8
	< X-Ratelimit-Limit: 0
	< X-Ratelimit-Remaining: 0
	< X-Ratelimit-Reset: 0
	< 
	Server address: 10.2.3.121:80
	Server name: tea-85f8bf86fd-tsv8j
	Date: 17/Jan/2019:04:00:21 +0000
	URI: /
	Request ID: f42ad0c1205be5337a3ee7d75ecc5bc0

If it's all working, you will have the relevant service defintiions as well.

