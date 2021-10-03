# If this variable is not set, the program '/bin/sh' is used as the shell.
SHELL=/bin/bash

.SHELLFLAGS := -euo pipefail -c

# all: gen-dashboard verify-dashboard
# .PHONY: all

gen-dashboard:
				@echo "Generate dashboard chart docs"
				@chart-doc-gen -t=charts/dashboard/docs/readme.tpl -d=charts/dashboard/docs/doc.yaml -v=charts/dashboard/values.yaml > charts/dashboard/README.md
.PHONY: gen-dashboard

verify-dashboard: gen fmt
				@if !(git diff --exit-code HEAD); then \
					echo "generated files are out of date, run make gen"; exit 1; \
				fi
.PHONY: verify-dashboard