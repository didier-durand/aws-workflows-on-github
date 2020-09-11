<img src="https://github.com/didier-durand/aws-workflows-on-github/blob/master/img/aws-logo.png" height="110">

# AWS SDK workflows on Github CI/CD

![workflow badge](https://github.com/didier-durand/aws-workflows-on-github/workflows/Deploy%20EC2%20instance/badge.svg)
![workflow badge](https://github.com/didier-durand/aws-workflows-on-github/workflows/Push%20to%20ECR/badge.svg)
![workflow badge](https://github.com/didier-durand/aws-workflows-on-github/workflows/Deploy%20to%20ECS/badge.svg)
![workflow badge](https://github.com/didier-durand/aws-workflows-on-github/workflows/Create%20EKS%20cluster/badge.svg)
![workflow badge](https://github.com/didier-durand/aws-workflows-on-github/workflows/Use%20log%20services/badge.svg)
![workflow badge](https://github.com/didier-durand/aws-workflows-on-github/workflows/Create%20VPC/badge.svg)
![workflow badge](https://github.com/didier-durand/aws-workflows-on-github/workflows/Use%20network%20components/badge.svg)
![workflow badge](https://github.com/didier-durand/aws-workflows-on-github/workflows/Regions%20and%20zones/badge.svg)
![workflow badge](https://github.com/didier-durand/aws-workflows-on-github/workflows/Use%20S3%20buckets/badge.svg)
![workflow badge](https://github.com/didier-durand/aws-workflows-on-github/workflows/Get%20services%20descriptions/badge.svg)

This repository contains [Github Actions / Workflows](https://github.com/features/actions) executing scripts that are frequently needed in the implementation of applications hosted on the cloud with [Amazon Web Services (AWS)](https://aws.amazon.com/). These scripts are based on CLI commands of the [AWS SDK](https://aws.amazon.com/cli/) to allow complete automation, basis of best DevOps practices. To be properly triggered and executed on Github CI/CD environment, they need to be located in [/.github directory](https://github.com/didier-durand/gcloud-tests/tree/master/.github/workflows).

All details about used commands can be found in [AWS SDK CLI Reference](https://aws.amazon.com/cli/). On purpose, those commands are implemented with minimum set of options and parameters to keep them as neutral as possible for reuse in other projects.

Go to the [Actions tab](https://github.com/didier-durand/aws-workflows-on-github/actions) to see the results of the last executions of the workflows reported by the badges here above: They include all the log messages produced the Github's Ubuntu workflow runner. Those executions are scheduled on a recurring basis (at least weekly) using Github's cron facility to ensure that they keep working as expected. The scripts include numerous checks ensuring proper behavior.

If you would like to see a new workflow on a different topic in this collection, please, open a ticket on this project. If you like this project, feel free to give it a star to make it more visible to others!

## available AWS workflows:

The YAML files below are located in directory [/.github directory](https://github.com/didier-durand/aws-workflows-on-github/tree/master/.github/workflows):

1. **[aws-ec2.yml](https://github.com/didier-durand/aws-workflows-on-github/blob/master/.github/workflows/aws-ec2.yml)**: workflow to interact with [AWS Elastic Compute Cloud (EC2)](https://aws.amazon.com/ec2/): list existing EC2 compute instances, create an instance, describe it to validate its running status, stop & delete it.
2. **[aws-ecr.yml](https://github.com/didier-durand/aws-workflows-on-github/blob/master/.github/workflows/aws-ecr.yml)**: workflow to test the build of an image on Github and its push to [AWS Elastic Container Registry (ECR)](https://aws.amazon.com/ecr/). Then, the image is described. Finally, it is deleted for cleanup of test environment.
3. **[aws-ecs.yml](https://github.com/didier-durand/aws-workflows-on-github/blob/master/.github/workflows/aws-ecs.yml)**: workflow to test the deployment of a public Docker image ([tutum/hello-world](https://hub.docker.com/r/tutum/hello-world/) - stored on Docker Hub)  to [AWS Elastic Container Service (ECS)](https://aws.amazon.com/ecs/). For this purpose, some network elements (VPC, subnets, routing table, etc.) are created. Then, an ECS cluster in instantiated in this VPC. Next step is to create the service (based on the previously registered task definition) to activate the Docker image. Then, the service public accessibility is validated from Github via CURL. Finally, all created elements are gracefully deleted in reverse order of creation to ensure proper cleanup.
4. **[aws-eks.yml](https://github.com/didier-durand/aws-workflows-on-github/blob/master/.github/workflows/aws-eks.yml)**: workflow to test automated creation of a Kubernetes cluster on [AWS Elastics Kubernetes Service (EKS)](https://aws.amazon.com/eks/). It automatically creates a minimal configuration of 3 nodes, trigger a K8s service deployment for standard [Docker image tutum/hello-world]() , check the proper functioning of the service via curl. Finally, the workflow deletes the cluster. **Note:** some  may be needed as the EKS cluster creation can last 20+ minutes. Also, it may take some time for EKS to create and publish DNS name of the service deployed on Kubernetes, and then for this name to get known on the worldwide Internet DNS servers: 2 ad hoc wait loops have been added to the script to cope with this. 
5. **[aws-log.yml](https://github.com/didier-durand/aws-workflows-on-github/blob/master/.github/workflows/aws-log.yml)**: workflow to list all active logs in [AWS CloudWatch Logs](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/WhatIsCloudWatchLogs.html) and all possible resource descriptors. The script also writes a log message in a new test log and reads the last entries produced by all writers to make sure written entry is present. The log aggregation process is asynchronous: a wait loop is used to make sure that the written test log entry appears in the read step. Finally, the test log is destroyed.
6. **[aws-network.yml](https://github.com/didier-durand/aws-workflows-on-github/blob/master/.github/workflows/aws-network.yml)**: this workflow interacts with the servces of [AWS Networking](https://aws.amazon.com/mp/scenarios/networking/) to create and combine standard components needed in a standard setup: vpc, subnets, routing table, security group. Those components are then diassembled and deleted in proper order to ensure graceful cleanup.
7. **[aws-s3.yml](https://github.com/didier-durand/aws-workflows-on-github/blob/master/.github/workflows/aws-s3.yml)**: workflow to interact with [AWS Simple Storage Service](https://aws.amazon.com/s3/): list existing buckets, create a new bucket, write file(s) to it from Github CI/CD, read file(s) from it, list bucket content and delete it.
8. **[aws-iam.yml](https://github.com/didier-durand/aws-workflows-on-github/blob/master/.github/workflows/aws-iam.yml)**: based on [AWS Identity and Access Management Services](https://aws.amazon.com/iam/), workflow to create a role and attach an AWS-managed policy to it for use in processes requiring tight security withh specific roles Then, cleanup is done. Also, all existing AWS security policies are listed.
9. **[aws-regions-zones.yml](https://github.com/didier-durand/aws-workflows-on-github/blob/master/.github/workflows/aws-regions-zones.yml)**: workflow to interact with regions and zones provided by [AWS Regions and Zones](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html). Aws CLI commands used here are useful for workflows automating large-scale applications spanning several regions, when specific actions (reorg, cleanup, etc.)  are needed in those zones.
10. **[aws-services.yml](https://github.com/didier-durand/aws-workflows-on-github/blob/master/.github/workflows/aws-services.yml)**: listing features of [AWS Products & Services](https://aws.amazon.com/products/) are used to obtain list of all services and their pricing model. Also, a check on possible values for some attribute ('volumeType') of EC2 is executed.

Go to the [Actions tab](https://github.com/didier-durand/aws-workflows-on-github/actions) to see the results of their last executions. **NB:** Github does a very good job in protecting the defined secrets: each time the value of some secret (see below) is written in output streams, the Github writer will replace it with ***. Remember it as you read the job executions logs in Actions.

## setup for forks:

When you fork this repository to run it on your own, you will need to recreate three [Github secrets](https://docs.github.com/en/actions/configuring-and-managing-workflows/using-variables-and-secrets-in-a-workflow) in your own repository for workflows to work properly: 

- ${{ secrets.AWS_ACCESS_KEY_ID }}: the access key under which those workflows to run
- ${{ secrets.AWS_SECRET_ACCESS_KEY }}: the secret key validating the use of the above access key
- ${{ secrets.AWS_REGION }}: the region in which you want those workflows to execute

Given the purpose of this project, we definitely took a shortcut on the security side : we gave [Administator Access](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_job-functions.html#jf_administrator) (AWS ARN = arn:aws:iam::aws:policy/AdministratorAccess) to our user with the access key here above so that we do not have to give specific authorizations for each AWS service used by the palette of workflows. Of course, this should be tightened with different users each having more constrained privileges in a productive environment.