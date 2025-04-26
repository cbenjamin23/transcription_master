# transcription_master

# Overview
This repo is meant for transcribing and summarizing an audio file. The transcription and summarize scripts can be run independently in the main directory. 

Transcribing will, by default, create a sub-directory named after the file with different transcript forms including a raw .txt file and a .srt file with time-stamps.

Currently it has been tested exclusively on .mp4 files. All scripts create a virtual environment, install necessary dependencies, and deactivate the virtual environment upon exit.

# How to Use
**Transcribe and Summarize**
- chmod +x run.sh
- ./run.sh mp4_file_path

**Just Transcribe**
- chmod +x transcribe.sh
- ./transcribe.sh mp4_file_path

**Just Summarize**
- chmod +x summarize.sh
- ./summarize.sh mp4_file_name/mp4_file_name.txt

# Main Files
- **run.sh** is a master bash script that calls both the transcribe and summarize sub-scripts.
- **transcribe.sh** currently uses the openai whisper tool. The whisper model used is the "small" model for balanced speed and accuracy, but other options are tiny, base, small, medium, large, turbo. Total time is about 15 minutes to transcribe 45 minutes worth of conversation audio.
- **summarize.sh** has a block of instructions passed to the model as a string on how to summarize. This is easily customizable, so play around. The summarize script is also far faster than the transcibe script. Total time is 20 seconds to process 45 minutes worth of conversation text.
