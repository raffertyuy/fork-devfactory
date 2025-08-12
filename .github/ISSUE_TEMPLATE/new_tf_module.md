---
name: 'New Dev Factory Terraform Module'
about: 'Assign a new Dev Factory tf module implementation task to the GitHub Copilot Coding Agent'
title: 'Implement {module_name}'
labels: 'enhancement'
assignees: 'Copilot'
---

Your goal is to implement the specified terraform module by **STRICTLY** following the steps below.

## Module to implement
module_name=REPLACE_WITH_MODULE_NAME

## STEPS

### FIRST
Read and follow the instructions in `.github/copilot-instructions.md` and `.github/instructions/tf.instructions.md`

### SECOND: Follow these steps **STRICTLY**
1. Create an implementation plan by following `.github/prompts/1-plan.prompt.md`, this will follow output a new file: {module_name}.plan.md
2. Implement the requirement by following `.github/prompts/2-implement.prompt.md` for the plan created in step 1.

## FINALLY
After you're done, commit and push the changes and ask the user to review your PR by:
1. Opening your code in VSCode
2. Switching to the `aztf-agent`
3. and running `/3-apply {module_name}`.

AGAIN, DO NOT `/3-apply` yourself as this will require the user's credentials to test and run on his local machine.
ONLY ask the user to run it for the PR review.