import os
import cv2
from pathlib import Path

# Using pathlib to define paths
input_dir = Path('tmp/masks')
output_dir = Path('tmp/labels')

print("Mask to polygons started")

# Ensure output directory exists
output_dir.mkdir(parents=True, exist_ok=True)
print("OUTPUT: ",  output_dir) # OUTPUT:  tmp/labels
print("INPUT: ", input_dir) # INPUT:  tmp/masks

print(os.getcwd())


for j in input_dir.iterdir():
    print("J: ", input_dir)
    # Only process files, not directories
    if not j.is_file():
        continue

    # Load the binary mask and get its contours
    mask = cv2.imread(str(j), cv2.IMREAD_GRAYSCALE)
    _, mask = cv2.threshold(mask, 1, 255, cv2.THRESH_BINARY)

    H, W = mask.shape
    contours, hierarchy = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    # Convert the contours to polygons
    polygons = []
    for cnt in contours:
        if cv2.contourArea(cnt) > 200:
            polygon = []
            for point in cnt:
                x, y = point[0]
                polygon.append(x / W)
                polygon.append(y / H)
            polygons.append(polygon)

    # Write the polygons to file
    output_file = output_dir / (j.stem + '.txt')
    with output_file.open('w') as f:
        for polygon in polygons:
            for p_, p in enumerate(polygon):
                if p_ == len(polygon) - 1:
                    f.write('{}\n'.format(p))
                elif p_ == 0:
                    f.write('0 {} '.format(p))
                else:
                    f.write('{} '.format(p))
