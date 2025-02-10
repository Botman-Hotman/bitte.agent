# Bitte AI Agent NextJS Template

This template provides a starting point for creating AI agents using the Bitte Protocol with Next.js. It includes pre-configured endpoints and tools that demonstrate common agent functionalities.

## Features

- 🤖 Pre-configured AI agent setup
- 🛠️ Built-in tools and endpoints:
  - Blockchain information retrieval
  - NEAR transaction generation
  - Reddit frontpage fetching
  - Twitter share intent generation
  - Coin flip functionality
- ⚡ Next.js 14 with App Router
- 🎨 Tailwind CSS for styling
- 📝 TypeScript support
- 🔄 Hot reload development environment

## Quick Start

1. Clone this repository
2. Configure environment variables (create a `.env` or `.env.local` file)

```bash
# Get your API key from https://key.bitte.ai
BITTE_API_KEY='your-api-key'

ACCOUNT_ID='your-account.near'
```

3. Install dependencies:


  ```bash
  pnpm install
  ```

  4. Start the development server:

  ```bash
  pnpm run dev
  ```

This will:

- Start your Next.js application
- Launch make-agent
- Prompt you to sign a message in Bitte wallet to create an API key
- Launch your agent in the Bitte playground
- Allow you to freely edit and develop your code in the playground environment

5. Build the project locally:

```bash
pnpm run build:dev
```

This will build the project and not trigger `make-agent deploy`

- using just `build` will trigger make-agent deploy and not work unless you provide your deployed plugin url using the `-u` flag.


## Quick Start Docker

**Prerequisites**

- **Docker & Docker Compose:**
Ensure you have Docker (and Docker Compose) installed on your machine. This setup uses a Linux/BusyBox-based Node.js image, so it is optimized for containerized environments.

**Environment Variables:**
- Make sure to create a local .env file (which is excluded from version control) that contains your environment-specific settings such as:

- ```BITTE_API_KEY```
- ```BITTE_AGENT_URL``` (if needed; by default, the agent will fetch its OpenAPI spec from port 3000)

**How the Docker Setup Works**

- **Image Build and Dependency Installation:**
The Dockerfile installs dependencies via pnpm install. If you bind mount your source code directory ```(using - .:/app)```, note that an empty host node_modules folder might override the container’s installed modules.

- **Tip**: Use a named volume for node_modules in your docker-compose file to preserve the installed dependencies:

```yaml
volumes:
  - .:/app
  - node_modules:/app/node_modules
```

**CLI install vs. Docker Mode:**
- Running docker-compose up --build is intended for testing the application in an environment that closely mimics production. While this mode does not offer the hot-reloading benefits provided by the CLI method (since code changes in the host may not trigger module reinstallation), it is ideal for testing the application without having to install additional libraries or binaries on your machine.

**Port Mapping**:
- By default, the Next.js server runs on port 3000. In our compose setup, we map port 3000 of the container to port 3000 on the host. (Note: The agent UI server may run on a different port, such as 3001, if configured so.)

**Troubleshooting Common Issues**
- **Port Detection Errors:**

You might see errors like:

```javascript
Error detecting port: Command failed: netstat -ano | findstr :LISTENING | findstr node.exe
```
This happens because the command being executed is Windows‑specific:

- **findstr Not Found:** The BusyBox environment does not have "findstr" (a Windows command).
- **Netstat Option Issues:** BusyBox’s ```netstat``` does not support the "-o" flag.

**Workaround:**
- Modify your Dockerfile to install ```net-tools``` (which provides a fuller version of netstat) and create a symbolic link so that calls to "findstr" are redirected to "grep":

```dockerfile
RUN apk add --no-cache net-tools && ln -s /bin/grep /usr/local/bin/findstr
```

**OpenAPI Spec Fetch Failures:**

If you see connection errors (e.g., ECONNREFUSED on port 3001), verify that:

- Your environment variable ```BITTE_AGENT_URL``` is correctly set to the URL where the Next.js server is running (typically ```http://localhost:3000``` if you’re not using a separate port).
- The service that serves the OpenAPI spec is actually running and listening on that port.
Running the Docker Setup

To build and run the containers, execute:

```bash
docker-compose up --build
```

This command will:

Build your Docker image based on the provided Dockerfile.
Spin up the container with the proper volume mappings and environment variables.
Start the Next.js server (and the make-agent process via concurrently) inside the container.



## Available Tools

The template includes several pre-built tools:

### 1. Blockchain Information

- Endpoint: `/api/tools/get-blockchains`
- Returns a randomized list of blockchain networks

### 2. NEAR Transaction Generator

- Endpoint: `/api/tools/create-near-transaction`
- Creates NEAR transaction payloads for token transfers

### 3. EVM Transaction Generator

- Endpoint: `/api/tools/create-evm-transaction`
- Creates EVM transaction payloads for native eth transfers

### 4. Twitter Share

- Endpoint: `/api/tools/twitter`
- Generates Twitter share intent URLs

### 5. Coin Flip

- Endpoint: `/api/tools/coinflip`
- Simple random coin flip generator

### 6. Get User

- Endpoint: `/api/tools/get-user`
- Returns the user's account ID

## AI Agent Configuration

The template includes a pre-configured AI agent manifest at `/.well-known/ai-plugin.json`. You can customize the agent's behavior by modifying the configuration in `/api/ai-plugins/route.ts`. This route generates and returns the manifest object.

## Deployment

1. Push your code to GitHub
2. Deploy to Vercel or your preferred hosting platform
3. Add your `BITTE_API_KEY` to the environment variables
4. The `make-agent deploy` command will automatically run during build

## Making your own agent

Whether you want to add a tool to this boilerplate or make your own standalone agent tool, here's you'll need:

1. Make sure [`make-agent`](https://github.com/BitteProtocol/make-agent) is installed in your project:

```bash
pnpm install --D make-agent
```

2. Set up a manifest following the OpenAPI specification that describes your agent and its paths.
3. Have an api endpoint with the path `GET /api/ai-plugin` that returns your manifest

## Setting up the manifest

Follow the [OpenAPI Specification](https://swagger.io/specification/#schema-1) to add the following fields in the manifest object:

- `openapi`: The OpenAPI specification version that your manifest is following. Usually this is the latest version.
- `info`: Object containing information about the agent, namely its 'title', 'description' and 'version'.
- `servers`: Array of objects containing the urls for the deployed instances of the agent.
- `paths`: Object containing all your agent's paths and their operations.
- `"x-mb"`: Our custom field, containing the account id of the owner and an 'assistant' object with the agent's metadata, namely the tools it uses, and additional instructions to guide it.

## Learn More

- [Bitte Protocol Documentation](https://docs.bitte.ai)
- [Next.js Documentation](https://nextjs.org/docs)
- [OpenAPI Specification](https://swagger.io/specification/)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License
