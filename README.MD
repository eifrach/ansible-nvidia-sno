# Assisted Installer SNO 
This  Ansible is used to deploy SNO clusters on remote nodes. The default CPU arch used is `arm64`. 
 


## The Setup
This ansible Run's on a `jump host` in the environment, There is setup all the required services to boot pxe hosts ( DHCP, HTTP and TFTP). 
The deployed node **must** be in the same network as the jump host in order for `DHCP` to boot PXE the node.
 
The `PULL_SECRET_FILE` and `SSH_PUB_KEY_FILE` are delegated to the local host therefore, the files should be located on the same host running the ansible.


## Configurations

###  1. Set Inventory
```bash
ANSIBLE_HOST="serverXYZ"
ANSIBLE_USER="kni"


cp inventory/hosts.sample inventory/hosts
sed -i 's/host_name/$ANSIBLE_HOST/g;s/host_user/$ANSIBLE_USER/g' inventory/hosts
```

### 2. Set Variable
there are a few mandatory variable needed to be configured
you can use the "vars-sample.yml" to get all the avilable vars and default values

```bash
BMC_ADDRESS: "10.10.10.10"
BMC_USER: "bmc_user"
BMC_PASSWORD: "very_secret_password"

TOKEN: "some random string"
### can be created at https://console.redhat.com/openshift/token

PULL_SECRET_FILE: "/path/to/pull_secret"
### can be downloaded from: "https://console.redhat.com/openshift/install/pull-secret"

cp vars-sample.yaml vars.yaml
sed -i 's/TOKEN: ""/TOKEN: "$TOKEN"/g;
        s/PULL_SECRET_FILE: ""/PULL_SECRET_FILE: "$PULL_SECRET_FILE"/g;
        s/BMC_ADDRESS: ""/BMC_ADDRESS: "$BMC_ADDRESS"/g;
        s/BMC_USER: ""/BMC_USER: "$BMC_USER"/g;
        s/BMC_PASSWORD: ""/BMC_PASSWORD: "$BMC_PASSWORD"/g;' vars.yaml
```

**optional**: you can use Assisted Installer Dev API by updating the default value
```bash
echo 'API_URL: "http://my.dev.server:6000/api/assisted-install"' >> vars.yaml 
```
> Note:  
> When using the dev environment the token is still being used but no authentication is required. This is set for backward compatibility to the production api.
 


### Running playbook
```bash
ansible-playbook playbook.yaml
```



### Known Issues:
1. when re-running the playbook it creates a new cluster and does not use the previous cluster. This is because the cluster name and/or domain can be duplicated and only separated by the `CLUSTER_ID`
 
2. on the production AI, while waiting for the cluster to be installed it fails, due to the `API_TOKEN` timeout.

 
3. CPU Architecture `X86_64` not working, due different PXE files created in ISO 