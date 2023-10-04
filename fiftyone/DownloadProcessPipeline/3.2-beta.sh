#!/bin/bash

# Define the source and target directories
extracted_masks_folder="./extracted_masks/"
data_images_folder="../open-images-v7/open-images-v7/train/data/"
training_data_folder="./training_data_images"
tmp_masks_folder="../image-segmentation-yolov8/tmp/masks"
code_folder="../image-segmentation-yolov8/code"

# Create the target directories if they do not exist
mkdir -p "$training_data_folder/Images"
mkdir -p "$training_data_folder/Masks"
mkdir -p "$tmp_masks_folder"
mkdir -p "$code_folder/images/train"
mkdir -p "$code_folder/images/val"
mkdir -p "$code_folder/labels/train"
mkdir -p "$code_folder/labels/val"

# Copy the contents of the source directories to the target directories
rsync -av --include='*/' --include='*.*' --exclude='*' "$extracted_masks_folder" "$training_data_folder/Masks"
rsync -av --include='*/' --include='*.*' --exclude='*' "$data_images_folder" "$training_data_folder/Images"

# Move all mask files to tmp folder
mv "$training_data_folder/Masks"/* "$tmp_masks_folder"

# Run the masks_to_polygons.py script
python3 ../image-segmentation-yolov8/masks_to_polygons.py

# Copy the training_data_folder contents to the code folder
rsync -av "$training_data_folder/" "$code_folder/"

# Get the total number of images and masks
total_images=$(ls "$code_folder/images/train" | wc -l)
total_masks=$(ls "$code_folder/labels/train" | wc -l)

# Calculate the number of files to keep in the train folders
# by subtracting 300 from the total number of files
train_images=$((total_images - 300))
train_masks=$((total_masks - 300))

# Move the majority of files to the train folders, and the last 300 files to the val folders
for file in $(ls "$code_folder/images/train" | head -n $train_images); do
    mv "$code_folder/images/train/$file" "$code_folder/images/train/$file"
done

for file in $(ls "$code_folder/images/train" | tail -n 300); do
    mv "$code_folder/images/train/$file" "$code_folder/images/val/$file"
done

for file in $(ls "$code_folder/labels/train" | head -n $train_masks); do
    mv "$code_folder/labels/train/$file" "$code_folder/labels/train/$file"
done

for file in $(ls "$code_folder/labels/train" | tail -n 300); do
    mv "$code_folder/labels/train/$file" "$code_folder/labels/val/$file"
done
