# https://askubuntu.com/questions/459402/how-to-know-if-the-running-platform-is-ubuntu-or-centos-with-help-of-a-bash-scri

command_present() {
  type "$1" >/dev/null 2>&1
}

if ! command_present apt-get && command_present yum; then
  sudo amazon-linux-extras install docker -y
  sudo service docker start
  sudo usermod -a -G docker [user]
else
  wget -qO- https://get.docker.com/ | sh
fi