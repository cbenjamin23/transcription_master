#!/bin/bash

# ========= Config =========
ENV_NAME="env"
AUDIO_FILE=$1
# ==========================

# --- 0. Check audio file
if [ -z "$AUDIO_FILE" ]; then
  echo "❌ Usage: ./transcribe.sh <audio_file.m4a>"
  exit 1
fi

# --- 1. Check for Python 3
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 is not installed. Please install Python 3 and rerun this script."
    exit 1
fi

# --- 2. Create virtual environment if needed
if [ ! -d "$ENV_NAME" ]; then
  echo "📦 Creating virtual environment..."
  python3 -m venv $ENV_NAME
fi

# --- 3. Always activate the virtual environment
echo "🚀 Activating virtual environment..."
source $ENV_NAME/bin/activate

# --- 4. Upgrade pip
echo "🔧 Upgrading pip..."
pip install --upgrade pip

# --- 5. Install whisper if needed
if ! pip show openai-whisper &> /dev/null; then
  echo "🧠 Installing Whisper..."
  pip install openai-whisper
fi

# --- 6. Create output folder
BASE_NAME=$(basename "$AUDIO_FILE" | cut -d. -f1)
OUTPUT_FOLDER="./${BASE_NAME}_transcription"

mkdir -p "$OUTPUT_FOLDER"

# --- 7. Run Whisper
echo "🎤 Transcribing $AUDIO_FILE ..."
whisper "$AUDIO_FILE" --model small --output_dir "$OUTPUT_FOLDER"

# --- 8. Completion message
echo "✅ Transcription complete. Files saved to $OUTPUT_FOLDER"

# --- 9. (Optional) Deactivate virtual environment
deactivate
echo "👋 Virtual environment deactivated."
