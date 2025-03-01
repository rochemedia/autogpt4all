#!/bin/bash

# Default URL
model_url="https://gpt4all.io/models/ggml-stable-vicuna-13B.q4_2.bin"

# Default uninstall option
uninstall=false

# Parse named arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --custom_model_url) model_url="$2"; shift ;;
        --uninstall) uninstall=true ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

if [ "$uninstall" = true ] ; then
    echo "Uninstalling..."
    rm -rf LocalAI
    rm -rf Auto-GPT
    exit 0
fi

# Check if the directory exists, if not clone the repository, else pull the latest changes
if [ ! -d "LocalAI" ]; then
  git clone https://github.com/go-skynet/LocalAI
else
  cd LocalAI
  git pull
  cd ..
fi

cd LocalAI
make build

# Only download the model if a custom URL is provided or if the model does not already exist
if [ ! -z "$2" ] || [ ! -f "models/gpt-3.5-turbo" ]; then
    wget $model_url -O models/gpt-3.5-turbo
fi

cd ..

# Check if on macOS, if so install extra prerequisites using brew
if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install cmake go
fi

# Check if the directory exists, if not clone the repository, else pull the latest changes
if [ ! -d "Auto-GPT" ]; then
  git clone -b stable https://github.com/Significant-Gravitas/Auto-GPT.git
  cp .env.template Auto-GPT/.env
else
  cd Auto-GPT
  git pull
  cd ..
fi
