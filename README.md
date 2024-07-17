# Docker Compose

```bash
./quick-start.sh
```

## Prerequisites
### Required
* Docker token for the Secoda private registry (supplied by Secoda).
* Ubuntu >= 20.04
* Docker >= 20.10.7
* Docker-compose >= 1.29.2
* 4 vCPU
* 16 GB RAM
* 32 GB disk space

### Optional

* A $PRIVATE_BUCKET has been created and an IAM role with the following permissions assigned.
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

Then uncomment the following lines in the docker-compose.yml file:
```yaml
#    volumes:
#      - ./on-premise.crt:/etc/ssl/certs/on-premise.crt
#      - ./on-premise.key:/etc/ssl/private/on-premise.key
```

### Troubleshoting

Error: ```Error response from daemon: Conflict. The container name "/postgres" is already in use by container "cb4ab20b3a0a0bb02d5bb6c4116a62fe945169d02bcb635e61af01c3175dbdce". You have to remove (or rename) that container to be able to reuse that name.```
Solution: `docker container prune -f`