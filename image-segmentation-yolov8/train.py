from ultralytics import YOLO

model = YOLO('yolov8n-seg.pt')  # load a pretrained model (recommended for training)
#Added main for windows compatibility
if __name__ == '__main__':
    # Your code here
    model.train(data='config.yaml', epochs=100, imgsz=640)