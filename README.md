# Automated Network Deployment: Startup

Disclaimer: This is not an official Google product.

Demonstration of Google Cloud Deployment Manager and Terraform for automated
deployment of Google Cloud Platform (GCP) network infrastructure.

This code supports 2 tutorials for exploring automated network deployments on
Google Cloud Platform:

*   Automated Network Deployment: Overview: set up your environment with
    credentials.
*   Automated Network Deployment: Startup: explore a simple deployment example
    with both Google Cloud Deployment Manager and Terraform.

## Quick Start

Shortened instructions to get started:

### Overview

*   Create project gcp-automated-networks.
*   Enable billing.
*   Enable APIs: Compute Engine API, and Cloud Deployment Manager API.
*   Activate Google Cloud Shell. Use Cloud Shell because the Google Cloud SDK
    (gcloud) and other tools are included.
*   git clone https://github.com/GoogleCloudPlatform/autonetdeploy-startup.git
*   cd autonetdeploy-startup
*   Install Terraform: ./get_terraform.sh
    *   export PATH=${HOME}/terraform:$ {PATH}
*   Setup GCP credentials.
    *   Use Google Cloud Console to get Compute Engine default service account
        credentials as a JSON file named [project-id]-[unique-id].json.
    *   Upload the file to Cloud Shell.
    *   Create GCP credentials: ./gcp_set_credentials.sh
        ~/[project-id]-[unique-id].json
    *   Activate: gcloud auth activate-service-account --key-file
        ~/.config/gcloud/credentials_autonetdeploy.json
*   Setup AWS credentials.
    *   After you sign in to the AWS Management Console, create an access key
        file: accessKeys.csv.
    *   Upload accessKeys.csv to Cloud Shell.
    *   Create AWS credentials: ./aws_set_credentials.sh ~/accessKeys.csv
*   Setup GCP environment
    *   gcloud config set project [YOUR-PROJECT-ID]
    *   ./gcp_set_project.sh
*   Initialize the Google provider.
    *   pushd ./terraform && terraform init && popd > /dev/null
*   Generate an SSH key-pair.
    *   ssh-keygen -t rsa -f ~/.ssh/vm-ssh-key -C [USERNAME]
    *   chmod 400 ~/.ssh/vm-ssh-key
*   Import key file to GCP
    *   gcloud compute config-ssh --ssh-key-file=~/.ssh/vm-ssh-key
*   Import key file to AWS
    *   Download the ~/.ssh/vm-ssh-key.pub using Cloud Shell.
    *   Use the AWS Management Console Import Key Pair option to import the
        downloaded file.

### Startup

*   Deploy a Google Cloud Engine (GCE) VM instance with Cloud Deployment
    Manager.
    *   pushd deploymentmanager
    *   Examine configuration files.
    *   gcloud deployment-manager deployments create defaultvm-deployment
        --config ./autonetdeploy_config.yaml
    *   gcloud deployment-manager deployments list
    *   gcloud deployment-manager deployments describe defaultvm-deployment
    *   gcloud compute instances list
    *   ssh -i ~/.ssh/vm-ssh-key [GCP_EXTERNAL_IP]
    *   ping -c 5 google.com
    *   curl ifconfig.co/ip
    *   exit
    *   gcloud deployment-manager manifests list --deployment
        defaultvm-deployment
    *   gcloud deployment-manager manifests describe [MANIFEST_FILE_NAME]
        --deployment defaultvm-deployment
    *   gcloud deployment-manager deployments delete defaultvm-deployment
    *   gcloud deployment-manager deployments list
    *   popd
*   Deploy a Google Cloud Engine (GCE) VM instance with Terraform.
    *   pushd terraform
    *   Examine configuration files.
    *   terraform validate
    *   terraform plan
    *   terraform apply
    *   terraform output
    *   terraform show
    *   gcloud compute instances list
    *   ssh -i ~/.ssh/vm-ssh-key [GCP_EXTERNAL_IP]
    *   ping -c 5 google.com
    *   curl ifconfig.co/ip
    *   exit
*   Clean up
    *   terraform plan -destroy
    *   terraform destroy
    *   terraform show
    *   popd

## License

Copyright 2017 Google Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License. You may obtain a copy of the
License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.
