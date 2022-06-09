#!/bin/zsh

# Upgrade everything
sudo apt update && sudo apt upgrade -y

# AWS cli
echo -e "complete -C /usr/local/bin/aws_completer aws" >> ~/.zshrc

# Terraform
echo -e "alias tf='terraform'" >> ~/.zshrc
echo -e "complete -F __start_terraform tf" >> ~/.zshrc
terraform -install-autocomplete

source ~/.zshrc
