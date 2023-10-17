from ultralytics import YOLO
import cv2
import time
import traceback

# Load the YOLO model once
model_path = './model/best.pt'  # Adjust this path based on your setup
model = YOLO(model_path)

def predict_image(image_path):
    predictions = []
    start_time = time.time()
    
    try:
        img = cv2.imread(image_path)
        if img is None:
            raise ValueError(f"Image at {image_path} could not be read")
        
        H, W, _ = img.shape
        
        # Timing model inference
        inference_start = time.time()
        results = model(img)
        inference_end = time.time()
        
        for result in results:
            for j, mask in enumerate(result.masks.data):
                mask = mask.cpu().numpy() * 255
                mask = cv2.resize(mask, (W, H))
                output_path = f'./static/output/output_{j}.png'
                cv2.imwrite(output_path, mask)
                predictions.append(output_path)
        
        end_time = time.time()
        
        # Performance metrics
        print(f"Model Inference Time: {inference_end - inference_start:.2f} seconds")
        print(f"Total Execution Time: {end_time - start_time:.2f} seconds")
        
    except Exception as e:
        print(f"An error occurred: {e}")
        traceback.print_exc()  # This will print the full traceback of the error
        
    return predictions