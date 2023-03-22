./scripts/install.sh

Check if .env exists:
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
export PUBLIC_KEY=$(openssl rsa -pubout -in $FILE | base64)
export PRIVATE_KEY=$(cat $FILE | base64)
export SECRET=$(openssl rand -hex 20 | cut -c 1-32)
export PASSWORD=$(openssl rand -hex 20 | cut -c 1-16)

echo "What is your docker token (supplied by Secoda)?"
read -r DOCKER_TOKEN

# Ask if they would like to setup an S3 bucket for backups, and if so, for their access keys:
echo "Setup an S3 bucket? (Y/n)"
read -r BUCKET_SETUP

if [ "$BUCKET_SETUP" != "n" ]; then
  echo "What is the name of your S3 bucket?"
  read -r BUCKET

  echo "What is your S3 access key?"
  read -r ACCESS_KEY

  echo "What is your S3 secret key?"
  read -r SECRET_KEY

  echo "Enable S3 backups? (Y/n)"
  read -r S3_BACKUPS

  if [ "$S3_BACKUPS" != "n" ]; then
    
    echo "Setting cron job to run backups every day at 3am"

    # Get the current directory:
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    echo "0 3 * * * /bin/bash $DIR/scripts/backup.sh" | sudo tee -a /etc/crontab

  fi
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