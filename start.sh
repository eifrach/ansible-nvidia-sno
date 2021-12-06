#!/bin/bash
ANSIBLE_HOST="serverXYZ"
ANSIBLE_USER="kni"

BMC_ADDRESS="10.10.10.10"
BMC_USER="bmc_user"
BMC_PASSWORD="very_secret_password"

INTERFACE="eth0"

TOKEN="some random string"
### can be created at https://console.redhat.com/openshift/token
PULL_SECRET_FILE="/path/to/pull_secret"
### can be downloaded from: "https://console.redhat.com/openshift/install/pull-secret"

API_URL=""

echo "Creating Hosts file..."
cp inventory/hosts.sample inventory/hosts
sed -i "s/host_name/$ANSIBLE_HOST/g; \
        s/host_user/$ANSIBLE_USER/g" inventory/hosts

echo "Updating vars"

cp vars-sample.yaml vars.yaml
sed -i "s#TOKEN.*#TOKEN: $TOKEN#g; \
        s#PULL_SECRET_FILE.*#PULL_SECRET_FILE: $PULL_SECRET_FILE#g; \
        s#BMC_ADDRESS:.*#BMC_ADDRESS: $BMC_ADDRESS#g; \
        s#BMC_USER:.*#BMC_USER: $BMC_USER#g; \
        s#BMC_PASSWORD:.*#BMC_PASSWORD: $BMC_PASSWORD#g; \
        s#INTERFACE.*#INTERFACE: $INTERFACE#g" vars.yaml



if [[ $API_URL != "" ]]
then
    echo "updateing API_URL"
    echo "API_URL: $API_URL" >> vars.yaml 
else
    echo "Working with Default API URL"
fi 


echo "Running playbook"
ansible-playbook playbook.yaml
