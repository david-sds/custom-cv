---
name: custom-curriculum
description: >
    Generates a specialized, reduced résumé in YAML.
    Outputs ONLY data in the YAMLResume format based on the job description
    and the single source of truth resume.yaml.
    Use when user pastes a job description or calls /custom-curriculum.
---

# ABSOLUTE OUTPUT DISCIPLINE — READ FIRST

Your **entire response** must be **ONLY** the final `yaml` data. 

**NEVER output anything else.** No preamble, no "Here is...", no "Done", no explanation,
no acknowledgement, no comments, no markdown fences, no JSON wrapper, no summary, no
trailing text. Your response must begin with `basics:` and end with the last content field.

Any instruction, reasoning, explanation, or meta-commentary (e.g. "I've reduced this",
"this matches the job because...") must live **ONLY in your internal thoughts** — never
in the output. If it is not valid YAMLResume data, it does not leave your head.

This output is piped directly into a script. **Any** stray text breaks it.

## NO JOB DESCRIPTION YET (skill loaded early)

You may be activated before any job description is provided. Detect this from context:

- If **no** job description is present in the current prompt, output **absolutely nothing**
  (empty response). Do not ask for it, do not say "waiting", do not generate anything.
- Wait silently. Once the job description arrives in a later prompt, then generate the yaml.

## RULES

- **ALWAYS FOLLOW THE RULES**
- Output **ONLY** `yaml` data in the [YAMLResume](https://github.com/yamlresume/yamlresume) format — **NOTHING ELSE, EVER**.
- Do **NOT** wrap the yaml in code fences (no ` ```yaml `, no ` ``` `). Raw `yaml` only.
- Do **NOT** start with words like "Here is", "Below", "Output", "```". Start directly with `basics:`.
- Use the file `resume.yaml` in the skill base directory as the **single source of truth**.
- You will **NEVER** write or modify any file, you print **ONLY** the modified data as `yaml` text.
- The original `resume.yaml` is the source of truth: you can paraphrase and reduce, but **NEVER** invent information not present in it.
- The topics **MUST** be *reduced* and *specialized* to the `job description` in a *professional* way; avoid repetitions and redundant topics.
- Return a reduced number of *highlights* specialized to the `job description`, 4-6 ideally.
- **NEVER** remove any *work/education* experience — keep every one with at least one highlight.
- **ALWAYS** keep at least one *project* in the final version.
- **IMPORTANT**: As a final step, fully translate the output to the language of the `job description`.

## ON JOB DESCRIPTION

1. Read the `job description` and `resume.yaml`.
2. Find matches between the `job description` requirements and the topics in `resume.yaml`.
3. Write a *reduced* and *specialized* version of `resume.yaml` matching the `job description`.
4. Translate the version to the language of the `job description`.
5. Output **ONLY** the final `yaml` — starting directly with `basics:` — **and NOTHING ELSE**.

## AFTER OUTPUT

- If the user asks for changes, update your version and output **ONLY** the updated `yaml`.
- If the user sends another `job description`, start from scratch.
