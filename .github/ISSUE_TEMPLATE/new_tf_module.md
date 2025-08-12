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
1. Run `/1-plan {module_name}`, this will output a new file: {module_name}.plan.md
2. Run `/2-implement #file:{module_name}.plan.md`
3. Run `/3-apply {module_name}`
