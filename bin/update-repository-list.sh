#!/bin/bash

all=""
for org in cloudfoundry cloudfoundry-incubator bosh-packages bosh-io pivotal-cf bosh-tools pivotal; do
out=$(gh api graphql --paginate -f query="
  query(\$endCursor: String) {
    organization(login: \"${org}\") {
      teams(first: 100, after: \$endCursor, query: \"bosh\") {
        nodes {
	  repositories {
	    nodes { 
	      url
	      viewerCanAdminister
	      isArchived
	    }
	  }
          name
        }
      }
    }
  }
")
all="${all}${out}"
done
echo ${all} | jq -r -s '
     map(.data.organization.teams.nodes) | flatten 
     | map(.repositories.nodes | map(select(.viewerCanAdminister and (.isArchived | not)))) | flatten
     | map("\(.url | split("/")[3:5] | join("/"))") | sort | unique | .[]
' > repositories.list
