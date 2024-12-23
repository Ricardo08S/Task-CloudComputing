from flask import Flask, request, jsonify, send_file, Response
import qrcode
import os
from io import BytesIO
import logging

app = Flask(__name__)
UPLOAD_FOLDER = "/app/generated_qrcodes"
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

logging.basicConfig(level=logging.DEBUG)

@app.route('/generate', methods=['POST'])
def generate_qrcode():
    try:
        # Validate input
        data = request.json.get("data")
        if not data:
            app.logger.error("No data provided in request")
            return jsonify({"error": "No data provided"}), 400

        # Generate QR Code
        qr = qrcode.make(data)
        buffer = BytesIO()
        qr.save(buffer, format="PNG")
        buffer.seek(0)

        app.logger.info("QR Code generated successfully and returned as response")
        return Response(buffer, mimetype='image/png')

    except Exception as e:
        app.logger.error(f"Error generating QR Code: {e}")
        return jsonify({"error": "Internal Server Error"}), 500

@app.route('/')
def home():
    return jsonify({"message": "QR Code Generator is running! Use /generate to create QR Codes."})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5008)
