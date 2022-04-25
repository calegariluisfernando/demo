#!/bin/bash

cd iac

# Define the SSH key used authenticate in the provisioned servers.
echo "$DIGITALOCEAN_SSH_KEY" > /tmp/.id_rsa

# Define the SSH key permissions.
chmod og-rwx /tmp/.id_rsa

# Define the kubernetes client used to deploy the packages.
export KUBECTL_CMD=`which kubectl`

if [ -z "$KUBECTL_CMD" ]; then
  KUBECTL_CMD=./kubectl
fi

# Define the terraform client used to provision the infrastructure.
export TERRAFORM_CMD=`which terraform`

if [ -z "$TERRAFORM_CMD" ]; then
  TERRAFORM_CMD=./terraform
fi

# Check if the terraform settings environment is created.
if [ ! -d "~/.terraform.d" ]; then
  mkdir -p ~/.terraform.d
fi

# Check if the terraform authentication settings is created.
if [ ! -f "~/.terraform.d/credentials.tfrc.json" ]; then
  # Create the credentials files.
  cp credentials.tfrc.json /tmp

  sed -i -e 's|${TERRAFORM_TOKEN}|'"$TERRAFORM_TOKEN"'|g' /tmp/credentials.tfrc.json

  mv /tmp/credentials.tfrc.json ~/.terraform.d
fi

# Check if the GCP authentication settings is created.
sed -i -e 's|${GOOGLE_PROJECT_KEY}|'"$GOOGLE_PROJECT_KEY"'|g' google.credential.file.json
sed -i -e 's|${GOOGLE_PRIVATE_KEY_ID}|'"$GOOGLE_PRIVATE_KEY_ID"'|g' google.credential.file.json
sed -i -e 's|${GOOGLE_PRIVATE_KEY}|'"$GOOGLE_PRIVATE_KEY"'|g' google.credential.file.json
sed -i -e 's|${GOOGLE_CLIENT_EMAIL}|'"$GOOGLE_CLIENT_EMAIL"'|g' google.credential.file.json
sed -i -e 's|${GOOGLE_CLIENT_ID}|'"$GOOGLE_CLIENT_ID"'|g' google.credential.file.json
sed -i -e 's|${GOOGLE_AUTH_URI}|'"$GOOGLE_AUTH_URI"'|g' google.credential.file.json
sed -i -e 's|${GOOGLE_URI_TOKEN}|'"$GOOGLE_URI_TOKEN"'|g' google.credential.file.json
sed -i -e 's|${GOOGLE_CERT_URL}|'"$GOOGLE_CERT_URL"'|g' google.credential.file.json

# Execute the provisioning based on the IaC definition file (terraform.tf).
$TERRAFORM_CMD init --upgrade
$TERRAFORM_CMD apply -auto-approve \
                     -var "digitalocean_token=$DIGITALOCEAN_TOKEN" \
                     -var "digitalocean_ssh_key=$DIGITALOCEAN_SSH_KEY" \
                     -var "linode_token=$LINODE_TOKEN" \
                     -var "linode_ssh_key=$LINODE_SSH_KEY" \
                     -var "google_credential_file=google.credential.file.json" \
                     -var "google_project_id=$GOOGLE_PROJECT_KEY" \
                     -var "k3s_token=$K3S_TOKEN" #\
                     #-var "datadog_agent_key=$DATADOG_AGENT_KEY"

# Get the IP of the cluster manager used to deploy the application.
export CLUSTER_MANAGER_IP=$($TERRAFORM_CMD output -raw cluster-manager-ip)

# Get and set the kubernetes settings used to orchestrate the deploy the application.
scp -i /tmp/.id_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$CLUSTER_MANAGER_IP:/etc/rancher/k3s/k3s.yaml /tmp/.kubeconfig

sed -i -e 's|127.0.0.1|'"$CLUSTER_MANAGER_IP"'|g' /tmp/.kubeconfig

cp ./kubernetes.yml /tmp/kubernetes.yml

# Define the version to be deployed.
DATABASE_BUILD_VERSION=$(md5sum -b /tmp/demo-database.tar | awk '{print $1}')
BACKEND_BUILD_VERSION=$(md5sum -b /tmp/demo-backend.tar | awk '{print $1}')
FRONTEND_BUILD_VERSION=$(md5sum -b /tmp/demo-frontend.tar | awk '{print $1}')

sed -i -e 's|${REPOSITORY_URL}|'"$REPOSITORY_URL"'|g' /tmp/kubernetes.yml
sed -i -e 's|${REPOSITORY_ID}|'"$REPOSITORY_ID"'|g' /tmp/kubernetes.yml
sed -i -e 's|${DATABASE_BUILD_VERSION}|'"$DATABASE_BUILD_VERSION"'|g' /tmp/kubernetes.yml
sed -i -e 's|${BACKEND_BUILD_VERSION}|'"$BACKEND_BUILD_VERSION"'|g' /tmp/kubernetes.yml
sed -i -e 's|${FRONTEND_BUILD_VERSION}|'"$FRONTEND_BUILD_VERSION"'|g' /tmp/kubernetes.yml

# Deploy the application.
$KUBECTL_CMD --kubeconfig=/tmp/.kubeconfig apply -f /tmp/kubernetes.yml

# Clear temporary files.
rm -f /tmp/kubernetes.yml*
rm -f /tmp/.kubeconfig*
rm -f /tmp/.id_rsa*

cd ..