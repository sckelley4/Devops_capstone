# Use the official Python image as the base image
FROM python:3.8

# Set the working directory
WORKDIR /app

# Copy requirements.txt to the container
COPY requirements.txt ./

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code to the container
COPY . .

# Expose the port the application listens on
EXPOSE 5000

# Command to run the application
CMD [ "python", "app.py" ]
app.py for Service 2:

python
Copy code
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello from Service 2!\n'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)






