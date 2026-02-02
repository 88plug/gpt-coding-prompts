  #!/usr/bin/env bash
  # setup-claude-mcp-servers.sh
  # Adds default MCP servers to Claude Code user config
  # Uses bunx 

  set -euo pipefail

  SCOPE="user"

  echo "Adding MCP servers to Claude Code (scope: $SCOPE)..."

  #claude mcp add --scope user --transport stdio runpod --env RUNPOD_API_KEY="" -- bunx @runpod/mcp-server@latest
  claude mcp add --scope $SCOPE --transport stdio filesystem          -- bunx @modelcontextprotocol/server-filesystem .
  claude mcp add --scope $SCOPE --transport stdio memory              -- bunx @modelcontextprotocol/server-memory
  claude mcp add --scope $SCOPE --transport stdio sequential-thinking -- bunx @modelcontextprotocol/server-sequential-thinking
  claude mcp add --scope $SCOPE --transport stdio fetch               -- bunx @modelcontextprotocol/server-fetch
  claude mcp add --scope $SCOPE --transport stdio repomix             -- bunx repomix --mcp
  claude mcp add --scope $SCOPE --transport stdio context7            -- bunx @upstash/context7-mcp
  claude mcp add --scope $SCOPE --transport stdio chrome-devtools     -- bunx chrome-devtools-mcp@latest
  claude mcp add --scope $SCOPE --transport stdio exa                 -- bunx mcp-remote https://mcp.exa.ai/mcp
  claude mcp add --scope $SCOPE --transport stdio time                -- uvx mcp-server-time
  claude mcp add --scope $SCOPE --transport stdio docker              -- uvx docker-mcp
  claude mcp add --scope $SCOPE --transport stdio git                 -- uvx mcp-server-git
  claude mcp add --scope $SCOPE --transport stdio playwright          -- bunx @playwright/mcp@latest  
  echo ""
  echo "Done. Verifying..."
  claude mcp list
