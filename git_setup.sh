#!/bin/bash

#############################
# Initialize Git repository
#############################

echo "Initializing Git repository"

# Initialize a new Git repository
git init

# Create a .gitignore file and add Terraform-related files to ignore
echo ".terraform/" > .gitignore
echo "terraform.tfstate" >> .gitignore
echo "terraform.tfstate.backup" >> .gitignore
echo ".terraform.lock.hcl" >> .gitignore

# Stage all files and make the initial commit
git add .
git commit -m "Initial commit: Terraform project to manage S3 bucket with versioning and lifecycle"

echo "✅ Terraform project setup complete and Git repository initialized!"