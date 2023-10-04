from ultralytics import YOLO

import cv2


model_path = 'C:\\Users\\newHope\\Documents\\Proyectos\\segmentation_tutorial\\image-segmentation-yolov8\\runs\\segment\\train\\weights\\last.pt'

image_path = 'C:\\Users\\newHope\\Downloads\\Fungus\\Amanita_muscaria_(1)_(8692325426).jpg'

img = cv2.imread(image_path)
H, W, _ = img.shape

model = YOLO(model_path)

results = model(img)

for result in results:
    for j, mask in enumerate(result.masks.data):

        mask = mask.cpu().numpy() * 255

        mask = cv2.resize(mask, (W, H))

        cv2.imwrite('.\\output\\output.png', mask)

