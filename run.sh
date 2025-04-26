#!/bin/bash

# ========= Config =========
AUDIO_FILE=$1
# ==========================

# --- 0. Check audio file input
if [ -z "$AUDIO_FILE" ]; then
  echo "❌ Usage: ./run.sh <audio_file.m4a>"
  exit 1
fi

# --- 1. Make helper scripts executable
chmod +x transcribe.sh
chmod +x summarize.sh

# --- 2. Run transcription
echo "🎤 Step 1: Transcribing $AUDIO_FILE ..."
./transcribe.sh "$AUDIO_FILE"

# --- 3. Find resulting .txt file
BASE_NAME=$(basename "$AUDIO_FILE" | cut -d. -f1)
TRANSCRIPT_FOLDER="./${BASE_NAME}_transcription"
TRANSCRIPT_FILE="${TRANSCRIPT_FOLDER}/${BASE_NAME}.txt"

if [ ! -f "$TRANSCRIPT_FILE" ]; then
  echo "❌ Transcript file not found at $TRANSCRIPT_FILE"
  exit 1
fi

# --- 4. Run summarization
echo "📝 Step 2: Summarizing transcript ..."
./summarize.sh "$TRANSCRIPT_FILE"

# --- 5. Move summary into transcription folder
SUMMARY_FILE="${BASE_NAME}_summary.txt"
if [ -f "$SUMMARY_FILE" ]; then
  echo "📦 Moving $SUMMARY_FILE into $TRANSCRIPT_FOLDER ..."
  mv "$SUMMARY_FILE" "$TRANSCRIPT_FOLDER/"
else
  echo "⚠️ Summary file $SUMMARY_FILE not found, cannot move."
fi

# --- 6. Done
echo "✅ All done! Files are in $TRANSCRIPT_FOLDER/"
