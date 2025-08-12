# Using the GitHub Coding Agent with Dev Factory

This documents how to use the GitHub Coding Agent to implement terraform modules.

## Configure MCP Servers

Before starting, go to your `https://github.com/org/repo/settings/copilot/coding_agent` and configure the MCP servers.

```json
{
    "mcpServers": {
        "Terraform-MCP-Server": {
            "type": "local",
            "command": "docker",
            "args": [
                "run",
                "-i",
                "--rm",
                "hashicorp/terraform-mcp-server"
            ],
            "tools": ["*"]
        },
        "Azure-MCP-Server": {
            "type": "local",
            "command": "npx",
            "args": [
                "-y",
                "@azure/mcp@0.0.21",
                "server",
                "start"
            ],
            "tools": ["*"]
        }
    }
}
```

## Assigning Issues to the GitHub Coding Agent

1. Create an issue with the following values:

    - **Title**: Implement <module_name>
    - **Description**: /plan-implement-apply <module_name>

    For example:
    - **Title**: Implement dev_center_project_environment_type
    - **Description**: /plan-implement-apply dev_center_project_environment_type

2. Assign the issue to @Copilot

3. Monitor or have a break, wait for GitHub Copilot to finish the implementation

4. Review the PR submitted by Copilot
   Recommendation: Open the branch in VSCode and run `/3-apply <module_name>` to do a test deployment.

5. If everything is in order, approve and merge the PR, close the issue.
