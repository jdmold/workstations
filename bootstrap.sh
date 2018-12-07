#!/usr/bin/env bash
# Bootstrap the environment to install ansible, homebrew, and x-code select.

set -o errexit
set -o errtrace
set -o nounset

REPO="https://github.com/jdmold/workstations.git"
REPO_DIR="${HOME}/github/workstations"

if ! xcode-select --print-path &> /dev/null; then
    echo "Installing xcode-select."
    xcode-select --install &> /dev/null

    until xcode-select --print-path &> /dev/null; do
        sleep 2
    done
    echo "Done installing xcode-select."
else
    echo "xcode-select already installed."
fi

if test ! $(which brew); then
    echo "Installing homebrew."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    echo "Done installing homebrew."
else
    echo "Homebrew is already installed."
fi

if test ! $(which ansible); then
    echo "Installing Ansible."
    brew install ansible
    echo "Done installing Ansible."
else
    echo "Ansible already installed."
fi

if [[ ! -d "${REPO_DIR}" ]]; then
    echo "Creating ${REPO_DIR}"
    mkdir -p ${REPO_DIR}
    echo "Done creating ${REPO_DIR}"
    echo "Cloning workstations repository"
    git clone ${REPO} "${REPO_DIR}"
    echo "Done cloning workstations repository."
else
    echo "${REPO_DIR} already exists."
fi

cd ${REPO_DIR}

echo "Running workstations playbook."
ansible-playbook -K local.yml
