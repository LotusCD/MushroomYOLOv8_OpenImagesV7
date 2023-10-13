#!/bin/bash

# This script prepares and organizes datasets...

set_and_sort_download() {
    python3 set_download.py
    python3 sort_download.py
}

prepare_masks() {
    local extracted_masks_folder="./extracted_masks/"
    local tmp_masks_folder="../tmp/masks"
    
    mkdir -p "$tmp_masks_folder"
    rsync -av "$extracted_masks_folder" "$tmp_masks_folder"
    
    cd ..
    python3 masks_to_polygons.py

    # after running the script, clean the tmp/masks folder
    #pwd
    rm -r "tmp/masks"
    
    mkdir -p download-pipeline/extracted_labels
    mv tmp/labels/* download-pipeline/extracted_labels/
    cd download-pipeline
}

prepare_train_test_data() {
    local root_dir="./code"
    local extracted_labels_folder="./extracted_labels/"
    local data_images_folder="open-images-v7/open-images-v7/train/data/"
    local training_images_folder="$root_dir/images/train"
    local test_images_folder="$root_dir/images/val"
    local training_labels_folder="$root_dir/labels/train"
    local test_labels_folder="$root_dir/labels/val"
    
    mkdir -p "$training_images_folder" "$test_images_folder" "$training_labels_folder" "$test_labels_folder"
    
    rsync -av "$extracted_labels_folder" "$training_labels_folder"
    rsync -av "$data_images_folder" "$training_images_folder"
    
    local test_images=$(ls "$training_images_folder" | tail -n 201)
    local test_labels=$(ls "$training_labels_folder" | tail -n 201)
    
    for image in $test_images; do
        mv "$training_images_folder/$image" "$test_images_folder/$image"
    done
    
    for mask in $test_labels; do
        mv "$training_labels_folder/$mask" "$test_labels_folder/$mask"
    done

    #after finishing, clean unused images and labels
    # pwd
    # rm -r "/extracted_labels"
    # rm -r "/extracted_masks"

}

# Main Execution
set_and_sort_download
prepare_masks
prepare_train_test_data
