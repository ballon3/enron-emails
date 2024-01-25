#!/bin/bash

# Directory to store the downloaded dataset
DATASET_DIR="./datasets"

# Create dataset directory if it doesn't exist
mkdir -p $DATASET_DIR

# URL of the Enron dataset
DATASET_URL="http://www.cs.cmu.edu/~enron/enron_mail_20110402.tgz"

# Download and unzip the dataset
wget -c $DATASET_URL -O - | tar -xz -C $DATASET_DIR

