#!/bin/bash

set -x

# Set the repository URL
#REPO_URL="https://<ACCESS-TOKEN>@dev.azure.com/<AZURE-DEVOPS-ORG-NAME>/voting-app/_git/voting-app"

REPO_URL="https://47olv............................@dev.azure.com/mrbalraj/Multi-Tier-With-Database/_git/Multi-Tier-With-Database"

# Clone the git repository into the /tmp directory
git clone "$REPO_URL" /tmp/temp_repo

# Navigate into the cloned repository directory
cd /tmp/temp_repo

# Print the current directory and list files
pwd
ls -la

# Read the containerRegistry value from the .yml file
containerRegistry=$(grep 'containerRegistry:' Multi-Tier-With-Database/azure-pipelines.yml | awk '{print $2}' | tr -d "'")

# Make changes to the Kubernetes manifest file(s)
# Update the specific image name along with the container registry name in the specified deployment.yaml file
if [ -f "k8s-specifications/$4.yaml" ]; then
  sed -i "s|image: $containerRegistry/dev:latest|image: $1/$2:$3|g" k8s-specifications/$4.yaml
else
  echo "File k8s-specifications/$4.yaml does not exist."
  exit 1
fi

# Configure Git user
git config user.name "Balraj Singh"
git config user.email "your-email@example.com"

# Add the modified files
git add .

# Commit the changes
git commit -m "Update Kubernetes manifest"

# Push the changes back to the repository
git push

# Cleanup: remove the temporary directory
rm -rf /tmp/temp_repo

