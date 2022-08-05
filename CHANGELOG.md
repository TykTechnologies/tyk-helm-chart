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


**Updated:**
- Check Environment Configuration Before Bootstrapping [\#213](https://github.com/TykTechnologies/tyk-helm-chart/pull/213) 
- Check for existing Org during bootstrap  [\#209](https://github.com/TykTechnologies/tyk-helm-chart/pull/209) 
- Update bootstrap post-install hook and introduce new field in the values.yaml [\#202](https://github.com/TykTechnologies/tyk-helm-chart/pull/202) 

## [v0.9.5](https://github.com/TykTechnologies/tyk-helm-chart/tree/v0.9.5) (2022-04-08)

[Full Changelog](https://github.com/TykTechnologies/tyk-helm-chart/compare/v0.9.4...v0.9.5)

**Added:**
- Added group\_id to hybrid chart [\#194](https://github.com/TykTechnologies/tyk-helm-chart/pull/194) 

**Updated:**
-  Ingress update to support different k8's versions  [\#192](https://github.com/TykTechnologies/tyk-helm-chart/pull/192)

## [v0.9.4](https://github.com/TykTechnologies/tyk-helm-chart/tree/v0.9.4) (2022-03-07)

[Full Changelog](https://github.com/TykTechnologies/tyk-helm-chart/compare/v0.9.3...v0.9.4)

**Closed issues:**

- Incorrect reference to tyk-pro in tyk-headless chart when mounting secrets [\#179](https://github.com/TykTechnologies/tyk-helm-chart/issues/179)
- Can not deploy helm chart using different release name [\#175](https://github.com/TykTechnologies/tyk-helm-chart/issues/175)
- Change ingress resource definition to use networking.k8s.io/v1 instead of v1beta1 [\#174](https://github.com/TykTechnologies/tyk-helm-chart/issues/174)
- design questions [\#171](https://github.com/TykTechnologies/tyk-helm-chart/issues/171)
- is there anybody who uses ElasticSearch-Kibana to observe tyk-ce? [\#166](https://github.com/TykTechnologies/tyk-helm-chart/issues/166)

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

**Closed issues:**

- When using values.redis.addr, stray newline prevents last entry from working [\#139](https://github.com/TykTechnologies/tyk-helm-chart/issues/139)
- Failed post install for tyk-pro [\#114](https://github.com/TykTechnologies/tyk-helm-chart/issues/114)

## [v0.9.1](https://github.com/TykTechnologies/tyk-helm-chart/tree/v0.9.1) (2021-07-09)

[Full Changelog](https://github.com/TykTechnologies/tyk-helm-chart/compare/v0.9.0...v0.9.1)

**Fixed:**

- Fix adding unnecessary new line to the end of entries [\#147](https://github.com/TykTechnologies/tyk-helm-chart/pull/147)

**Updated:**
- Update charts description [\#146](https://github.com/TykTechnologies/tyk-helm-chart/pull/146)

## [v0.9.0](https://github.com/TykTechnologies/tyk-helm-chart/tree/v0.9.0) (2021-07-05)

[Full Changelog](https://github.com/TykTechnologies/tyk-helm-chart/compare/fd5c77b9f4eeb6e79a5f9bbf5e9f73907a8fe63b...v0.9.0)

**Implemented enhancements:**

- Run containers as non-root by default [\#39](https://github.com/TykTechnologies/tyk-helm-chart/issues/39)
- Helm charts for TIB [\#15](https://github.com/TykTechnologies/tyk-helm-chart/issues/15)
- Improve bootstrap process [\#12](https://github.com/TykTechnologies/tyk-helm-chart/issues/12)
- Pods dont automatically pick up config changes [\#9](https://github.com/TykTechnologies/tyk-helm-chart/issues/9)
- Make secrets better [\#2](https://github.com/TykTechnologies/tyk-helm-chart/issues/2)
- Allow users to mount files as secrets [\#133](https://github.com/TykTechnologies/tyk-helm-chart/pull/133) 
- Docs updates [\#117](https://github.com/TykTechnologies/tyk-helm-chart/pull/117) 
- Add lint and tests [\#110](https://github.com/TykTechnologies/tyk-helm-chart/pull/110)
- Automated smoke tests [\#108](https://github.com/TykTechnologies/tyk-helm-chart/pull/108) 

**Fixed bugs:**

- TLS Cert has expired [\#88](https://github.com/TykTechnologies/tyk-helm-chart/issues/88)
- Add an ingress for the hybrid chart [\#52](https://github.com/TykTechnologies/tyk-helm-chart/issues/52)
- Liveness and readiness probe to query control api [\#122](https://github.com/TykTechnologies/tyk-helm-chart/pull/122) 
- Automated smoke tests [\#115](https://github.com/TykTechnologies/tyk-helm-chart/pull/115) 
- Tyk Pro bootstrap [\#109](https://github.com/TykTechnologies/tyk-helm-chart/pull/109) 

**Closed issues:**

- Could not get session" error="redis: nil [\#143](https://github.com/TykTechnologies/tyk-helm-chart/issues/143)
- Overriding mongoURL Key Not Working [\#130](https://github.com/TykTechnologies/tyk-helm-chart/issues/130)
- Tyk CE Ingress Definition Doesn't do anything [\#116](https://github.com/TykTechnologies/tyk-helm-chart/issues/116)
- Tyk Developer Portal doesn't work with default Helm Chart deployment Tyk-Pro [\#99](https://github.com/TykTechnologies/tyk-helm-chart/issues/99)
- tyk-pro: recursive template include call [\#94](https://github.com/TykTechnologies/tyk-helm-chart/issues/94)
- Remove dependency on namespace "tyk" [\#92](https://github.com/TykTechnologies/tyk-helm-chart/issues/92)
- Tyk-Hybrid installation of tyk-k8s isn't/wasn't obvious enough [\#74](https://github.com/TykTechnologies/tyk-helm-chart/issues/74)
- Allow to configure the redis.database value for tyk-hybrid [\#71](https://github.com/TykTechnologies/tyk-helm-chart/issues/71)
- Chart has not been updated to reflect new configuration option names. [\#68](https://github.com/TykTechnologies/tyk-helm-chart/issues/68)
- Do not use 'latest' docker images [\#66](https://github.com/TykTechnologies/tyk-helm-chart/issues/66)
- MongoDB auth fails when following instructions [\#59](https://github.com/TykTechnologies/tyk-helm-chart/issues/59)
- Fix password leaks by using secrets and `envFrom` for passing Redis password [\#54](https://github.com/TykTechnologies/tyk-helm-chart/issues/54)
- README Link to TIB is broken [\#53](https://github.com/TykTechnologies/tyk-helm-chart/issues/53)
- Helm output of tyk pro needs to be updated [\#49](https://github.com/TykTechnologies/tyk-helm-chart/issues/49)
- Community edition values contain unused gateway.redis entry [\#41](https://github.com/TykTechnologies/tyk-helm-chart/issues/41)
- bootstrap script assumes http [\#32](https://github.com/TykTechnologies/tyk-helm-chart/issues/32)
- Invalid ingress will crash the ingress listener so controller needs restarting [\#30](https://github.com/TykTechnologies/tyk-helm-chart/issues/30)
- bootstrap.sh ValueError: Invalid control character at: line 1 column 33 \(char 32\) [\#27](https://github.com/TykTechnologies/tyk-helm-chart/issues/27)
- Chart not found [\#16](https://github.com/TykTechnologies/tyk-helm-chart/issues/16)
- Unable to parse json when bootstrapping [\#10](https://github.com/TykTechnologies/tyk-helm-chart/issues/10)
- Chart is not idiomatic [\#8](https://github.com/TykTechnologies/tyk-helm-chart/issues/8)

**Merged pull requests:**

- \[BUG\] fix smoke tests [\#145](https://github.com/TykTechnologies/tyk-helm-chart/pull/145)  
- Fix CI Smoke Tests [\#144](https://github.com/TykTechnologies/tyk-helm-chart/pull/144)  
- Debug CI tests [\#142](https://github.com/TykTechnologies/tyk-helm-chart/pull/142) 
- Fix CI tests [\#141](https://github.com/TykTechnologies/tyk-helm-chart/pull/141) 
- Create empty policies.json file in headless chart [\#140](https://github.com/TykTechnologies/tyk-helm-chart/pull/140) 
- \[TD-311\] New helm installation proccess updates [\#137](https://github.com/TykTechnologies/tyk-helm-chart/pull/137) 
- Release 0.9.0 [\#135](https://github.com/TykTechnologies/tyk-helm-chart/pull/135) 
- Update README.md [\#134](https://github.com/TykTechnologies/tyk-helm-chart/pull/134) 
- Fix dashboard HTTPS and OSS control port hard code [\#132](https://github.com/TykTechnologies/tyk-helm-chart/pull/132)  
- \[BUG\] Disable running actions on pro and hybrid charts for PRs [\#131](https://github.com/TykTechnologies/tyk-helm-chart/pull/131)  
- allow more flexible expression of extraEnv [\#126](https://github.com/TykTechnologies/tyk-helm-chart/pull/126) 
- Update Docker image version to latest stable [\#125](https://github.com/TykTechnologies/tyk-helm-chart/pull/125) 
- \[TD-167\] Update docker url for OSS images [\#124](https://github.com/TykTechnologies/tyk-helm-chart/pull/124) 
- For future debugging [\#123](https://github.com/TykTechnologies/tyk-helm-chart/pull/123) 
- \[TD-42\] Store sensitive info as secrets [\#121](https://github.com/TykTechnologies/tyk-helm-chart/pull/121) 
-  \[TD-40\] Allow to configure redis database index through values [\#120](https://github.com/TykTechnologies/tyk-helm-chart/pull/120) 
- Update deployment-gw-repset.yaml [\#112](https://github.com/TykTechnologies/tyk-helm-chart/pull/112)
- Helm updates [\#111](https://github.com/TykTechnologies/tyk-helm-chart/pull/111) 
- Turn off sharding. [\#106](https://github.com/TykTechnologies/tyk-helm-chart/pull/106) 
- \[TD-219\] - Tyk Helm: implement full Tyk Pro bootstrap [\#105](https://github.com/TykTechnologies/tyk-helm-chart/pull/105) 
- tyk-pro: enable installing tyk in a different namespace [\#103](https://github.com/TykTechnologies/tyk-helm-chart/pull/103) 
- tyk-pro: ensure checksum/config for pump deployment is set [\#102](https://github.com/TykTechnologies/tyk-helm-chart/pull/102) 
- injects portal path as config env variable into dashboard. [\#101](https://github.com/TykTechnologies/tyk-helm-chart/pull/101) 
- tyk-headless: Setup directories needed for tyk to be operational [\#98](https://github.com/TykTechnologies/tyk-helm-chart/pull/98) 
- TD-37 - Pods dont automatically pick up config changes [\#97](https://github.com/TykTechnologies/tyk-helm-chart/pull/97) 
- \[TD-37\] Checksum configmaps [\#95](https://github.com/TykTechnologies/tyk-helm-chart/pull/95) 
- should be rpcKey for orgid [\#90](https://github.com/TykTechnologies/tyk-helm-chart/pull/90)
- Update expired certificates [\#89](https://github.com/TykTechnologies/tyk-helm-chart/pull/89)
- \[TD-43\] Restructure charts to make use of the default values [\#87](https://github.com/TykTechnologies/tyk-helm-chart/pull/87) 
- Fix Headless deployment [\#86](https://github.com/TykTechnologies/tyk-helm-chart/pull/86) 
- Correct problems with chart start and missing deprecated values [\#85](https://github.com/TykTechnologies/tyk-helm-chart/pull/85) 
- \[TD-37\] Automatically roll deployments [\#84](https://github.com/TykTechnologies/tyk-helm-chart/pull/84) 
- OSS Deployment improvements [\#83](https://github.com/TykTechnologies/tyk-helm-chart/pull/83) 
- Hybrid improvements [\#81](https://github.com/TykTechnologies/tyk-helm-chart/pull/81) 
- Istio Ingress Support [\#80](https://github.com/TykTechnologies/tyk-helm-chart/pull/80) 
- punch up the readme [\#79](https://github.com/TykTechnologies/tyk-helm-chart/pull/79) 
- Run containers as non-root by default [\#76](https://github.com/TykTechnologies/tyk-helm-chart/pull/76) 
- Fixes a few typos in the README [\#75](https://github.com/TykTechnologies/tyk-helm-chart/pull/75) 
- Improve dashboard bootstrap proccess and deprecate tyk-k8s [\#73](https://github.com/TykTechnologies/tyk-helm-chart/pull/73) 
- Headless control api service [\#72](https://github.com/TykTechnologies/tyk-helm-chart/pull/72) 
- Update README.md [\#70](https://github.com/TykTechnologies/tyk-helm-chart/pull/70) 
- update deprecated apiVersions [\#67](https://github.com/TykTechnologies/tyk-helm-chart/pull/67) 
- Update hybrid gateway ingress resource and bump hybrid chart version [\#65](https://github.com/TykTechnologies/tyk-helm-chart/pull/65) 
- tyk-k8s chart bump [\#63](https://github.com/TykTechnologies/tyk-helm-chart/pull/63) 
- dont need these operands [\#62](https://github.com/TykTechnologies/tyk-helm-chart/pull/62) 
- Change hybrid controller tag [\#61](https://github.com/TykTechnologies/tyk-helm-chart/pull/61)
- Change controller tag [\#60](https://github.com/TykTechnologies/tyk-helm-chart/pull/60) 
- Bumps Hybrid chart version [\#58](https://github.com/TykTechnologies/tyk-helm-chart/pull/58) 
- Add ingress resource for the gateways in tyk-hybrid chart [\#57](https://github.com/TykTechnologies/tyk-helm-chart/pull/57) 
- Update broken TIB link in the Readme file [\#56](https://github.com/TykTechnologies/tyk-helm-chart/pull/56) 
- Moved important notes to the top [\#55](https://github.com/TykTechnologies/tyk-helm-chart/pull/55) 
- Update redis and mongo charts [\#51](https://github.com/TykTechnologies/tyk-helm-chart/pull/51) 
- Delete stale.yml [\#50](https://github.com/TykTechnologies/tyk-helm-chart/pull/50) 
- Update values.yaml [\#48](https://github.com/TykTechnologies/tyk-helm-chart/pull/48) 
- Made the instructions clearer [\#46](https://github.com/TykTechnologies/tyk-helm-chart/pull/46) 
- change command parameter [\#45](https://github.com/TykTechnologies/tyk-helm-chart/pull/45) 
- Add templates for MDCB and include in values.yaml [\#44](https://github.com/TykTechnologies/tyk-helm-chart/pull/44) 
- Remove the unused gateway.redis section in ce values.yaml [\#40](https://github.com/TykTechnologies/tyk-helm-chart/pull/40) 
- Updates resources, brings watchNamespaces, controller certs gen optional, fixes [\#37](https://github.com/TykTechnologies/tyk-helm-chart/pull/37) 
- https schema option added for the bootstrap script [\#36](https://github.com/TykTechnologies/tyk-helm-chart/pull/36) 
- Statement regarding headless experimental nature [\#35](https://github.com/TykTechnologies/tyk-helm-chart/pull/35) 
- Fix to target correct value files [\#29](https://github.com/TykTechnologies/tyk-helm-chart/pull/29) 
- Fixed copy paste typo for community install. [\#28](https://github.com/TykTechnologies/tyk-helm-chart/pull/28) 
- Feature/13 helm charts for tib [\#26](https://github.com/TykTechnologies/tyk-helm-chart/pull/26) 
- Bug rpc connstring [\#25](https://github.com/TykTechnologies/tyk-helm-chart/pull/25) 
- support non tls MDCB & sharded hybrid gateways [\#24](https://github.com/TykTechnologies/tyk-helm-chart/pull/24) 
- rpcConnString is case sensitive [\#23](https://github.com/TykTechnologies/tyk-helm-chart/pull/23) 
- lint: mongo not needed for CE or Hybrid [\#22](https://github.com/TykTechnologies/tyk-helm-chart/pull/22) 
- Highlight YAML snippets [\#21](https://github.com/TykTechnologies/tyk-helm-chart/pull/21) 
- More configurable, idiomatic and bugfixed chart [\#11](https://github.com/TykTechnologies/tyk-helm-chart/pull/11) 
- Fixes resource values reference and some strings not being quoted for the env vars [\#6](https://github.com/TykTechnologies/tyk-helm-chart/pull/6) 
- fixing env vars [\#5](https://github.com/TykTechnologies/tyk-helm-chart/pull/5) 
- reminder to ensure firewall is open [\#4](https://github.com/TykTechnologies/tyk-helm-chart/pull/4)
- Typos n bugfixes [\#3](https://github.com/TykTechnologies/tyk-helm-chart/pull/3) 



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
