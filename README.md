# ITI-DevOps-Final-Project-Infrastructure


## First
- Creating infrastructure using terraform

## Infrastructure commands using in project by terraform

```bash
terraform init 
terraform validate #to make sure there are no syntax errors
terraform plan #to make sure everything will be created correctly
terraform apply #to apply infrastructure on aws cloud provider 
```

## Build jenkins image

Build image for jenkins using Dockerfile and push it on Dockerhub


Dockerhub jenkins image repository: https://hub.docker.com/repository/docker/rahala7/jenkins-img/general


## connect to eks cluster
```bash
aws eks --region us-west-1 update-kubeconfig --name ITI-DevOps-Final-Project-cluster --profile default
```



## Setup a Cloud Storage to use it 
```bash
# deploy EFS storage driver
kubectl apply -k "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master"

# get VPC ID
aws eks describe-cluster --name ITI-DevOps-Final-Project-cluster --query "cluster.resourcesVpcConfig.vpcId" --output text
# Get CIDR range
aws ec2 describe-vpcs --vpc-ids vpc-0109080414bea298b --query "Vpcs[].CidrBlock" --output text
# security for our instances to access file storage
aws ec2 create-security-group --description efs-test-sg --group-name efs-sg --vpc-id vpc-0109080414bea298b
aws ec2 authorize-security-group-ingress --group-id sg-0f700fb1f19c7af34  --protocol tcp --port 2049 --cidr 10.0.0.0/16

# create storage
aws efs create-file-system --creation-token eks-efs

# create mount point 
aws efs create-mount-target --file-system-id fs-0c98b1cbecd98c585 --subnet-id subnet-0efcada565051f244 --security-group sg-0f700fb1f19c7af34

# grab our volume handle to update our PV YAML
aws efs describe-file-systems --query "FileSystems[*].FileSystemId" --output text
```

# Project requirements

## Use separate namespace for Jenkins's deployment and application's deployment 
```bash
kubectl create namespace jenkins
kubectl create namespace webapp
```

## Setup a storage for Jenkins
```bash
kubectl get storageclass
```

```bash
# create volume
kubectl apply -f ./pv.yaml 
kubectl get pv
```

```bash
# create volume claim
kubectl apply -n jenkins -f ./pvc.yaml
kubectl -n jenkins get pvc
```

## This step to deploy Jenkins
```bash
# rbac
kubectl apply -n jenkins -f ./rbac.yaml 

kubectl apply -n jenkins -f ./deployment.yaml
kubectl apply -n jenkins -f ./service.yaml

kubectl -n jenkins get pods
```

## Expose an external url 
```bash
kubectl get all -n jenkins 
```
Screenshot from 2023-02-17 20-47-19.png
Screenshot from 2023-02-17 20-50-38.png
Screenshot from 2023-02-17 22-03-00.png
Screenshot from 2023-02-17 22-04-07.png
Screenshot from 2023-02-17 22-05-50.png
Screenshot from 2023-02-17 22-07-38.png
