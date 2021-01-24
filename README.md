# terraform_w_aws
Terraform with aws by iamjjanga-ouo

## Project Point
1️⃣ I implemented interworking between 3-tier (WEB-WAS-DB) using Terraform and Ansible.  
2️⃣ If possible, 
- Provision of Cloud Resource → Terraform 
- Resource Management, Package Control → Ansible implementation  

3️⃣ I worked on the project by myself, but I configured Backend to manage Terraform in "tfstate" file (S3) and "lock" file (Dynamo DB) to enable simultaneous work.  
4️⃣ Ansible created individual roles to differentiate the concept of each package.
```
ansible
├── main.yml # main playbook
└── role
    ├── flask
    ├── mysql
    └── nginx
```
5️⃣ As it is a Test Project, the file containing the variable name is uploaded to public. (Excluding Secret KEY, SSL value, etc.)

## Prerequisite
- Python3
- AWS CLI v2
- Terraform Version >= v0.14.3

## Quick Start

1. Clone my project repo
```shell
$ git clone https://github.com/iamjjanga-ouo/terraform_w_aws.git
```
2. Initialize Terraform Backend
```shell
$ cd terraform_w_aws/init
$ terraform init
$ terraform apply
...
Enter a value: yes
```

3. Start Project Provision
```shell
$ cd ../aws-terraform-w-ansible
$ terraform init
$ terraform apply
...
Enter a value: yes
...
Wait provisioning....
```

clean this project
```shell
$ pwd
../aws-terraform-w-ansible
$ terraform destroy
Enter a value: yes

# you need to delete Backend S3, DynamoDB
$ cd ../init
$ python remove_s3.py # delete all s3 verisoned object
$ terraform destory
Enter a value: yes
```

## Korean Document ( Notion )
When you want to see a project notes(LANG : KR), Go into the notion [LINK](https://www.notion.so/sihyeonglee/Terraform-3-tier-w-Ansible-acab501ea1d543f096b42a92d61b9e46)