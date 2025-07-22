# DevFactory Project - General Development Guidelines

## Project Overview

DevFactory is a **modular Infrastructure as Code (IaC) project** for streamlining Azure development environment setup with consistent patterns and best practices.

## **CORE RULES**

### **ALWAYS** Document Changes
**ALL CODE CHANGES** must be documented in [changelog.md](/docs/memory/changelog.md) including:
- Brief description of the change
- Classification: bug fix, feature, or improvement  
- **Breaking change assessment** (YES/NO with justification)

### **ALWAYS** Follow Modular Patterns
- Consistent file structure across all modules
- Working examples in `/examples/` directory for **EVERY** feature
- Clear documentation in module README.md files
- Proper input validation and testing

## Communication Standards

**BE DIRECT AND PRAGMATIC**:
- Provide factual, actionable guidance
- Avoid hyperbole and excitement - stick to technical facts
- Think step-by-step and revalidate before responding
- Ensure responses are relevant to the codebase context

**AVOID**:
- Unnecessary apologizing or conciliatory statements
- Agreeing with users without factual basis ("You're right", "Yes")
- Verbose explanations when concise answers suffice

## MCP Server Integration

**IF AVAILABLE**, use these Model Context Protocol servers:

- **Terraform MCP Server**: Seamless integration with Terraform Registry APIs for IaC automation
- **Azure MCP Server**: Connection to Azure services (Dev Center, Dev Box, Storage, Cosmos DB, etc.)

## Quality Standards

### **NEVER** Commit Without:
- Running validation tools (formatting, linting, testing)
- Testing examples to ensure they work  
- Updating relevant documentation
- Documenting changes in changelog

### **ALWAYS** Ensure:
- Changes follow established project patterns
- New features include complete working examples
- Security considerations (no hardcoded credentials)
- Backward compatibility or proper breaking change documentation

---

**Project Goal**: Build a foundation for modern Azure development environments with high standards of quality, security, and maintainability.
