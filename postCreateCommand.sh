#!/bin/bash

pip install --upgrade pip
pip install -r requirements.txt
pip install -r requirements-dev.txt

git config --global user.email "rapha@r4b2.de"
git config --global user.name "r4b2"

sudo apt update
sudo apt -y install vim
sudo wget https://github.com/mvdan/sh/releases/download/v3.7.0/shfmt_v3.7.0_linux_amd64 -O /usr/local/bin/shfmt
