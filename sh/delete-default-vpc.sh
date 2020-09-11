#!/bin/bash
export AWS_PAGER=''
export REGIONS=$(aws ec2 describe-regions | jq -r ".Regions[].RegionName")

for region in $REGIONS; do
    # list vpcs
    echo $region
    aws --region=$region ec2 describe-vpcs | jq ".Vpcs[]|{is_default: .IsDefault, cidr: .CidrBlock, id: .VpcId} | select(.is_default)"
done


for region in $REGIONS ; do
    echo "Processing vpc in $region"
    # list vpcs
    export IDs=$(aws --region=$region ec2 describe-vpcs | jq -r ".Vpcs[]|{is_default: .IsDefault, id: .VpcId} | select(.is_default) | .id")
    for id in "$IDs" ; do
        if [ -z "$id" ] ; then
            continue
        fi
        # kill igws
        for igw in `aws --region=$region ec2 describe-internet-gateways | jq -r ".InternetGateways[] | {id: .InternetGatewayId, vpc: .Attachments[0].VpcId} | select(.vpc == \"$id\") | .id"` ; do
            echo "Deleting igw $region $id $igw"
            aws --region=$region ec2 detach-internet-gateway --internet-gateway-id=$igw --vpc-id=$id
            aws --region=$region ec2 delete-internet-gateway --internet-gateway-id=$igw
        done

        # kill subnets
        for sub in `aws --region=$region ec2 describe-subnets | jq -r ".Subnets[] | {id: .SubnetId, vpc: .VpcId} | select(.vpc == \"$id\") | .id"` ; do
            echo "Deleting subnet $region $id $sub"
            aws --region=$region ec2 delete-subnet --subnet-id=$sub
        done

        echo "Deleting vpc $region $id"
        aws --region=$region ec2 delete-vpc --vpc-id=$id
    done
done