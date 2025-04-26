from openai import OpenAI
import os
import sys
import textwrap
import pathlib

MAX_TOKENS = 6000  # to stay under the gpt-4 token limit

def split_text(text, max_chars):
    return textwrap.wrap(text, max_chars, break_long_words=False, break_on_hyphens=False)

def main():
    if len(sys.argv) < 2:
        print("Usage: python summarize.py <transcript_file>")
        return

    transcript_file = sys.argv[1]
    base_name = pathlib.Path(transcript_file).stem
    summary_filename = f"{base_name}_summary.txt"

    with open(transcript_file, "r") as f:
        transcript = f.read()

    client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

    chunks = split_text(transcript, 12000)  # ~12000 chars ≈ 4000 tokens

    all_summaries = []
    for i, chunk in enumerate(chunks):
        print(f"⏳ Summarizing chunk {i+1} of {len(chunks)}...")
        response = client.chat.completions.create(
            model="gpt-4o", 
            messages=[
            {"role": "system", "content": "Summarize this call and format using topics and subtopics."
            "Use bullet points for details. Be concise and clear, though top priority is to not leave out core details. "
            "Don't guess any missing information including acronyms." 
            "Don't give definitions and generally assume that the reader was the one who was on the call."}, 
                {"role": "user", "content": chunk}
            ]
        )
        summary = response.choices[0].message.content
        all_summaries.append(f"### Chunk {i+1} Summary ###\n{summary}\n")

    final_summary = "\n\n".join(all_summaries)
    print("\n=== FINAL SUMMARY ===\n")
    print(final_summary)

    with open(summary_filename, "w") as f:
        f.write(final_summary)

    print(f"\n✅ Summary saved to {summary_filename}")

if __name__ == "__main__":
    main()
