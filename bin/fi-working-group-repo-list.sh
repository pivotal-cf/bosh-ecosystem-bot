#!/bin/bash

set -eu -o pipefail

curl -s https://raw.githubusercontent.com/cloudfoundry/community/main/toc/working-groups/foundational-infrastructure.md \
	| grep github | cut -d'(' -f2 | cut -d')' -f1 | cut -d'/' -f4-5 \
	| jq -r -R -s 'split("\n") | map(select(. != ""))[]'
