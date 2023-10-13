import os
import shutil
from multiprocessing import Pool

def get_file_id(filename):
    return os.path.splitext(filename)[0]

def find_and_copy_mask(file_id, subfolders, masks_directory, destination_folder):
    for subfolder in subfolders:
        subfolder_path = os.path.join(masks_directory, subfolder)
        for mask_file in os.listdir(subfolder_path):
            if mask_file.startswith(file_id):
                source_path = os.path.join(subfolder_path, mask_file)
                destination_path = os.path.join(destination_folder, file_id + '.png')
                shutil.copy(source_path, destination_path)
                return True
    return False

def worker(file):
    print(f"Processing {file}...")
    file_id = get_file_id(file)
    mask_found = find_and_copy_mask(file_id, subfolders, masks_directory, destination_folder)
    if not mask_found:
        print(f"No match found for {file} in the masks subfolders.")

if __name__ == '__main__':
    data_folder = 'open-images-v7/open-images-v7/train/data'
    masks_directory = 'open-images-v7/open-images-v7/train/labels/masks'
    destination_folder = os.path.join(os.getcwd(), 'extracted_masks')
    
    data_files = [f for f in os.listdir(data_folder) if os.path.isfile(os.path.join(data_folder, f))]
    subfolders = [d for d in os.listdir(masks_directory) if os.path.isdir(os.path.join(masks_directory, d))]

    if not os.path.exists(destination_folder):
        print("Creating 'extracted_masks' folder...")
        os.makedirs(destination_folder)

    with Pool() as pool:
        pool.map(worker, data_files)

    print("Processing complete.")
