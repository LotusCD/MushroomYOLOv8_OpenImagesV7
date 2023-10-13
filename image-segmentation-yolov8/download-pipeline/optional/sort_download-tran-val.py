import os
import shutil

def get_file_id(filename):
    """Extract the ID from the filename (assuming the ID is the filename before the first underscore)"""
    return os.path.splitext(filename)[0]

def find_and_copy_mask(file_id, subfolders, masks_directory, destination_folder):
    """Search for the mask corresponding to the file_id and copy it to the destination_folder if found."""
    for subfolder in subfolders:
        subfolder_path = os.path.join(masks_directory, subfolder)
        for mask_file in os.listdir(subfolder_path):
            if mask_file.startswith(file_id):
                source_path = os.path.join(subfolder_path, mask_file)
                destination_path = os.path.join(destination_folder, file_id + '.png')
                
                print(f"Found match in {subfolder_path}. Copying {mask_file} to {destination_folder}...")
                shutil.copy(source_path, destination_path)
                return True  # Return True when mask found and copied
    return False  # Return False if mask not found

def process_folders(data_folder, masks_directory, destination_folder):
    data_files = [f for f in os.listdir(data_folder) if os.path.isfile(os.path.join(data_folder, f))]
    subfolders = [d for d in os.listdir(masks_directory) if os.path.isdir(os.path.join(masks_directory, d))]

    if not os.path.exists(destination_folder):
        print(f"Creating {destination_folder} folder...")
        os.makedirs(destination_folder)

    for file in data_files:
        print(f"Processing {file}...")
        file_id = get_file_id(file)
        mask_found = find_and_copy_mask(file_id, subfolders, masks_directory, destination_folder)

        if not mask_found:
            print(f"No match found for {file} in the masks subfolders.")

    print("Processing complete.")

def main():
    data_folder_train = 'open-images-v7-train/data'
    masks_directory_train = 'open-images-v7-train/labels/masks'
    destination_folder_train = os.path.join(os.getcwd(), 'extracted_masks_train')
    process_folders(data_folder_train, masks_directory_train, destination_folder_train)

    data_folder_val = 'open-images-v7-val/data'
    masks_directory_val = 'open-images-v7-val/labels/masks'
    destination_folder_val = os.path.join(os.getcwd(), 'extracted_masks_val')
    process_folders(data_folder_val, masks_directory_val, destination_folder_val)

if __name__ == '__main__':
    main()
