#!/bin/bash

# This script will list all the resources in the AWS account
# Author: Jabeed
# Version: v0.0.1
#
# Following are the supported AWS services by the script
# 1. EC2
# 2. S3
# 3. RDS
# 4. DynamoDB
# 5. Lambda
# 6. EBS
# 7. CloudFront
# 8. CloudWatch
# 9. SNS
# 10. SQS
# 11. VPC
# 12. Route53
# 13. CloudFormation
# 14. IAM

# To modify the services, edit the GLOBAL_SERVICES and REGIONAL_SERVICES arrays below

GLOBAL_SERVICES=("S3" "CloudFront" "Route53" "IAM")
REGIONAL_SERVICES=("EC2" "DynamoDB" "Lambda" "RDS" "EBS" "CloudWatch" "SNS" "SQS" "VPC" "CloudFormation")

# Get all regions
REGIONS=$(aws ec2 describe-regions --query 'Regions[*].RegionName' --output text)

# Global services
echo "Global Services:"
echo "================="

for service in "${GLOBAL_SERVICES[@]}"; do
    echo "Service: $service"
    case $service in
        "S3")
            aws s3api list-buckets --query 'Buckets[*].Name' --output table
            ;;
        "CloudFront")
            aws cloudfront list-distributions --query 'DistributionList.Items[*].Id' --output table
            ;;
        "Route53")
            aws route53 list-hosted-zones --query 'HostedZones[*].Id' --output table
            ;;
        "IAM")
            aws iam list-users --query 'Users[*].UserName' --output table
            ;;
    esac
    echo ""
done

# Regional services
for region in $REGIONS; do
    echo "Region: $region"
    echo "==============="

    for service in "${REGIONAL_SERVICES[@]}"; do
        echo "Service: $service"
        case $service in
            "EC2")
                aws ec2 describe-instances --region $region --query 'Reservations[*].Instances[*].InstanceId' --output table
                ;;
            "DynamoDB")
                aws dynamodb list-tables --region $region --query 'TableNames' --output table
                ;;
            "Lambda")
                aws lambda list-functions --region $region --query 'Functions[*].FunctionName' --output table
                ;;
            "RDS")
                aws rds describe-db-instances --region $region --query 'DBInstances[*].DBInstanceIdentifier' --output table
                ;;
            "EBS")
                aws ec2 describe-volumes --region $region --query 'Volumes[*].VolumeId' --output table
                ;;
            "CloudWatch")
                aws cloudwatch describe-alarms --region $region --query 'MetricAlarms[*].AlarmName' --output table
                ;;
            "SNS")
                aws sns list-topics --region $region --query 'Topics[*].TopicArn' --output table
                ;;
            "SQS")
                aws sqs list-queues --region $region --query 'QueueUrls' --output table
                ;;
            "VPC")
                aws ec2 describe-vpcs --region $region --query 'Vpcs[*].VpcId' --output table
                ;;
            "CloudFormation")
                aws cloudformation list-stacks --region $region --query 'StackSummaries[*].StackName' --output table
                ;;
        esac
        echo ""
    done
done
