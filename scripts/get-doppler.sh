command_present() {
  type "$1" >/dev/null 2>&1
}

if ! command_present apt-get && command_present yum; then
  sudo chmod 777 /etc/yum.repos.d
  sudo touch /etc/yum.repos.d/doppler-cli.repo
  
  # Add Doppler's GPG key
  sudo rpm --import 'https://packages.doppler.com/public/cli/gpg.DE2A7741A397C129.key'

  sudo chmod 777  /etc/yum.repos.d/doppler-cli.repo
  
  # Add Doppler's yum repo
  sudo curl -sLf --retry 3 --tlsv1.2 --proto "=https" 'https://packages.doppler.com/public/cli/config.rpm.txt' > /etc/yum.repos.d/doppler-cli.repo

  # Update packages and install latest doppler cli
  sudo yum update && sudo yum install -y doppler
else
  # Install pre-reqs
  sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

  # Add Doppler's GPG key
  curl -sLf --retry 3 --tlsv1.2 --proto "=https" 'https://packages.doppler.com/public/cli/gpg.DE2A7741A397C129.key' | sudo apt-key add -

  # Add Doppler's apt repo
  echo "deb https://packages.doppler.com/public/cli/deb/debian any-version main" | sudo tee /etc/apt/sources.list.d/doppler-cli.list

  # Fetch and install latest doppler cli
  sudo apt-get update && sudo apt-get install doppler
fi