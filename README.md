# OpenShift Træfik

This repository contains a dockerized version of [træfik](https://www.traefik.io)
to be used on OpenShift by running as a non-priviledged user.

## Run on docker

    docker run -d -p 8080:8080 -p 8443:8443 -p 8081:8081 -v $PWD/etc/traefik.toml:/traefik.toml -v $PWD/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt -it maro4inter/openshift-traefik

| Port | Protocol     |
| :------------- | :------------- |
| 8081       | http traffic |
| 8443       | https traffic (default) |
| 8080       | traefik dashobard (UI) |


## Create on openshift

    oc login https://<your-master-node>:8443
    oc new-project traefik
    oc create -f openshift/acme_secret.yaml
    oc create -f openshift/traefik_configmap.yaml
    oc create -f openshift/build.yaml
    oc create -f openshift/deployment.yaml
    oc create -f openshift/service.yaml


## Create on openshift with FULL template AllInOne

    oc login https://<your-master-node>:8443
    oc new-project traefik
    oc create -f openshift/traefik_full_template.yaml
