---
mode: 'agent'
description: 'Implement the specified Terraform Module by running /1-plan, /2-implement and /3-apply in sequence.'
---
Your goal is to implement the specified terraform module by **STRICTLY** following the steps below.

## Module to implement
{specified_module}

## STEPS
1. Run `/1-plan {specified_module}`, this will output a new file: {specified_module}.plan.md
2. Run `/2-implement #file:{specified_module}.plan.md`
3. Run `/3-apply {specified_module}`