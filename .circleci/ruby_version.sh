#!/bin/bash -eo pipefail

# Ensure any error stops the script
set -e

# Ensure rbenv is properly initialized
if ! command -v rbenv &> /dev/null; then
    echo "rbenv not found. Please install it first."
    exit 1
fi

echo "Initializing rbenv..."
source ~/.bash_profile

# Set the global Ruby version to 3.0.6
echo "Setting global Ruby version to 3.0.6..."
rbenv global 3.0.6
