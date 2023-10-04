#!/bin/bash

# This script is for autoamting the picking of test data from the same train data.


# Define the source and target directories
extracted_masks_folder="./extracted_masks/"
data_images_folder="../open-images-v7/open-images-v7/train/data/"
training_data_folder="./training_data_images"
test_data_folder="./test_data_images"

# Create the target directories if they do not exist
mkdir -p "$training_data_folder/Images"
mkdir -p "$training_data_folder/Masks"
mkdir -p "$test_data_folder/Images"
mkdir -p "$test_data_folder/Masks"

# Copy all the contents of the source directories to the training directories
rsync -av --include='*/' --include='*.*' --exclude='*' "$extracted_masks_folder" "$training_data_folder/Masks"
rsync -av --include='*/' --include='*.*' --exclude='*' "$data_images_folder" "$training_data_folder/Images"

# Pick the last 300 files from each folder
last_images=$(ls "$training_data_folder/Images" | tail -n 300)
last_masks=$(ls "$training_data_folder/Masks" | tail -n 300)

# Move the selected images and masks to the test directories
for image in $last_images; do
    mv "$training_data_folder/Images/$image" "$test_data_folder/Images/$image"
done

for mask in $last_masks; do
    mv "$training_data_folder/Masks/$mask" "$test_data_folder/Masks/$mask"
done

# Optional: You might want to move the selected images and masks from the training to the test directories instead of copying.
# Uncomment the lines below if you want to move the files.
# for image in $last_images; do
#     mv "$training_data_folder/Images/$image" "$test_data_folder/Images/$image"
# done
#
# for mask in $last_masks; do
#     mv "$training_data_folder/Masks/$mask" "$test_data_folder/Masks/$mask"
# done
