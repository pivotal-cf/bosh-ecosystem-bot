# Github actions which drive the BOSH Ecosystem Bot

## Adding a repo

Grant Admin permission to the orgs bosh-admin-bot team (in the case of for example the cloudfoundry org this would be [bosh-admin-bot](https://github.com/orgs/cloudfoundry/teams/bosh-admin-bot)).

Once access is granted wait for the [update-repository-list](https://github.com/pivotal-cf/bosh-ecosystem-bot/actions/workflows/update-repository-list.yml) action to update [repositories.list](https://github.com/pivotal-cf/bosh-ecosystem-bot/blob/main/repositories.list). This will then trigger the subsequent actions to [RP cfgitbot-config](https://github.com/pivotal-cf/bosh-ecosystem-bot/actions/workflows/update-cfgitbot-config.yml) to update [config-production.yml](https://github.com/pivotal-cf/cfgitbot-config/blob/master/config-production.yml) and [finally to start closing stale issues](https://github.com/pivotal-cf/bosh-ecosystem-bot/actions/workflows/stale.yml).


## Local Development requirments

### Install [act](https://github.com/nektos/act)
The `act` cli can be installed using brew:
```
brew install act
```

### Create .secrets file:
To be able to interact with GitHub some secrets are needed. Act by default will read these from a `.secrets` file.
On GitHub these secrets are configured using [Action Secrets](https://github.com/pivotal-cf/bosh-ecosystem-bot/settings/secrets/actions).

```
GH_TOKEN=$(bosh int <(lpass show --notes "bosh-ecosystem-bot") --path /github_bot_personal_access_token)
echo "GH_TOKEN=${GH_TOKEN}" > .secrets
echo "GITHUB_TOKEN=${GH_TOKEN}" >> .secrets
```

### Download act image
When running `act` for the first time it will ask which image to use. Unfortunatly we depend on ruby which is only
included in the large image. At the time of writing this image is around 20GB big, so depending on your internet connection might take a while to download.

### Run an action
Available actions can be found by running `act -l`.
Now start the action locally by running for example:
```
act -j update_repositories --rm
```

### Kill hanging actions
Sometimes `act` keeps haninging after executing an action. Luckely it just uses Docker under the hood.
```
docker ps --filter "name=act" --format '{{.ID}}' | xargs docker rm -f
```

### Enter act container
```
docker exec -it $(docker ps --filter "name=act" --format '{{.ID}}' | head -n 1) /bin/bash
```
