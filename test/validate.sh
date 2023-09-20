#!/bin/bash

set -e

kubectl port-forward -n test deploy/test-deploy 9000:80 &

sleep 1

echo "======== VALIDATING ENPOINT ==========="
curl -s -o /dev/null -w ''%{http_code}'' localhost:9000
echo "======== VALIDATING DONE =============="
