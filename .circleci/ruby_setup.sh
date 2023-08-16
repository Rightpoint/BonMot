#!/bin/bash -eo pipefail

# Ensure any error stops the script
set -e

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Please install it first."
    exit 1
fi

# Check if rbenv is installed; if not, install it
if ! command -v rbenv &> /dev/null; then
    echo "Installing rbenv..."
    brew install rbenv
    # Check if rbenv init line is already present in .bash_profile, if not, add it
	if ! grep -q 'eval "$(rbenv init -)"' ~/.bash_profile; then
	    echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
	fi

    source ~/.bash_profile
else
    echo "rbenv is already installed."
fi

# Check if ruby-build is installed; if not, install it
if ! brew list ruby-build &> /dev/null; then
    echo "Installing ruby-build..."
    brew install ruby-build
else
    echo "ruby-build is already installed."
fi

# Ensure ruby-build is up-to-date
brew update && brew upgrade ruby-build

# Check if Ruby 3.0.6 is already installed; if not, install it
if ! rbenv versions | grep -q 3.0.6; then
    echo "Installing Ruby 3.0.6..."
    rbenv install 3.0.6
else
    echo "Ruby 3.0.6 is already installed."
fi

# Set the global Ruby version to 3.0.6
echo "Setting global Ruby version to 3.0.6..."
rbenv global 3.0.6
