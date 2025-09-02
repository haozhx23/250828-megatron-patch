#!/usr/bin/bash
# TorchTitan Kubernetes Training Script
# Adapted from original run_train.sh for multi-node K8s deployment

set -ex

# Get environment variables from K8s
# NGPU=${NGPU:-"8"}
export LOG_RANK=${LOG_RANK:-0}
CONFIG_FILE=${CONFIG_FILE:-"./torchtitan/models/llama3/train_configs/debug_model.toml"}
TRAIN_FILE=${TRAIN_FILE:-"torchtitan.train"}

# kubeflow v2 injected
echo "PET_NNODES: $PET_NNODES"
echo "PET_NPROC_PER_NODE: $PET_NPROC_PER_NODE"
echo "PET_NODE_RANK: $PET_NODE_RANK"
echo "PET_MASTER_ADDR: $PET_MASTER_ADDR"
echo "PET_MASTER_PORT: $PET_MASTER_PORT"
echo "JOBSET_NAME:" $JOBSET_NAME

export NCCL_DEBUG=INFO
export FI_PROVIDER=efa
export FI_EFA_USE_DEVICE_RDMA="1"
export FI_LOG_LEVEL="1"

torchrun \
    --nnodes=$PET_NNODES \
    --nproc_per_node=$PET_NPROC_PER_NODE \
    --node_rank=$PET_NODE_RANK \
    --master_addr=$PET_MASTER_ADDR \
    --master_port=$PET_MASTER_PORT \
    --local-ranks-filter $LOG_RANK \
    --role rank \
    --tee 3 \
    -m ${TRAIN_FILE} \
    --job.config_file ${CONFIG_FILE} \
    "$@"
