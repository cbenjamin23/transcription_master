#!/bin/bash

# ========= Config =========
ENV_NAME="env"
TRANSCRIPT_FILE=$1
# ==========================

# --- 0. Check transcript file
if [ -z "$TRANSCRIPT_FILE" ]; then
  echo "❌ Usage: ./run.sh <transcript_file.txt>"
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

# --- 5. Install latest OpenAI Python SDK (>=1.0)
echo "📦 Installing latest OpenAI Python SDK (>=1.0)..."
pip install --upgrade openai

# --- 6. Export OpenAI API key (replace with your key!)
export OPENAI_API_KEY="insert_your_api_key_here"
echo "🔑 API key loaded."

# --- 7. Run the summarizer
echo "📝 Running summarizer on $TRANSCRIPT_FILE..."
python3 summarize.py "$TRANSCRIPT_FILE"

# --- 8. Completion message
BASE_NAME=$(basename "$TRANSCRIPT_FILE" .txt)
echo "✅ Summary saved to ${BASE_NAME}_summary.txt"

# --- 9. (Optional) Deactivate virtual environment
deactivate
echo "👋 Virtual environment deactivated."
