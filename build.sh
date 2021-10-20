if [[ ! $# -eq 1 ]]
  then
    echo "Arguments: <IMAGE_NAME>"
    exit 1
fi

IMAGE_NAME=$1

# AWS Account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Default AWS Region
AWS_REGION=$(aws configure get default.region)

# Building container images
docker build -t ${IMAGE_NAME}:app -f Dockerfile.app .
docker build -t ${IMAGE_NAME}:fn -f Dockerfile.fn .

# Create repository on Amazon ECR
aws ecr create-repository --repository-name ${IMAGE_NAME} --image-scanning-configuration scanOnPush=true

# Tag container images for Amazon ECR
docker tag ${IMAGE_NAME}:app ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_NAME}:app
docker tag ${IMAGE_NAME}:fn ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_NAME}:fn

# Login in to Amazon ECR
aws ecr get-login-password | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

# Push container images to Amazon ECR
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_NAME}:app
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_NAME}:fn
