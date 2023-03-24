# Docker Compose

## OS requirements

* Ubuntu >= 20.04
* Docker >= 20.10.7
* Docker-compose >= 1.29.2

## Minimum specifications

* 4 vCPU
* 16 GB RAM

## Prerequisites

* Docker token for the Secoda private registry (supplied by Secoda).
* Ensure that a $PRIVATE_BUCKET has been created and an IAM role with the following permissions assigned.
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowIAMRoleToManageBucket",
            "Effect": "Allow",
            "Action": [
                "s3:HeadBucket",
                "s3:ListBucket",
                "s3:PutObjectAcl",
                "s3:PutObject",
                "s3:GetObjectAcl",
                "s3:GetObject",
                "s3:CreateMultipartUpload",
                "s3:AbortMultipartUpload",
                "s3:ListMultipartUploadParts"
            ],
            "Resource": [
                "arn:aws:s3:::${PRIVATE_BUCKET}",
                "arn:aws:s3:::${PRIVATE_BUCKET}/*"
            ]
        }
    ]
}
```

## Quick Start

```bash
./quick-start.sh
```

[Additional documentation](https://www.notion.so/secoda/On-Prem-Deployment-bfc6e9c1f9f649349d8fb2722928dd6c)
