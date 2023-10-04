#!/bin/bash

# Define the source and target directories
extracted_masks_folder="./extracted_masks/"
data_images_folder="../open-images-v7/open-images-v7/train/data/"
training_data_folder="./training_data_images"
tmp_masks_folder="../../image-segmentation-yolov8/tmp/masks"
code_folder="../../image-segmentation-yolov8/code"

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

echo "Executed the copy of Masks to tmp..."

# Run the masks_to_polygons.py script
python3 ../../image-segmentation-yolov8/masks_to_polygons.py

echo "Executed python script to create polygons."

# Create images folder inside code
mkdir -p "$code_folder/images"

# Copy the training_data_folder/Images contents to the code folder
rsync -av "$training_data_folder/Images/" "$code_folder/images/train"

# Move the last 300 images to the 'code/images/val' folder
for image in $(ls "$code_folder/images/train" | tail -n 300); do
    mv "$code_folder/images/train/$image" "$code_folder/images/val/$image"
done

echo "Moved images to train and val folders."

# Create labels folder inside code
mkdir -p "$code_folder/labels"

# Copy the tmp/masks contents to the code folder
rsync -av "$tmp_masks_folder/" "$code_folder/labels/train"

# Move the last 300 masks to the 'code/labels/val' folder
for mask in $(ls "$code_folder/labels/train" | tail -n 300); do
    mv "$code_folder/labels/train/$mask" "$code_folder/labels/val/$mask"
done

echo "Moved masks to train and val folders."

# End of script