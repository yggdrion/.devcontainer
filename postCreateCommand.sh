#!/bin/bash

GOSSM_VERSION="latest"
SHFMT_VERSION="latest"
SHELLCHECK_VERSION="latest"

pip install --upgrade pip
pip install -r requirements.txt
pip install -r .devcontainer/requirements.txt

git config --global user.email "rapha@r4b2.de"
git config --global user.name "r4b2"
git config --global pull.rebase false

sudo apt update
sudo apt -y install \
    vim jq zip unzip curl wget netcat-openbsd uuid-runtime redis-tools bash-completion dnsutils

function get_latest_github_release_version() {
    curl -s "https://api.github.com/repos/${GH_ORG}/${GH_REPO}/releases/latest" | jq -r '.tag_name'
}

function install_session_manager {
    curl -sL "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" \
        -o "/tmp/session-manager-plugin.deb"
    sudo dpkg -i "/tmp/session-manager-plugin.deb"
    rm "/tmp/session-manager-plugin.deb"
}

function install_gossm {
    GH_ORG="gjbae1212"
    GH_REPO="gossm"
    if [[ "${GOSSM_VERSION}" = "latest" ]]; then
        GOSSM_VERSION="$(get_latest_github_release_version)"
    fi
    DOWNLOAD_FILENAME="gossm_${GOSSM_VERSION/v/}_Linux_x86_64.tar.gz"
    curl -sL \
        "https://github.com/${GH_ORG}/${GH_REPO}/releases/download/${GOSSM_VERSION}/${DOWNLOAD_FILENAME}" \
        -o "/tmp/${DOWNLOAD_FILENAME}"
    tar -xf "/tmp/${DOWNLOAD_FILENAME}" -C /tmp/
    sudo mv "/tmp/gossm" "/usr/local/bin/"
    sudo chmod +x "/usr/local/bin/gossm"
}

function install_shfmt {
    GH_ORG="mvdan"
    GH_REPO="sh"
    if [[ "${SHFMT_VERSION}" = "latest" ]]; then
        SHFMT_VERSION="$(get_latest_github_release_version)"
    fi
    DOWNLOAD_FILENAME="shfmt_${SHFMT_VERSION}_linux_amd64"
    sudo curl -sL \
        "https://github.com/${GH_ORG}/${GH_REPO}/releases/download/${SHFMT_VERSION}/${DOWNLOAD_FILENAME}" \
        -o "/usr/local/bin/shfmt"
    sudo chmod +x "/usr/local/bin/shfmt"
}

function install_shellcheck {
    GH_ORG="koalaman"
    GH_REPO="shellcheck"
    if [[ "${SHELLCHECK_VERSION}" = "latest" ]]; then
        SHELLCHECK_VERSION="$(get_latest_github_release_version)"
    fi
    DOWNLOAD_FILENAME="shellcheck-${SHELLCHECK_VERSION}.linux.x86_64.tar.xz"
    curl -sL \
        "https://github.com/${GH_ORG}/${GH_REPO}/releases/download/${SHELLCHECK_VERSION}/${DOWNLOAD_FILENAME}" \
        -o "/tmp/${DOWNLOAD_FILENAME}"
    tar -xf "/tmp/${DOWNLOAD_FILENAME}" -C "/tmp/"
    sudo cp "/tmp/shellcheck-${SHELLCHECK_VERSION}/shellcheck" "/usr/local/bin/"
    rm -rf "/tmp/shellcheck-${SHELLCHECK_VERSION}"
    sudo chmod +x "/usr/local/bin/shellcheck"
}

install_session_manager
install_gossm
install_shfmt
install_shellcheck
