# Github actions which drive the BOSH Ecosystem Bot

## Adding a repo

Grant Admin permission to the orgs bosh-admin-bot team (in the case of for example the cloudfoundry org this would be [bosh-admin-bot](https://github.com/orgs/cloudfoundry/teams/bosh-admin-bot)).

Once access is granted wait for the [update-repository-list](https://github.com/pivotal-cf/bosh-ecosystem-bot/actions/workflows/update-repository-list.yml) action to update [repositories.list](https://github.com/pivotal-cf/bosh-ecosystem-bot/blob/main/repositories.list). This will then trigger the subsequent actions to [RP cfgitbot-config](https://github.com/pivotal-cf/bosh-ecosystem-bot/actions/workflows/update-cfgitbot-config.yml) to update [config-production.yml](https://github.com/pivotal-cf/cfgitbot-config/blob/master/config-production.yml) and [finally to start closing stale issues](https://github.com/pivotal-cf/bosh-ecosystem-bot/actions/workflows/stale.yml).


## Local Development requirments

- Install [act](https://github.com/nektos/act)
