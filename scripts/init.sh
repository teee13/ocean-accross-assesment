#!/bin/bash
set -e
STACK=${1:-shared-platform}
cd "$(dirname "$0")/.."
terraform -chdir=stacks/$STACK init
