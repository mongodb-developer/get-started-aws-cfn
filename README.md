# Get-Started AWS

Repository to help getting started with using MongoDB Atlas with AWS CloudFormation.

## Information

This Get-Started project uses the [MongoDB Atlas AWS Quick Start](https://github.com/aws-quickstart/quickstart-mongodb-atlas) and the [MongoDB Atlas CloudFormation Resources](https://github.com/aws-quickstart/quickstart-mongodb-atlas-resources).

The project will deploy the MongoDB Atlas AWS Quick Start which provisions complete MongoDB Atlas deployments through CloudFormation using official MongoDB Atlas AWS CloudFormation Resource Types.

After you `get-started.sh` with this Get-Started project you will have a complete MongoDB Atlas deployment managed through AWS CloudFormation. This includes:

* 1 Project
* 1 M10 MongoDB Atlas Cluster
* 1 AWS IAM Role
* 1 MongoDB Atlas Database User (Type/AWS IAM Role)
* 1 Project Ip Access List entry
* VPC Peering (optional) [TODO/ need add this option to get-started]

The outputs include a lambda ready IAM Role and connection string to your new MongoDB Atlas Cluster.

## Pre-requisites 

### AWS Tooling

In order to use this Get-Started project you need to install the AWS cli on your machine.
You can download and install from: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html

### Docker 

Have Docker running on your machine. You can download and install from: https://docs.docker.com/install/

### MongoDB Atlas

In order to execute the code example, you need to have: 

* Create an organizational-level [MongoDB Atlas Programmatic API](https://docs.atlas.mongodb.com/configure-api-access#programmatic-api-keys). The key needs `Project Creator` permissions.
* The aws cli setup and configured on your development machine. 

##  Execution Steps 

1. Optional - not required unless needing to refesh with latest resource source code.
   Build Docker image with a tag name. Within the top level directory execute: 
  ```
  docker build . -t atlas-aws
  ```
   This will build a docker image with a tag name `atlas-aws`. 

   *NOTE* Currently the source repositories are private which will prevent a clean build without proper Github ssh access. A pre-build image has been upload for convience until these repos become public: `jmimick/atlas-aws`. 

2. Execute the helper shell setup script. This will package and deploy the MongoDB Atlas CloudFormation resources into your current default AWS region. 
  ```
  ./get-setup.sh
  ```
  
  Until can build your own:

  ```
  ./get-setup.sh jmimick/atlas-aws
  ```

  Changing the region to deploy into is support by passing your default AWS cli config into the get-started Docker container. So you can run the deploy in another region with the following commands:
  ```
  aws configure set region eu-west-3
  ./get-setup.sh jmimick/atlas-aws
  ```
  Note this step can take up to 45 minutes to run.
  Run this step once in each region you wish to use.

3. Execute the helper shell starter script by providing the Quick Start name. The output from `get-setup.sh` helper script will inform you of the details for your new MongoDB Atlas deployment, including AWS AIM Role and Cluster connection string information for you apps. Note this step takes 7-10 minutes. 

  ```
  ./get-started.sh PUBLIC_KEY PRIVATE_KEY ORG_ID <GETSTARTED_NAME> <DOCKER_IMAGE>
  ```

  The `GETSTARTED_NAME` parameter is optional and defaults to `get-started-aws-quickstart`.

  Note - until source repos are public use this specfic image (change GETSTARTED_NAME to your own choosing):

  ```
  ./get-started.sh PUBLIC_KEY PRIVATE_KEY ORG_ID get-started-aws-quickstart jmimick/atlas-aws
  ```

  Once successful, you should be able to access your new deployment through the AWS console, the Atlas console or even the clis.

## Connecting to your cluster

You can see the connection information in the AWS CloudFormation stack output.

```bash
GETSTARTED_NAME="get-started-aws-quickstart"
MDB=$(aws cloudformation list-exports | \
 jq -r --arg stackname "${GETSTARTED_NAME}" \
 '.Exports[] | select(.Name==$stackname+"-ClusterSrvAddress") | .Value')
echo "Found stack:${GETSTARTED_NAME} with ClusterSrvAddress: ${MDB}"
```

_Note_ This example requires the `jq` tool. See: https://stedolan.github.io/jq/download/

## Tear Down 

How to remove the environment setup (deleting traces of this get-started project):

* Delete the Quick Start stack using the helper script or you can do this in the AWS Web Console or cli yourself.
  ```
  ./teardown.sh <GETSTARTED_NAME>
  ```

* Terminate the `get-started.sh` process if it's running. This is to stop the web service on `localhost:3000`.
* Delete the CloudFormation stack created, by default this will have the <Quick Start-Name>:
   ```
   aws cloudformation delete-stack --stack-name <Quick Start-Name>
   ```
* Remove the Docker volumes
* Remove the Docker image

## Tutorials

TODO - add links to repos, example stacks, using this with lambda

## About 

This project is part of the MongoDB Get-Started code examples. Please see [get-started-readme](https://github.com/mongodb-developer/get-started-readme) for more information. 


## Notes

To build the container - need this:
```
export DOCKER_BUILDKIT=1
docker build --ssh github=$HOME/.ssh/id_rsa -t atlas-aws .
```
