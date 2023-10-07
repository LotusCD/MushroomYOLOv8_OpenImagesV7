#!/bin/bash

# This script is for automating the picking of test data from the same train data.

root_dir="./code"

# Define the source and target directories
extracted_labels_folder="./extracted_labels/"
data_images_folder="open-images-v7/open-images-v7/train/data/"
training_images_folder="$root_dir/images/train"
test_images_folder="$root_dir/images/val"
training_labels_folder="$root_dir/labels/train"
test_labels_folder="$root_dir/labels/val"

# Create the target directories if they do not exist
mkdir -p "$training_images_folder"
mkdir -p "$test_images_folder"
mkdir -p "$training_labels_folder"
mkdir -p "$test_labels_folder"

# Copy all the contents of the source directories to the training directories
rsync -av --include='*/' --include='*.*' --exclude='*' "$extracted_labels_folder" "$training_labels_folder"
rsync -av --include='*/' --include='*.*' --exclude='*' "$data_images_folder" "$training_images_folder"

# Pick the last 300 files from each folder
last_images=$(ls "$training_images_folder" | tail -n 300)
last_labels=$(ls "$training_labels_folder" | tail -n 300)

# Move the selected images and labels to the test directories
for image in $last_images; do
    mv "$training_images_folder/$image" "$test_images_folder/$image"
done

for mask in $last_labels; do
    mv "$training_labels_folder/$mask" "$test_labels_folder/$mask"
done

