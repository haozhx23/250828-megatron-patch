

# wget -O Dockerfile https://raw.githubusercontent.com/aws-samples/awsome-distributed-training/refs/heads/main/3.test_cases/megatron/megatron-lm/aws-megatron-lm.Dockerfile

# sed -i 's/core_v0.12.1/core_r0.14.0/' Dockerfile

algorithm_name=aws-dlc-base-ttt

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" -s)
region=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/region)
# region=$(aws configure get region)
account=$(aws sts get-caller-identity --query Account --output text)

aws ecr describe-repositories --region $region --repository-names "${algorithm_name}" > /dev/null 2>&1
if [ $? -ne 0 ]
then
echo "create repository:" "${algorithm_name}"
aws ecr create-repository --region $region  --repository-name "${algorithm_name}" > /dev/null
fi

aws ecr get-login-password --region ${region}|docker login --username AWS --password-stdin "${account}.dkr.ecr.${region}.amazonaws.com"

docker build --no-cache -t ${algorithm_name} -f Dockerfile.dlcbase.torchtitan .

fullname="${account}.dkr.ecr.${region}.amazonaws.com/${algorithm_name}:latest"
docker tag ${algorithm_name} ${fullname}
docker push ${fullname}

echo $fullname