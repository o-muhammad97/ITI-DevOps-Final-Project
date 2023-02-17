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
![image](https://user-images.githubusercontent.com/101838529/219526903-3490ea12-8b84-4020-8ec7-cc2565379c5e.png)

## Setup a storage for Jenkins
```bash
kubectl get storageclass
```
![image](https://user-images.githubusercontent.com/101838529/219527910-7c73db75-968e-4011-8b2f-04adc5faa607.png)

```bash
# create volume
kubectl apply -f ./pv.yaml 
kubectl get pv
```
![image](https://user-images.githubusercontent.com/101838529/219528252-3964ef91-b550-4743-9c26-e330c8329e18.png)

```bash
# create volume claim
kubectl apply -n jenkins -f ./pvc.yaml
kubectl -n jenkins get pvc
```
![image](https://user-images.githubusercontent.com/101838529/219528653-c1f0c108-e673-47c8-8e51-300de3547e09.png)

## This step to deploy Jenkins
```bash
# rbac
kubectl apply -n jenkins -f ./rbac.yaml 

kubectl apply -n jenkins -f ./deployment.yaml
kubectl apply -n jenkins -f ./service.yaml

kubectl -n jenkins get pods
```
![image](https://user-images.githubusercontent.com/101838529/219534060-9c994f26-a6fb-4735-9d04-9634b2991ddb.png)

## Expose an external url 
```bash
kubectl get all -n jenkins 
```
![image](https://user-images.githubusercontent.com/101838529/219534644-e78f2fdc-a9b4-48a3-9cb2-a0bbea1b7447.png)
