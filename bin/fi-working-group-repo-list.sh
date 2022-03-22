#!/bin/bash

set -eu -o pipefail

curl -s https://raw.githubusercontent.com/cloudfoundry/community/main/toc/working-groups/foundational-infrastructure.md \
    | awk '/^```yaml$/{flag=1;next}/^```$/{flag=0}flag' | spruce json \
    | jq -r '.areas | map(.repositories) | flatten | .[]'
