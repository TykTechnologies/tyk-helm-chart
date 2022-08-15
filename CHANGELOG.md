# Changelog

## [Unreleased](https://github.com/TykTechnologies/tyk-helm-chart/tree/HEAD)

[Full Changelog](https://github.com/TykTechnologies/tyk-helm-chart/compare/v0.9.5...HEAD)

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