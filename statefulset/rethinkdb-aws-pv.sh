#!/usr/bin/env bash

set -o pipefail

AWS_ZONE=${AWS_ZONE:-us-west-1a}
AWS_REGION=${AWS_REGION:-us-west-1}
VOL_SIZE=${VOL_SIZE:-30}

VOL_ID=$(aws ec2 create-volume \
    --region ${AWS_REGION} \
    --availability-zone ${AWS_ZONE} \
    --size ${VOL_SIZE} \
    --volume-type gp2 \
    | awk '{print $7}')

echo "EBS Volume ID: ${VOL_ID}"

echo "---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: rethinkdb
spec:
  capacity:
    storage: ${VOL_SIZE}Gi
  accessModes:
    - ReadWriteOnce
  awsElasticBlockStore:
    fsType: ext4
    volumeID: ${VOL_ID}
" > rethinkdb-aws-pv.yml
