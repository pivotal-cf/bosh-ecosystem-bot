#

# Deploy

While on the Global Protect VPN login with the cf cli:
```
cf api https://api.sc2-04-pcf1-system.oc.vmware.com
cf auth deployadmin \
  $(bosh int <(lpass show --notes 7820272422089389421) --path /cf_password)
cf target -o bosh-io -s prod
```

To deploy the probot app run `./update.sh`
