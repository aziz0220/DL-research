import pytest
from flask import Flask
from werkzeug.datastructures import FileStorage
import io
from app import app

def create_test_image():
    """Create a dummy image file for testing."""
    from PIL import Image
    img = Image.new('RGB', (224, 224), color='red')
    file_obj = io.BytesIO()
    img.save(file_obj, 'JPEG')
    file_obj.seek(0)
    return file_obj

@pytest.fixture
def client():
    app.testing = True
    with app.test_client() as client:
        yield client

def test_no_file_uploaded(client):
    """Test case for no file being uploaded."""
    response = client.post('/predict')
    assert response.status_code == 400
    assert response.json == {'error': 'No file uploaded'}

def test_no_file_selected(client):
    """Test case for empty file input."""
    data = {"file": (io.BytesIO(b""), "")}
    response = client.post('/predict', data=data, content_type='multipart/form-data')
    assert response.status_code == 400
    assert response.json == {'error': 'No file selected'}

def test_valid_image_prediction(client):
    """Test case for a valid image file."""
    test_image = create_test_image()
    data = {"file": (test_image, "real.jpg")}
    response = client.post('/predict', data=data, content_type='multipart/form-data')
    assert response.status_code == 200
    assert 'Predicted' in response.json
    expected_prediction = 'Real'
    assert response.json['Predicted'] == expected_prediction

def test_invalid_file_format(client):
    """Test case for invalid file format."""
    data = {"file": (io.BytesIO(b"Invalid content"), "test.txt")}
    response = client.post('/predict', data=data, content_type='multipart/form-data')

    assert response.status_code == 500
    assert 'error' in response.json

