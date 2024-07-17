
# Install dependencies:
./scripts/install.sh

# Check if .env exists:
if [ -f .env ]; then
  echo "It looks like you have already installed Secoda. If you want to reinstall, please remove the .env file and try again."

  # Ask if they would like to start the server:
  echo "Would you like to start the server now? (Y/n)"
  read -r START_SERVER

  if [ "$START_SERVER" != "n" ]; then
    ./scripts/update-secoda.sh
  fi
  exit 1
fi

FILE=$(mktemp)
openssl genrsa 2048 > "$FILE"
export PUBLIC_KEY=$(openssl rsa -pubout -in $FILE | base64 | tr -d \\n)
export PRIVATE_KEY=$(cat $FILE | base64 | tr -d \\n)
export SECRET=$(openssl rand -hex 20 | cut -c 1-32)
export PASSWORD=$(openssl rand -hex 20 | cut -c 1-16)

echo "What is your docker token supplied by Secoda?"
read -r DOCKER_TOKEN

docker login -u secodaonpremise --password $DOCKER_TOKEN

# Confirm last command was successful:
if [ $? -ne 0 ]; then
  echo "Docker token is invalid. Please try again."
  exit 1
fi

# Ask if they would like to setup an S3 bucket
echo "Would you like to setup an S3 bucket? (Y/n)"
read -r SETUP_S3

if [ "$SETUP_S3" != "n" ]; then
  echo "What is the name of your S3 bucket?"
  read -r BUCKET

  # Ask if they would like to setup an S3 bucket for backups, and if so, for their access keys:
  echo "What is the name of your S3 bucket?"
  read -r BUCKET

  echo "What is your S3 access key?"
  read -r ACCESS_KEY

  echo "What is your S3 secret key?"
  read -r SECRET_KEY

  # Test the AWS credentials for the S3 bucket:
  echo "Testing AWS credentials..."
  # Test putting a file in the bucket:
  echo "Testing AWS credentials by putting a file in the bucket..."
  echo "This is a test file." > test.txt
  AWS_ACCESS_KEY_ID=$ACCESS_KEY AWS_SECRET_ACCESS_KEY=$SECRET_KEY aws s3 cp test.txt s3://$BUCKET/test.txt

  # Confirm last command was successful:
  if [ $? -ne 0 ]; then
    echo "AWS credentials are invalid. Please try again."
    exit 1
  fi

  rm test.txt

  echo "Setting cron job to run backups every day at 3am."
  echo "Ensure your backups are working properly by manual confirmation tomorrow."

  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  echo "0 3 * * * /bin/bash $DIR/scripts/backup.sh" | sudo tee -a /etc/crontab
fi

export DOCKER_TOKEN
export BUCKET
export ACCESS_KEY
export SECRET_KEY

cat cp.env | envsubst \$PUBLIC_KEY,\$PRIVATE_KEY,\$SECRET,\$PASSWORD,\$BUCKET,\$ACCESS_KEY,\$SECRET_KEY,\$DOCKER_TOKEN > .env


# Ask if they would like to start the server:
echo "Would you like to start the server now? (Y/n)"
read -r START_SERVER

if [ "$START_SERVER" != "n" ]; then
  ./scripts/update-secoda.sh
fi