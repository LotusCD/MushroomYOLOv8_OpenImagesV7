from ultralytics import YOLO
import cv2

# Load the YOLO model once
model_path = './model/best.pt'  # Adjust this path based on your setup
model = YOLO(model_path)

def predict_image(image_path):
    img = cv2.imread(image_path)
    H, W, _ = img.shape
    
    results = model(img)
    predictions = []
    
    for result in results:
        for j, mask in enumerate(result.masks.data):
            mask = mask.cpu().numpy() * 255
            mask = cv2.resize(mask, (W, H))
            output_path = './static/output/output_{}.png'.format(j)
            cv2.imwrite(output_path, mask)
            predictions.append(output_path)
    
    return predictions
