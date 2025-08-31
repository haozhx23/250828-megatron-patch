
export NUM_NODES=2
export MASTER_ADDR=10.11.162.237
export HOST_NVME=/STORAGE_PREFIX/mgtlm-test-1
export PYTORCH_IMAGE=public.ecr.aws/t5u4s6i0/nvcr-2503-efa-mg0140:latest


mkdir -p $HOST_NVME
cd $HOST_NVME

[ ! -d "Megatron-LM" ] && git clone https://github.com/NVIDIA/Megatron-LM.git
cd Megatron-LM
git checkout "core_r0.14.0"

cp train-llama-elastic.sh examples/llama/

export HOST_CHECKPOINT_PATH="$HOST_NVME/checkpoints/llama3_8b_fp8"
export HOST_TENSORBOARD_LOGS_PATH="$HOST_NVME/tensorboard_logs/llama3_8b_fp8"
export HOST_DATASET_PATH="$HOST_NVME/built_datasets"
export HOST_MEGATRON_LM_DIR="$HOST_NVME/Megatron-LM"

docker run --rm --gpus all --ipc=host --network=host --ulimit memlock=-1 \
  --device=/dev/infiniband/ \
  -v "${HOST_MEGATRON_LM_DIR}:/workspace/megatron-lm" \
  -v "${HOST_CHECKPOINT_PATH}:/workspace/checkpoints" \
  -v "${HOST_TENSORBOARD_LOGS_PATH}:/workspace/tensorboard_logs" \
  -v "${HOST_DATASET_PATH}:/workspace/built_datasets" \
  --device=/dev/infiniband/ \
  -e MASTER_ADDR=$MASTER_ADDR \
  -e NUM_NODES=$NUM_NODES \
  --workdir /workspace/megatron-lm \
  $PYTORCH_IMAGE \
  bash examples/llama/train-llama-elastic.sh \
  2>&1 | tee "~/train-logs/training_mock_$(date +'%y-%m-%d_%H-%M-%S').log"