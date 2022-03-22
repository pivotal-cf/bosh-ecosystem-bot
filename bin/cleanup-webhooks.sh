#!/bin/bash

set -eu -o pipefail

for repo in $(comm -3 <(cat vmware_repositories.list | sort) <(cat repositories.list | sort)); do
    for hook_id in $(gh api -X GET /repos/${repo}/hooks | \
                         jq -r 'map(select(.config.url | test(".+(pivotaltracker|cfdredd|gitbot-v2).+"))) | .[].id'); do

        gh api -X DELETE /repos/${repo}/hooks/${hook_id}
    done
done
