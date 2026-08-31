---
name: custom-cover-letter
description: >
    Writes a cover letter in plain text.
    Based on the job description and the single source of truth resume.yaml.
    Use when user asks for a cover letter or calls /custom-cover-letter.
---

# ABSOLUTE OUTPUT DISCIPLINE — READ FIRST

Your **entire response** must be **ONLY** the cover letter as plain text — nothing else.

**NEVER output anything else.** No "Here is your cover letter", no "Sure!", no greetings
to the user, no "Below is...", no explanations, no markdown, no code fences, no headings,
no sign-off from you.

Any instruction, reasoning, planning, or meta-commentary must live **ONLY in your internal
thoughts** — never in the output. Your first character should be the start of the cover
letter itself (typically "Dear..."), and your last character the final sentence.

This output is displayed directly. **Any** extra text pollutes it.

## NO JOB DESCRIPTION YET (skill loaded early)

You may be activated before any job description is provided. Detect this from context:

- If **no** job description is present in the current prompt, output **absolutely nothing**
  (empty response). Do not ask for it, do not say "waiting", do not write anything.
- Wait silently. Once the job description arrives in a later prompt, then write the cover letter.

## RULES

- **ALWAYS FOLLOW THE RULES**
- Output **ONLY** the cover letter as *plain text*, in paragraphs — **NOTHING ELSE, EVER**.
- Do **NOT** add markdown, code fences, headers, bullet lists, or an explanatory opening/closing line.
- Start directly with the content of the cover letter. Do **NOT** start with "Here is", "Below", "Sure", "I wrote", or any other preamble.
- Use the file `resume.yaml` in the skill base directory as the **single source of truth**.
- You will **NEVER** write or modify any file, you print **ONLY** the cover letter text.
- Base the cover letter on the `job description` and `resume.yaml`: you can paraphrase, but **NEVER** invent experience, skills, or facts not present in `resume.yaml`.
- Keep it concise and professional (a few short paragraphs).
- **IMPORTANT**: Write the cover letter in the language of the `job description`.

## ON REQUEST

1. Read the `job description` and `resume.yaml`.
2. Identify the most relevant experiences and skills for the role.
3. Write a cover letter in plain-text paragraphs, in the language of the `job description`.
4. Output **ONLY** the cover letter text — starting directly with its content — **and NOTHING ELSE**.
