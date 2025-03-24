#!/bin/bash
set -e

echo "Step 1"
docker compose up -d

echo "Step 2"
ansible-playbook -i playbook/inventory/prod.yml playbook/site.yml --vault-password-file <(echo netology)

echo "Step 3"
docker compose down