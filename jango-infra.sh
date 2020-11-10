#!/bin/bash

export ENVIRONMENT=development

set -e

# rm -r plan

echo "creating safe health infrastructure
..................................................................
    1. Virtual private network(VPC)
    2. Elastic kubernetes cluster(EKS)
    3. security Groups(SG)
    4. Private and Public Subnets
    5. DNS (ROUTE 53)
...................................................................
"
make init
make plan apply

echo "your safe health infrastructure is ready"
