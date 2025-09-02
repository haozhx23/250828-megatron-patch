
## (Optional) build image
```
./build-image-ttt.sh
```

## Set environment
```
FSX_MOUNT_PATH=/your-prefix/fsx-mount-path/
cd $FSX_MOUNT_PATH
mkdir ttt_workspace && cd ttt_workspace
git clone https://github.com/pytorch/torchtitan.git
cp torchtitan-train-kfv2-dist.sh $FSX_MOUNT_PATH/torchtitan/
```

## 启动任务
```
kubectl apply -f torchtitan-kubeflowv2.yaml
```