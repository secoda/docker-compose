command_present() {
  type "$1" >/dev/null 2>&1
}

if ! command_present apt-get && command_present yum; then
  sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  sudo yum install jq gettext-base -y
else
  sudo apt install jq gettext-base -y
fi