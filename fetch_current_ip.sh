#!/bin/bash
CURRENT_IP=$(curl -s ifconfig.co/ | xargs)
printf "ip_address = \"%s\"\n" "$CURRENT_IP" > terraform/ip.auto.tfvars