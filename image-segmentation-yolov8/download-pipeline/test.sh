#!/bin/bash

# Define the source and target directories
extracted_masks_folder="./extracted_masks/"
tmp_masks_folder="../tmp/masks"

mkdir -p "$tmp_masks_folder"


# Copy the extracted_masks folder to ../tmp/masks
rsync -av --include='*/' --include='*.*' --exclude='*' "$extracted_masks_folder" "$tmp_masks_folder"

# Now run the masks_to_polygons script
python3 ../masks_to_polygons.py

