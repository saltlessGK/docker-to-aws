#!/bin/bash
printf "ip_address = \"$(curl -s https://api.ipify.org)\"" > terraform/ip.auto.tfvars
terraform -chdir=./terraform init
terraform -chdir=./terraform apply
ansible-playbook -i ansible/inventory.yml ansible/docker-playbook.yml --private-key ~/.ssh/aws_ssh --ssh-common-args='-o StrictHostKeyChecking=accept-new'
ansible-playbook -i ansible/inventory.yml ansible/db-playbook.yml --private-key ~/.ssh/aws_ssh --ssh-common-args='-o StrictHostKeyChecking=accept-new'
ansible-playbook -i ansible/inventory.yml ansible/backend-playbook.yml --private-key ~/.ssh/aws_ssh --ssh-common-args='-o StrictHostKeyChecking=accept-new'
ansible-playbook -i ansible/inventory.yml ansible/frontend-playbook.yml --private-key ~/.ssh/aws_ssh --ssh-common-args='-o StrictHostKeyChecking=accept-new'