from flask import Flask, request, jsonify, Response
import qrcode
import os
from io import BytesIO
import logging
import time

app = Flask(__name__)

UPLOAD_FOLDER = os.path.expanduser("/root/generated_qrcodes")
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

logging.basicConfig(level=logging.DEBUG)

@app.route('/generate', methods=['POST'])
def generate_qrcode():
    try:
        data = request.json.get("data")
        if not data:
            app.logger.error("No data provided in request")
            return jsonify({"error": "No data provided"}), 400

        qr = qrcode.make(data)
        buffer = BytesIO()
        qr.save(buffer, format="PNG")
        buffer.seek(0)

        timestamp = int(time.time())
        qr_code_filename = f"{timestamp}.png"
        file_path = os.path.join(UPLOAD_FOLDER, qr_code_filename)

        app.logger.info(f"Saving QR code to {file_path}")

        with open(file_path, 'wb') as f:
            f.write(buffer.getvalue())

        app.logger.info(f"QR Code saved successfully: {file_path}")

        return jsonify({"message": "QR Code generated and saved", "file": qr_code_filename})

    except Exception as e:
        app.logger.error(f"Error generating QR Code: {e}")
        return jsonify({"error": "Internal Server Error"}), 500

@app.route('/')
def home():
    return jsonify({"message": "QR Code Generator is running! Use /generate to create QR Codes."})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5008)
