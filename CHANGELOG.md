# Changelog

## [Unreleased](https://github.com/TykTechnologies/tyk-helm-chart/tree/HEAD)
[Full Changelog](https://github.com/TykTechnologies/tyk-helm-chart/compare/v0.13.2...HEAD)

## [v0.14.0](https://github.com/TykTechnologies/tyk-helm-chart/tree/HEAD)

[Full Changelog](https://github.com/TykTechnologies/tyk-helm-chart/compare/v0.13.2...v0.14.0)

**Added**:
- PostgreSQL support for MDCB.
- Add new fields to values.yaml files to allow defining extra `volume` and `volumeMounts`. [#246](https://github.com/TykTechnologies/tyk-helm-chart/issues/246)

**Updated:**
- Update versions of all the components to latest.
- Updated image repository of charts to `docker.tyk.io`.
- Updated version of enterprise portal to v1.2.0

**Fixed:**
- Typo in bootstrap job name in tyk-pro chart.
- Failures happening while mounting files into components. [#256](https://github.com/TykTechnologies/tyk-helm-chart/issues/256)
- Missing `volumeMount` in Enterprise Portal's StatefulSet.

## [v0.13.2](https://github.com/TykTechnologies/tyk-helm-chart/tree/v0.13.2)
[Full Changelog](https://github.com/TykTechnologies/tyk-helm-chart/compare/v0.13.1...v0.13.2)

**Updated:**
- Set `allow_explicit_policy_id` to true by default for hybrid charts.
- Changed default gateway kind from `Daemonset` to `Deployment`.

## [v0.13.1](https://github.com/TykTechnologies/tyk-helm-chart/tree/HEAD)

[Full Changelog](https://github.com/TykTechnologies/tyk-helm-chart/compare/v0.13.0...v0.13.1)

**Updated:**
- Check mongo and redis fields is not nil before using it's child fields

## [v0.13.0](https://github.com/TykTechnologies/tyk-helm-chart/tree/HEAD)

[Full Changelog](https://github.com/TykTechnologies/tyk-helm-chart/compare/v0.12.0...v0.13.0)

**Added**
- Added secrets hashes to deployments to force restarts on secrets updates [#238](https://github.com/TykTechnologies/tyk-helm-chart/pull/238)
- Added support for boolean values for envVars [#242](https://github.com/TykTechnologies/tyk-helm-chart/pull/242)
- Added support for managing annotations for the MDCB and Dashboard [#231](https://github.com/TykTechnologies/tyk-helm-chart/pull/231)
- Added unit tests for helm charts [#245](https://github.com/TykTechnologies/tyk-helm-chart/pull/245)
- Fixed probes for Tyk vers > 4.0 [#247](https://github.com/TykTechnologies/tyk-helm-chart/pull/247)

## [v0.12.0](https://github.com/TykTechnologies/tyk-helm-chart/tree/v0.12.0)

[Full Changelog](https://github.com/TykTechnologies/tyk-helm-chart/compare/v0.11.0...v0.12.0)

**Added**
- Added ability to launch an enterprise portal to tyk-pro [#222](https://github.com/TykTechnologies/tyk-helm-chart/pull/222)
 
**Updated:**
- Updated smoke tests to include Postgres [#222](https://github.com/TykTechnologies/tyk-helm-chart/pull/222)

## [v0.11.0](https://github.com/TykTechnologies/tyk-helm-chart/tree/v0.11.0)

[Full Changelog](https://github.com/TykTechnologies/tyk-helm-chart/compare/v0.10.0...v0.11.0)

**Added:**
- Added new bootstrapping `tyk-bootstrap` image to bootstrap Tyk Pro instead of
scripts. [#226](https://github.com/TykTechnologies/tyk-helm-chart/pull/226)
- Added `securityContext` field for every component(Gateway, Dashboard, Pump, MDCB, TIB)
in `values.yaml` file. It is used to set `PodSecurityContext` field of corresponding
deployments. [#220](https://github.com/TykTechnologies/tyk-helm-chart/pull/220)

**Fixed:**
- Fixed Tyk Pro bootstrapping issues on Openshift environment [#226](https://github.com/TykTechnologies/tyk-helm-chart/pull/226) and [#220](https://github.com/TykTechnologies/tyk-helm-chart/pull/220)

**Deleted:**
- Deleted scripts used in bootstrapping. [#226](https://github.com/TykTechnologies/tyk-helm-chart/pull/226)

## [v0.10.0](https://github.com/TykTechnologies/tyk-helm-chart/tree/v0.10.0) (2022-08-12)

[Full Changelog](https://github.com/TykTechnologies/tyk-helm-chart/compare/v0.9.5...v0.10.0)

**Added:**
- Added support of SQL in Dashboard and Pump [\#214](https://github.com/TykTechnologies/tyk-helm-chart/pull/214) 
- Add code owners [\#208](https://github.com/TykTechnologies/tyk-helm-chart/pull/208) 
- Added pull request template [\#207](https://github.com/TykTechnologies/tyk-helm-chart/pull/207) 
- Added GithubAction to release helm chart [\#206](https://github.com/TykTechnologies/tyk-helm-chart/pull/206) 
- Added new field `operatorSecret` values.yaml file[\#202](https://github.com/TykTechnologies/tyk-helm-chart/pull/202) 
- Added pre-delete hook to clean up resources created during bootstrap [\#202](https://github.com/TykTechnologies/tyk-helm-chart/pull/202) 
- Clarified integration options for the Tyk simple Redis chart, Redis Cluster and Redis Sentinel in values.yaml [\#218](https://github.com/TykTechnologies/tyk-helm-chart/pull/218)


**Updated:**
- Check Environment Configuration Before Bootstrapping [\#213](https://github.com/TykTechnologies/tyk-helm-chart/pull/213) 
- Check for existing Org during bootstrap  [\#209](https://github.com/TykTechnologies/tyk-helm-chart/pull/209) 
- Update bootstrap post-install hook and introduce new field in the values.yaml [\#202](https://github.com/TykTechnologies/tyk-helm-chart/pull/202) 
- Increased `initialDelaySeconds` of livenessProbe and readinessProbe of Dashboard container.

## [v0.9.5](https://github.com/TykTechnologies/tyk-helm-chart/tree/v0.9.5) (2022-04-08)

[Full Changelog](https://github.com/TykTechnologies/tyk-helm-chart/compare/v0.9.4...v0.9.5)

**Added:**
- Added group\_id to hybrid chart [\#194](https://github.com/TykTechnologies/tyk-helm-chart/pull/194) 

**Updated:**
-  Ingress update to support different k8's versions  [\#192](https://github.com/TykTechnologies/tyk-helm-chart/pull/192)

## [v0.9.4](https://github.com/TykTechnologies/tyk-helm-chart/tree/v0.9.4) (2022-03-07)

[Full Changelog](https://github.com/TykTechnologies/tyk-helm-chart/compare/v0.9.3...v0.9.4)

**Added:**
- Add ability to modify strategy [\#173](https://github.com/TykTechnologies/tyk-helm-chart/pull/173) 
- Optimize storage redis configuration to support different mode [\#182](https://github.com/TykTechnologies/tyk-helm-chart/pull/182)

**Updated:**
- Update values.yaml [\#187](https://github.com/TykTechnologies/tyk-helm-chart/pull/187) 
-  Updated Ingress resource to support various Kubernetes versions [\#184](https://github.com/TykTechnologies/tyk-helm-chart/pull/184) 
- Making user passed secrets mount in main container [\#180](https://github.com/TykTechnologies/tyk-helm-chart/pull/180) 
- Revert using default config file instead of local config [\#159](https://github.com/TykTechnologies/tyk-helm-chart/pull/159) 

**Fixed:**
- Fix a typo [\#163](https://github.com/TykTechnologies/tyk-helm-chart/pull/163) 
- Fix command in init script to wait for dashboard readiness [\#176](https://github.com/TykTechnologies/tyk-helm-chart/pull/176) 
- Fix secrets mounts [\#181](https://github.com/TykTechnologies/tyk-helm-chart/pull/181)

## [v0.9.3](https://github.com/TykTechnologies/tyk-helm-chart/tree/v0.9.3) (2021-09-03)

[Full Changelog](https://github.com/TykTechnologies/tyk-helm-chart/compare/v0.9.2...v0.9.3)

**Fixed**

- Fix or logic [\#155](https://github.com/TykTechnologies/tyk-helm-chart/pull/155) 
- Fix bug in tyk-headless [\#154](https://github.com/TykTechnologies/tyk-helm-chart/pull/154) 

## [v0.9.2](https://github.com/TykTechnologies/tyk-helm-chart/tree/v0.9.2) (2021-07-30)

[Full Changelog](https://github.com/TykTechnologies/tyk-helm-chart/compare/v0.9.1...v0.9.2)

**Updated:**

- Replace wait-for-it script [\#138](https://github.com/TykTechnologies/tyk-helm-chart/pull/138) 
- Update instructions and appVersion [\#150](https://github.com/TykTechnologies/tyk-helm-chart/pull/150) 
- Added a link to the official docs  [\#151](https://github.com/TykTechnologies/tyk-helm-chart/pull/151) 

## [v0.9.1](https://github.com/TykTechnologies/tyk-helm-chart/tree/v0.9.1) (2021-07-09)

[Full Changelog](https://github.com/TykTechnologies/tyk-helm-chart/compare/v0.9.0...v0.9.1)

**Fixed:**

- Fix adding unnecessary new line to the end of entries [\#147](https://github.com/TykTechnologies/tyk-helm-chart/pull/147)

**Updated:**
- Update charts description [\#146](https://github.com/TykTechnologies/tyk-helm-chart/pull/146)

## [v0.9.0](https://github.com/TykTechnologies/tyk-helm-chart/tree/v0.9.0) (2021-07-05)

[Full Changelog](https://github.com/TykTechnologies/tyk-helm-chart/compare/fd5c77b9f4eeb6e79a5f9bbf5e9f73907a8fe63b...v0.9.0)

Release first official Tyk Pro, Tyk Hybrid and Tyk Headless helm charts version 0.9.0.
