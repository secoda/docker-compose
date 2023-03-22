command_present() {
  type "$1" >/dev/null 2>&1
}

if ! command_present aws; then
  echo "aws-cli is not installed. Installing now..."
else
  echo "aws-cli is already installed. Skipping installation."
  exit 0
fi

if ! command_present apt-get && command_present yum; then
  sudo yum install python python3-pip -y
else
  sudo apt install python python3-pip -y
fi

sudo pip3 install --upgrade awscli

