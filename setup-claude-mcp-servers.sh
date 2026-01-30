  #!/usr/bin/env bash
  # setup-claude-mcp-servers.sh
  # Adds default MCP servers to Claude Code user config

  set -euo pipefail

  SCOPE="user"

  echo "Adding MCP servers to Claude Code (scope: $SCOPE)..."

  claude mcp add --scope $SCOPE --transport stdio filesystem       -- npx -y @modelcontextprotocol/server-filesystem .
  claude mcp add --scope $SCOPE --transport stdio memory           -- npx -y @modelcontextprotocol/server-memory
  claude mcp add --scope $SCOPE --transport stdio sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking
  claude mcp add --scope $SCOPE --transport stdio time             -- uvx mcp-server-time
  claude mcp add --scope $SCOPE --transport stdio repomix          -- npx -y repomix --mcp
  claude mcp add --scope $SCOPE --transport stdio context7         -- npx -y @upstash/context7-mcp
  claude mcp add --scope $SCOPE --transport stdio chrome-devtools  -- npx -y chrome-devtools-mcp@latest
  claude mcp add --scope $SCOPE --transport stdio exa              -- npx -y mcp-remote https://mcp.exa.ai/mcp

  echo ""
  echo "Done. Verifying..."
  claude mcp list
