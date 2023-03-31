# Docker Compose

## OS Requirements

* Ubuntu >= 20.04
* Docker >= 20.10.7
* Docker-compose >= 1.29.2

## Minimum Specifications

* 4 vCPU
* 16 GB RAM

## Prerequisites
### Mandatory Prerequisites
* Docker token for the Secoda private registry (supplied by Secoda).

### Optional Prerequisites
#### Optional Bucket

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

#### Optional TLS

Preqrequisites:
* Ensure that a certificate has been created for the domain name that will be used to access the Secoda platform. Ensure that it is a valid, signed certificate.

Setup:
Add the following to the docker-compose directory:
* on-premise.crt - the X509 certificate file in PEM format
* on-premise.key - the private key file in PEM format

## Quick Start

```bash
./quick-start.sh
```
