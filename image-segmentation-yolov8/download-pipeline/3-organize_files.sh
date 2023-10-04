#!/bin/bash

# This is just a way to automate a bit the process of getting the train images from the open-images-v7 and filing to with their masks equivalents in a new folder
# Which is needed to use on the "image-segmentation-yolov8" project
# Define the source and target directories
extracted_masks_folder="./extracted_masks/"
data_images_folder="../open-images-v7/open-images-v7/train/data/"
training_data_folder="./training_data_images"

# Create the target directories if they do not exist
mkdir -p "$training_data_folder/Images"
mkdir -p "$training_data_folder/Masks"

# Copy the contents of the source directories to the target directories
rsync -av --include='*/' --include='*.*' --exclude='*' "$extracted_masks_folder" "$training_data_folder/Masks"
rsync -av --include='*/' --include='*.*' --exclude='*' "$data_images_folder" "$training_data_folder/Images"
