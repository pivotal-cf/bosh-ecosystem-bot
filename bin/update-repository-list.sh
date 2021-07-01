#!/bin/bash

for org in cloudfoundry cloudfoundry-incubator bosh-packages bosh-io pivotal-cf bosh-tools pivotal; do
gh api graphql --paginate -f query="
  query(\$endCursor: String) {
    organization(login: \"${org}\") {
      teams(first: 100, after: \$endCursor, query: \"bosh\") {
        nodes {
	  repositories {
	    nodes { 
	      url
	      viewerPermission
	      isArchived
	      isPrivate
	    }
	  }
          name
        }
      }
    }
  }
" 
done | jq -r -s '
     map(.data.organization.teams.nodes) | flatten 
     | map(.repositories.nodes | map(select(.viewerPermission == "ADMIN" and .isArchived == false))) | flatten
     | map("\(.url | split("/")[3:5] | join("/"))") | sort | unique | .[]
' > repositories.list
