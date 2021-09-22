# If this variable is not set, the program '/bin/sh' is used as the shell.
SHELL=/bin/bash

.DEFAULT_GOAL := build

.DELETE_ON_ERROR:

.ONESHELL:

.SHELLFLAGS := -euo pipefail -c

# all: gen-dashboard verify-dashboard
# .PHONY: all

gen-dashboard: cd charts/dashboard && gen-chart-doc
.PHONY: gen-dashboard

gen-chart-doc:
	@echo "Generate chart docs"
	@chart-doc-gen -t=./docs/readme.tpl -d=./docs/doc.yaml -v=./ci/values.yaml > ./README.md
.PHONY: gen-chart-doc

verify-dashboard: cd charts/dashboard && verify-gen
.PHONY: verify-dashboard

verify-gen: gen fmt
	@if !(git diff --exit-code HEAD); then \
		echo "generated files are out of date, run make gen"; exit 1; \
	fi
.PHONY: verify-gen