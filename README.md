# Megatron-LM Kubeflow Multinode



### 1. 代码下载
```sh
cd /mnt-fsx/mgtlm_workspace/
git clone https://github.com/NVIDIA/Megatron-LM.git && cd Megatron-LM
git checkout "core_r0.14.0"
```

FSx 初始目录结构：
   - `/mnt-fsx/mgtlm_workspace/Megatron-LM/`

### 2. 复制启动代码
```sh
cp train-llama-elastic.sh /mnt-fsx/mgtlm_workspace/Megatron-LM/
```

### 3. 任务启动
```sh
kubectl apply -f deploy-megatron.yaml

kubectl get trainjob megatron-multinode
kubectl get pods -l training.kubeflow.org/job-name=megatron-multinode
```
