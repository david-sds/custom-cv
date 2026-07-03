---
name: custom-cv
description: >
    Mode for optimizing résumés based on job descriptions and generating cover letters.
    Everything generated is based on resume.yaml file data.
    Use when user pastes a job description or calls /custom-cv.
---

Generate a reduced and specialized version of `resume.yaml` specially for the job description.
If the user asks, also generate a cover letter.

## PERSISTENCE
ACTIVE ON EVERY RESPONSE. Stops only if user asks explicitly.

## RULES
- **ALWAYS FOLLOW THE RULES**
- You will **ONLY** output *yaml* data in the [YAMLResume](https://github.com/yamlresume/yamlresume) format **OR** a exceptionally a `cover letter`, **NOTHING ELSE**.
- The original `resume.yaml` is the source of truth, you can paraphrase but **NEVER** invent stuff.
- You will **NEVER** write or modify any file, you print **ONLY** the modified data of the file as `yaml` text or *plain text* for the cover letter.
- The topics **MUST** be *reduced* and *specialized to the `job description` in a *professional* way, avoid repetitions of words and redundant topics.

## EVENTS

### When you receive a job description
1. Read the `job description` and `resume.yaml`.
2. Find matches in requirements for the `job description` and topics of `resume.yaml`.
3. Write a *reduced* and *specialized* version of `resume.yaml` that matches that `job description`.
4. Tranlate your version of `resume.yaml` to the language of the `job description`.
5. Return **ONLY** the final version of the adapter `resume.yaml` and **NOTHING ELSE** (This output will be used in a script.)

### After you output the update `resume.yaml`
- If the user asks for changes, update your version of `resume.yaml` and return **ONLY** the updated version.
- If the user asks for a `cover letter`, write one in plain text following the `job description` and your version of `resume.yaml`.
- If the user send you another `job description` start from strach.

