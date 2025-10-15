# Image Classification API

A Flask-based web API for classifying images as 'Real' or 'Fake' using a pre-trained TensorFlow MobileNet model. This project leverages deep learning to analyze uploaded images and provide predictions via a simple REST endpoint.

## Features

- Image upload and preprocessing for classification.
- CORS-enabled for cross-origin requests.
- Lightweight Flask server with error handling.
- Supports JPEG/PNG images resized to 224x224 pixels.
- Prediction threshold: >0.5 for 'Fake', else 'Real'.

## Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd <project-directory>
   ```

2. Install dependencies:
   ```bash
   pip install flask flask-cors tensorflow numpy pillow
   ```

3. Ensure the model file `best_model_MobileNet_3.keras` is in the project root. If not, train or download it.

4. Run the app:
   ```bash
   python app.py
   ```
   The server starts on `http://0.0.0.0:8000`.

## Usage

### API Endpoint

- **POST /predict**
  - Upload an image file to classify it.
  - Request: Multipart form-data with key `file` (image file).
  - Response: JSON with `Predicted` (e.g., `{"Predicted": "Real"}`) or error message.

Example using curl:
```bash
curl -X POST -F "file=@image.jpg" http://localhost:8000/predict
```

### Training Notebook

This notebook provides a comprehensive guide to training the MobileNet model used in this API on the 140k-real-and-fake-faces dataset. It covers:

- Data loading and preprocessing from the dataset.
- Model architecture setup and training.
- Evaluation metrics and performance analysis.
- Saving the trained model for deployment.

For the full code and step-by-step instructions, refer to the Kaggle notebook: [Mastere](https://www.kaggle.com/code/aziz0220/mastere).

## Requirements

- Python 3.7+
- TensorFlow 2.x
- Flask
- Pillow
- NumPy

## Contributing

1. Fork the repository.
2. Create a feature branch.
3. Submit a pull request.

## License

MIT License. See LICENSE file for details.
