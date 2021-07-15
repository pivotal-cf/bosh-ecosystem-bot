#!/bin/bash

orgs=$(gh api graphql --paginate -f query='
  query($endCursor: String) {
    viewer {
      organizations(first: 100, after: $endCursor) {
	nodes { login }
	pageInfo {
	  hasNextPage
	  endCursor
	}
      }
    }
  }
' | jq -r -s '
  map(.data.viewer.organizations.nodes | map(.login))
  | flatten | sort | unique | .[]
')

all=""
for org in $orgs; do
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
