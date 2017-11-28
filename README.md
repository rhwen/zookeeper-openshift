# zookeeper-openshift

## Build Docker Image
$ docker build -t registry.example.com:5000/rhwen-zookeeper:latest -f Dockerfile.rhel7 .

## Push Image Into Private Registry
$ docker push registry.example.com:5000/rhwen-zookeeper:latest 

## Run for test
$ docker run -it --rm registry.example.com:5000/rhwen-zookeeper:latest 

## Startup OpenShift Origin.
$ oc cluster up

## Startup OpenShift Origin with Persistent Volumes.
$ oc cluster up --host-config-dir='/Users/apple/.openshift/openshift.local.config' --host-data-dir='/Users/apple/.openshift/openshift.local.data' --host-pv-dir='/Users/apple/.openshift/openshift.local.pv' --host-volumes-dir='/Users/apple/.openshift/openshift.local.volumes' --use-existing-config=true --service-catalog=true

## Create Zookeeper Project login with developer
$ oc new-project zookeeper

## Add scc policy
$ oc adm policy add-scc-to-user anyuid system:serviceaccount:zookeeper:default

## Create resources with zookeeper.yaml
$ oc create -f zookeeper.yaml


## Reference
https://hub.docker.com/_/zookeeper/
https://kubernetes.io/docs/tutorials/stateful-application/zookeeper/
