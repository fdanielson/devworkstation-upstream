#!/bin/bash

# Function to check OS type
detect_os() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Linux"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "MacOS"
  else
    echo "Unsupported OS"
    exit 1
  fi
}

# Copy configuration files
copy_config_files() {
  cp zshrc ~/.zshrc
  cp tmux.conf ~/.tmux.conf
  cp vimrc ~/.vimrc
  mkdir -p ~/.config/nvim
  cp init.vim ~/.config/nvim/init.vim
}

# Source configuration files
source_config_files() {
  source ~/.zshrc
  tmux source-file ~/.tmux.conf
  source ~/.vimrc
}

# Install packages based on OS type
install_packages() {
  local os_type=$1

  if [ "$os_type" == "Linux" ]; then
    sudo apt update
    sudo apt install -y tmux git golang zsh wget curl neovim vim jq openssl python3 ruby php telnet tree yarn
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
    sudo apt update
    sudo apt install -y google-cloud-sdk
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    sudo apt install -y fasd
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    sudo apt --fix-broken install
    sudo snap install kustomize --classic
    sudo snap install dep --classic
    sudo snap install fzf --classic
    sudo snap install k9s --classic
    sudo snap install ksd --classic
    sudo snap install kubectx --classic
    sudo snap install kubectl --classic
    sudo snap install stern --classic
    sudo snap install tfenv --classic
    sudo snap install ytt --classic
  elif [ "$os_type" == "MacOS" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install tmux git go zsh wget curl neovim vim helm jq openssl python3 ruby php telnet tree yarn
    brew install kustomize dep fzf grep k9s ksd kubectx kubernetes-cli stern tfenv ytt
    brew tap google-cloud-sdk
    brew install google-cloud-sdk
    brew install --cask google-chrome
  fi
}

main() {
  local os_type=$(detect_os)
  echo "Detected OS: $os_type"
  install_packages $os_type
  copy_config_files
  source_config_files
}

main
