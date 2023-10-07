import fiftyone as fo
import fiftyone.zoo as foz


# Download mushroom images from the Open Images Dataset V7
# The fiftyone library will create an 'open-images-v7' folder.

# Customize where zoo datasets are downloaded
print("Download script started")
fo.config.dataset_zoo_dir = "./open-images-v7"

dataset = foz.load_zoo_dataset(
              "open-images-v7",
              split="train",
              label_types=["segmentations"],
              classes=["Mushroom"],
              max_samples=10000,
          )