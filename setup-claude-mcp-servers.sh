#!/usr/bin/env bash
# setup-claude-mcp-servers.sh
#
# Standalone MCP-server registration for Claude Code (user scope). Idempotent
# — already-registered servers are skipped. Companion to claude-code-starter.sh
# step 7; use this script when you want JUST the MCP servers and not the full
# CLAUDE.md / settings.json / plugin install.
#
# What gets registered (~20 servers, depending on creds):
#   stdio via bunx (Node):
#     filesystem, memory, sequential-thinking, repomix, context7,
#     chrome-devtools, playwright, exa (mcp-remote bridge)
#   stdio via uvx (Python):
#     git, time, fetch
#   http (OAuth on first use, no creds needed at install):
#     slack, linear-server, notion, github, sentry,
#     cloudflare-api, cloudflare-bindings, cloudflare-observability, cloudflare-radar
#   env-gated stdio (only registered when the relevant env var(s) are set):
#     postgres (DATABASE_URI), sqlite (SQLITE_DB_PATH),
#     grafana (GRAFANA_URL + GRAFANA_SERVICE_ACCOUNT_TOKEN),
#     runpod (RUNPOD_API_KEY),
#     vnc (VNC_HOST + VNC_PORT + VNC_PASSWORD),
#     redfish (REDFISH_HOSTS — JSON array, optional REDFISH_USERNAME / REDFISH_PASSWORD)
#
# Requirements: claude CLI, bunx (bun.sh), uvx (astral.sh/uv).
# If any of those is missing the script exits early with the install command.

set -euo pipefail

# ===== Helpers =====
log()  { printf '\033[1;34m[mcp]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$*" >&2; }
fail() { printf '\033[1;31m[error]\033[0m %s\n' "$*" >&2; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

have claude || fail "claude CLI missing — npm i -g @anthropic-ai/claude-code"
have bunx   || fail "bunx missing — curl -fsSL https://bun.sh/install | bash"
have uvx    || fail "uvx missing — curl -LsSf https://astral.sh/uv/install.sh | sh"

SCOPE="user"
FAILURES=()

# add_mcp NAME ARGS... — register NAME at user scope if not already present.
# ARGS are passed verbatim to `claude mcp add` (transport flag, optional env
# flags, then the `--` separator and the command). Records failures rather
# than aborting on first error so the rest of the install still proceeds.
add_mcp() {
  local name="$1"; shift
  if claude mcp get "$name" --scope "$SCOPE" >/dev/null 2>&1; then
    log "  ${name}: already registered"
    return 0
  fi
  log "  ${name}: adding"
  if ! claude mcp add --scope "$SCOPE" "$name" "$@"; then
    warn "  ${name}: add failed"
    FAILURES+=("$name")
  fi
}

log "Registering MCP servers at scope: $SCOPE"

# ===== Core stdio servers (Node, via bunx) =====
# bunx is the faster cold-start alternative to npx. The packages are pulled
# from npm on first use and cached locally; no global install required.
# filesystem is scoped to "." — the cwd at install time. Edit ~/.claude.json
# after install if you want to broaden the path.
add_mcp filesystem          --transport stdio -- bunx @modelcontextprotocol/server-filesystem .
add_mcp memory              --transport stdio -- bunx @modelcontextprotocol/server-memory
add_mcp sequential-thinking --transport stdio -- bunx @modelcontextprotocol/server-sequential-thinking
add_mcp repomix             --transport stdio -- bunx repomix --mcp
add_mcp context7            --transport stdio -- bunx @upstash/context7-mcp
add_mcp chrome-devtools     --transport stdio -- bunx chrome-devtools-mcp@latest
add_mcp playwright          --transport stdio -- bunx @playwright/mcp@latest

# ===== Core stdio servers (Python, via uvx) =====
# uvx pulls and caches PyPI packages on first use. Same lazy-load story.
add_mcp git   --transport stdio -- uvx mcp-server-git
add_mcp time  --transport stdio -- uvx mcp-server-time
add_mcp fetch --transport stdio -- uvx mcp-server-fetch

# ===== Web search (Exa, via mcp-remote stdio bridge) =====
# Exa serves over HTTP but is registered as stdio so the bunx mcp-remote
# bridge handles auth + reconnect. OAuth on first use.
add_mcp exa --transport stdio -- bunx mcp-remote https://mcp.exa.ai/mcp

# ===== HTTP MCPs (OAuth on first use) =====
# These are hosted MCP endpoints. No credentials needed at install — running
# `/mcp` inside a Claude Code session will prompt OAuth on first call.
add_mcp slack         --transport http -- https://mcp.slack.com/mcp
add_mcp linear-server --transport http -- https://mcp.linear.app/mcp
add_mcp notion        --transport http -- https://mcp.notion.com/mcp

# ===== First-party vendor HTTP MCPs =====
add_mcp github                   --transport http -- https://api.githubcopilot.com/mcp/
add_mcp sentry                   --transport http -- https://mcp.sentry.dev/mcp
add_mcp cloudflare-api           --transport http -- https://mcp.cloudflare.com/mcp
add_mcp cloudflare-bindings      --transport http -- https://bindings.mcp.cloudflare.com/mcp
add_mcp cloudflare-observability --transport http -- https://observability.mcp.cloudflare.com/mcp
add_mcp cloudflare-radar         --transport http -- https://radar.mcp.cloudflare.com/mcp

# ===== Env-gated databases =====
# Postgres MCP "Pro" by crystaldba (replaces the deprecated
# @modelcontextprotocol/server-postgres which npm marks as no longer
# supported). Reads DATABASE_URI; supports read-only or read/write mode.
if [ -n "${DATABASE_URI:-${POSTGRES_URL:-}}" ]; then
  DB_URI="${DATABASE_URI:-${POSTGRES_URL}}"
  add_mcp postgres --transport stdio --env "DATABASE_URI=${DB_URI}" -- uvx postgres-mcp
else
  warn "Skipping postgres MCP (set DATABASE_URI=postgresql://... to enable)"
fi

if [ -n "${SQLITE_DB_PATH:-}" ]; then
  add_mcp sqlite --transport stdio -- uvx mcp-server-sqlite --db-path "${SQLITE_DB_PATH}"
else
  warn "Skipping sqlite MCP (set SQLITE_DB_PATH=/path/to.db to enable)"
fi

# ===== Env-gated observability / cloud GPUs =====
if [ -n "${GRAFANA_URL:-}" ] && [ -n "${GRAFANA_SERVICE_ACCOUNT_TOKEN:-}" ]; then
  add_mcp grafana --transport stdio \
    --env "GRAFANA_URL=${GRAFANA_URL}" \
    --env "GRAFANA_SERVICE_ACCOUNT_TOKEN=${GRAFANA_SERVICE_ACCOUNT_TOKEN}" \
    -- uvx mcp-grafana
else
  warn "Skipping grafana MCP (set GRAFANA_URL and GRAFANA_SERVICE_ACCOUNT_TOKEN to enable)"
fi

if [ -n "${RUNPOD_API_KEY:-}" ]; then
  add_mcp runpod --transport stdio \
    --env "RUNPOD_API_KEY=${RUNPOD_API_KEY}" \
    -- bunx @runpod/mcp-server@latest
else
  warn "Skipping runpod MCP (set RUNPOD_API_KEY to enable)"
fi

# ===== Env-gated remote control =====
# VNC — drive a remote desktop (Windows/Linux/macOS/any VNC target) from the
# agent. Source: https://github.com/hrrrsn/mcp-vnc
# Requires VNC_HOST + VNC_PORT + VNC_PASSWORD. Skipped if any is unset (the
# server crash-loops on empty creds, which would clutter `claude mcp list`).
if [ -n "${VNC_HOST:-}" ] && [ -n "${VNC_PORT:-}" ] && [ -n "${VNC_PASSWORD:-}" ]; then
  add_mcp vnc --transport stdio \
    --env "VNC_HOST=${VNC_HOST}" \
    --env "VNC_PORT=${VNC_PORT}" \
    --env "VNC_PASSWORD=${VNC_PASSWORD}" \
    -- bunx @hrrrsn/mcp-vnc
else
  warn "Skipping vnc MCP (set VNC_HOST, VNC_PORT, VNC_PASSWORD to enable)"
fi

# ===== Env-gated BMC / out-of-band server management =====
# Redfish — talk to BMCs (Dell iDRAC, HPE iLO, Supermicro, Lenovo XClarity,
# anything implementing the DMTF Redfish API) for hardware inventory, power
# state, sensor readings, etc. Source: https://github.com/nokia/mcp-redfish
# Not on PyPI; pulled from git via uvx --from. Requires REDFISH_HOSTS as a
# JSON array string, e.g. REDFISH_HOSTS='[{"address":"192.168.1.100"}]'.
if [ -n "${REDFISH_HOSTS:-}" ]; then
  REDFISH_ENV_FLAGS=(--env "REDFISH_HOSTS=${REDFISH_HOSTS}")
  [ -n "${REDFISH_USERNAME:-}" ] && REDFISH_ENV_FLAGS+=(--env "REDFISH_USERNAME=${REDFISH_USERNAME}")
  [ -n "${REDFISH_PASSWORD:-}" ] && REDFISH_ENV_FLAGS+=(--env "REDFISH_PASSWORD=${REDFISH_PASSWORD}")
  [ -n "${REDFISH_AUTH_METHOD:-}" ] && REDFISH_ENV_FLAGS+=(--env "REDFISH_AUTH_METHOD=${REDFISH_AUTH_METHOD}")
  add_mcp redfish --transport stdio "${REDFISH_ENV_FLAGS[@]}" \
    -- uvx --from git+https://github.com/nokia/mcp-redfish mcp-redfish
else
  warn "Skipping redfish MCP (set REDFISH_HOSTS='[{\"address\":\"...\"}]' to enable)"
fi

# ===== Summary =====
log ""
if [ "${#FAILURES[@]}" -gt 0 ]; then
  warn "Finished with ${#FAILURES[@]} failure(s):"
  for f in "${FAILURES[@]}"; do
    warn "  - ${f}"
  done
  warn "Re-run after fixing the cause to retry. Already-registered servers will be skipped."
  exit 1
fi
log "Done. Verifying registration:"
claude mcp list 2>/dev/null || warn "claude mcp list failed — check 'claude mcp list' manually"
