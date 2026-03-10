---
user-invocable: false
name: mcp-builder
description: "Model Context Protocol server building, tool creation, resource management, prompt templates, and MCP SDK usage. Use when building MCP servers, defining tools, or integrating with MCP-compatible clients."
---

# MCP Builder

> "MCP turns AI capabilities into composable, discoverable services that any client can use."

## When to Use
- Building a new MCP (Model Context Protocol) server
- Defining tools, resources, or prompt templates for AI agents
- Integrating an existing service as an MCP server
- Debugging MCP transport or protocol issues
- Reviewing MCP server implementations for correctness

## What is MCP?
- Model Context Protocol is an open standard for connecting AI models to external tools and data
- MCP servers expose capabilities (tools, resources, prompts) over a standardized protocol
- MCP clients (like Claude Desktop, Claude Code, or custom agents) discover and invoke these capabilities
- Transport options: stdio (local), SSE (HTTP streaming), and streamable HTTP

## Server Setup (TypeScript SDK)

### Installation
```bash
npm install @modelcontextprotocol/sdk
```

### Basic Server Structure
```typescript
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";

const server = new McpServer({
  name: "my-mcp-server",
  version: "1.0.0",
  capabilities: {
    tools: {},
    resources: {},
    prompts: {},
  },
});

// Register tools, resources, prompts here...

// Connect via stdio transport
const transport = new StdioServerTransport();
await server.connect(transport);
```

### Python SDK Setup
```python
from mcp.server import Server
from mcp.server.stdio import stdio_server

server = Server("my-mcp-server")

# Register handlers with decorators...

async def main():
    async with stdio_server() as (read_stream, write_stream):
        await server.run(read_stream, write_stream)
```

## Tools

### What Are Tools?
- Tools are functions that the AI model can invoke to perform actions
- Each tool has a name, description, and input schema (JSON Schema)
- Tools can have side effects (write to DB, call APIs, modify files)

### Defining Tools (TypeScript)
```typescript
import { z } from "zod";

server.tool(
  "get-weather",
  "Get current weather for a city. Use this when the user asks about weather conditions.",
  {
    city: z.string().describe("City name, e.g., 'Istanbul' or 'New York'"),
    units: z.enum(["celsius", "fahrenheit"]).default("celsius")
      .describe("Temperature units"),
  },
  async ({ city, units }) => {
    const weather = await fetchWeather(city, units);
    return {
      content: [
        { type: "text", text: JSON.stringify(weather, null, 2) },
      ],
    };
  }
);
```

### Tool Design Best Practices
- Write clear, specific descriptions; the AI uses these to decide when to call the tool
- Include usage guidance in the description: "Use this when..." or "Call this to..."
- Define input schemas with descriptive field descriptions and sensible defaults
- Return structured data (JSON) for the AI to interpret; avoid returning raw HTML
- Handle errors gracefully; return error messages in content, do not throw unhandled exceptions
- Keep tool granularity balanced: one tool per logical action, not one tool per API endpoint

### Tool Error Handling
```typescript
server.tool("query-database", "...", { query: z.string() },
  async ({ query }) => {
    try {
      const result = await db.execute(query);
      return { content: [{ type: "text", text: JSON.stringify(result) }] };
    } catch (error) {
      return {
        content: [{ type: "text", text: `Error: ${error.message}` }],
        isError: true,
      };
    }
  }
);
```

## Resources

### What Are Resources?
- Resources expose data that the AI can read (like files, database records, API responses)
- Resources are identified by URIs (e.g., `file:///path/to/doc.md`, `db://users/123`)
- Resources should be read-only; use tools for write operations

### Defining Resources
```typescript
server.resource(
  "config",
  "config://app",
  "Application configuration settings",
  async () => ({
    contents: [{
      uri: "config://app",
      mimeType: "application/json",
      text: JSON.stringify(appConfig),
    }],
  })
);
```

### Dynamic Resource Templates
```typescript
server.resource(
  "user-profile",
  new ResourceTemplate("db://users/{userId}", { list: undefined }),
  "User profile data by user ID",
  async (uri, { userId }) => ({
    contents: [{
      uri: uri.href,
      mimeType: "application/json",
      text: JSON.stringify(await getUser(userId)),
    }],
  })
);
```

### Resource Best Practices
- Use meaningful URI schemes that reflect the data source (file://, db://, api://)
- Set correct mimeType for content (application/json, text/markdown, text/plain)
- Implement resource listing so clients can discover available resources
- Keep resource responses reasonably sized; paginate large datasets
- Cache resource data when appropriate to avoid redundant fetches

## Prompts

### What Are Prompts?
- Prompts are reusable prompt templates that the client can present to users
- They help standardize common interactions with the AI
- Prompts can accept arguments to customize the generated messages

### Defining Prompts
```typescript
server.prompt(
  "code-review",
  "Generate a code review for the given code snippet",
  { code: z.string(), language: z.string().optional() },
  ({ code, language }) => ({
    messages: [{
      role: "user",
      content: {
        type: "text",
        text: `Review the following ${language || ""} code for bugs, performance issues, and best practices:\n\n\`\`\`${language || ""}\n${code}\n\`\`\``,
      },
    }],
  })
);
```

## Transport Options

### stdio (Local)
- Best for local development and desktop integrations (Claude Desktop)
- Server runs as a child process; communication over stdin/stdout
- No network configuration needed; simplest to set up
- Log to stderr, not stdout (stdout is reserved for MCP protocol messages)

### SSE (Server-Sent Events)
- HTTP-based transport for remote servers
- Client connects via GET for the SSE stream, POST for sending messages
- Supports multiple concurrent clients
- Requires CORS configuration for browser-based clients

### Streamable HTTP
- Newer transport option using standard HTTP requests
- Supports both streaming and non-streaming responses
- Better suited for serverless environments

## Configuration for Claude Desktop
```json
{
  "mcpServers": {
    "my-server": {
      "command": "node",
      "args": ["path/to/server.js"],
      "env": {
        "API_KEY": "your-key-here"
      }
    }
  }
}
```

## Testing MCP Servers
- Use the MCP Inspector tool for interactive testing: `npx @modelcontextprotocol/inspector`
- Write unit tests for tool handler functions independently of the MCP framework
- Test schema validation with edge cases (missing fields, wrong types, boundary values)
- Verify error responses return isError: true with helpful messages
- Test resource URI parsing and template parameter extraction

## Common Mistakes to Avoid
- Logging to stdout instead of stderr (corrupts the stdio protocol stream)
- Not validating tool inputs (trust the schema but verify in the handler)
- Making tools too broad ("do-everything") or too narrow ("set-field-x")
- Forgetting to handle async errors (unhandled rejections crash the server)
- Not providing descriptions for tool parameters (the AI cannot guess what "x" means)
- Returning huge responses that exceed context window limits; summarize or paginate
