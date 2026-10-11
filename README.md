<p align = "center" draggable="false" ><img src="https://github.com/AI-Maker-Space/LLM-Dev-101/assets/37101144/d1343317-fa2f-41e1-8af1-1dbb18399719" 
     width="200px"
     height="auto" alt=""/>
</p>

## <h1 align="center" id="heading"> 👋 Welcome to the AI Engineer Challenge</h1>

## 🤖 Your First Vibe Coding LLM Application

> New to coding? Start with our [Interactive Dev Environment for LLM Development](https://github.com/AI-Maker-Space/Interactive-Dev-Environment-for-AI-Engineers) guide. It will walk you through setting up the tools and API keys you'll need for the course.

In this repository, we'll show you how to create a LLM (Large Language Model) powered application with a vibe-coded frontend!

Are you ready? Let's get started!


<details>
  <summary>🏗️ Forking & Cloning This Repository</summary>

Before you begin, make sure you have:

1. 👤 A GitHub account (you'll need to replace `YOUR_GITHUB_USERNAME` with your actual username)
2. 🔧 Git installed on your local machine
3. 💻 A code editor (like VS Code, Cursor, etc.)
4. ⌨️ Terminal access (Mac/Linux) or Command Prompt/PowerShell (Windows)
5. 🔑 A GitHub Personal Access Token (for authentication)

Got everything in place? Let's move on!

1. Fork [this](https://github.com/AI-Maker-Space/The-AI-Engineer-Challenge) repo!

     ![image](https://i.imgur.com/bhjySNh.png)

2. Clone your newly created repo.

     ``` bash
     # First, navigate to where you want the project folder to be created
     cd PATH_TO_DESIRED_PARENT_DIRECTORY

     # Then clone (this will create a new folder called The-AI-Engineer-Challenge)
     git clone git@github.com:<YOUR GITHUB USERNAME>/The-AI-Engineer-Challenge.git
     ```

     > Note: This command uses SSH. If you haven't set up SSH with GitHub, the command will fail. In that case, use HTTPS by replacing `git@github.com:` with `https://github.com/` - you'll then be prompted for your GitHub username and personal access token.

3. Verify your git setup:

     ```bash
      cd The-AI-Engineering-Challenge
      
      # Check that your remote is set up correctly
      git remote -v

      # Check the status of your repository
      git status

      # See which branch you're on
      git branch
     ```

     <!-- > Need more help with git? Check out our [Detailed Git Setup Guide](docs/GIT_SETUP.md) for a comprehensive walkthrough of git configuration and best practices. -->

4. Check out the existing backend code found in `/api/index.py`

</details>

<details>
  <summary>⚙️ Backend Setup with uv</summary>

### Prerequisites

This project needs a few developer tools: **git**, **uv** (which brings its own Python 3.12), and **Node.js / npm** (for the frontend).

Check what you already have at any time:

```bash
./scripts/check-deps.sh
```

If anything is missing, run the bootstrap script — it installs everything into a single, self-contained folder (`~/.ai-eng-challenge-deps`) so cleanup is just deleting that one directory:

```bash
./scripts/bootstrap.sh
```

Prefer to install `uv` by hand? Use the **standalone installer** (no existing Python/pip required):

# macOS / Linux
curl -LsSf https://astral.sh/uv/install.sh | sh

# Windows (PowerShell)
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"

Already have Python? pip install uv (or brew install uv / pipx install uv) works too. Either way, uv will download and manage Python 3.12 for you.

1. From the project root, install dependencies with uv sync. This creates .venv/ (and fetches Python 3.12 automatically if needed).
2. Set your OpenAI API key in the shell before running the server, for example export OPENAI_API_KEY=sk-....
3. Start the backend directly from the project root with uv run uvicorn api.index:app --reload. The server will run on http://localhost:8000 with auto-reload enabled for development.
4. Additional backend details live in api/README.md.

</details>

<details>
  <summary>🔥Setting Up for Vibe Coding Success </summary>

While it is a bit counter-intuitive to set things up before jumping into vibe-coding - it's important to remember that there exists a gradient between AI-Assisted Development and Vibe-Coding. We're only reaching *slightly* into AI-Assisted Development for this challenge, but it's worth it!

> 🤖 **Works with any agent** This repo keeps its agent rules in one portable `AGENTS.md` file at the project root. Bring whatever harness you vibe with: Cursor, Claude Code, OpenAI Codex, GitHub Copilot, and friends will all read the same rules:
> - **`AGENTS.md`** — the single source of truth. ✏️ **Edit this one file** and every agent instantly follows the new rules.
> - **`CLAUDE.md`** — a thin pointer so Claude Code inherits `AGENTS.md`.
> - **`.github/copilot-instructions.md`** — a thin pointer so GitHub Copilot inherits `AGENTS.md`.
> - **`.cursor/rules/`** — kept as-is so Cursor still gets its native, file-scoped targeting (e.g., the frontend rule only kicks in for frontend work).
>
> No matter which tool you pick, you only maintain your rules in **one place**. 🎯

1. Check out the portable `AGENTS.md` or the rules in `.cursor/rules/` and add theme-ing information like color schemes in `frontend-rule.mdc`! You can be as expressive as you'd like in these rules!
2. Next, let's pull the Next.js (and Vercel) docs into our agent's context, so it's far more likely to generate code that actually works. 📚 This isn't tied to any single IDE. Pick whichever path your editor and agent support (the examples below use **Visual Studio Code**, but the same ideas apply to any IDE):

   **🅰️ Your agent's built-in docs indexer**
     Most coding agents can index external docs for you:
     - **VS Code + GitHub Copilot:** open Copilot Chat and add the docs as context with `#fetch https://nextjs.org/docs` (and `#fetch https://vercel.com/docs`), or use the context (`+`) button to attach a URL.
     - **Cursor:** press `CTRL+SHIFT+P` / `CMD+SHIFT+P`, type "custom doc", paste `https://nextjs.org/docs`, accept the defaults, then repeat for `https://vercel.com/docs`. Reference them later with `@Docs`.
     - **Other IDEs/agents:** look for an "add docs", "index URL", or "@docs" style feature — the flow is the same: point it at the docs URL once, then reference it in chat.
   
   **🅱️ Any MCP-capable agent (recommended for cross-IDE setups)** — Model Context Protocol works in VS Code, Cursor, Claude Code, Codex, and more, so your docs setup will always be the same. Add a documentation MCP server such as [Context7](https://github.com/upstash/context7):
     ```bash
     # Example: register Context7 with Claude Code (other agents use their own MCP config/UI)
     claude mcp add context7 -- npx -y @upstash/context7-mcp
     ```
     In VS Code you can register the same server from the Command Palette via **"MCP: Add Server"**. Then ask your agent to "use the Next.js docs" and it will pull live, version-accurate pages into context.

3. The `llms.txt` convention (works in literally any IDE)** — Many frameworks publish an LLM-friendly docs index. Next.js exposes one at [`https://nextjs.org/docs/llms.txt`](https://nextjs.org/docs/llms.txt). Paste that URL (or its contents) into any agent's chat, or note it in `AGENTS.md` so every harness knows to consult it. No special indexer required! 🎉

4. Whichever path you chose, give it a quick smoke test: ask your agent something like *"Using the Next.js App Router docs, scaffold a page that calls our FastAPI backend."* If it references the docs accurately, you're indexed and ready to vibe. ✅


</details>

<details>
  <summary>😎 Vibe Coding a Front End for the FastAPI Backend</summary>

1. Use `Command-L` or `CTRL-L` to open the Cursor chat console. 

2. Set the chat settings to the following:

     ![image](https://i.imgur.com/LSgRSgF.png)

3. Ask Cursor to create a frontend for your application. Iterate as much as you like!

4. Run the frontend using the instructions Cursor provided. 

> NOTE: If you run into any errors, copy and paste them back into the Cursor chat window – and ask Cursor to fix them!

> NOTE: You have been provided with a backend in the `/api` folder - please ensure your Front End integrates with it!

</details>

<details>
  <summary>🚀 Deploying Your First LLM-powered Application with Vercel</summary>

1. Ensure you have signed in to [Vercel](https://vercel.com/) with your GitHub account.

2. Ensure you have `npm` (this may have been installed in the previous vibe-coding step!) - if you need help with that, ask Cursor!

3. Run the command:

     ```bash
     npm install -g vercel
     ```

4. Run the command:

     ```bash
     vercel
     ```

5. Follow the in-terminal instructions. (Below is an example of what you will see!)

     ![image](https://i.imgur.com/D1iKGCq.png)

6. Once the build is completed – head to the provided link and try out your app!

> NOTE: Remember, if you run into any errors, ask Cursor to help you fix them!

### Vercel Link to Share

You'll want to make sure you share your *domains* hyperlink to ensure people can access your app!

![image](https://i.imgur.com/mpXIgIz.png)

> NOTE: Test this is the public link by trying to open your newly deployed site in an Incognito browser tab!

</details>

---

## 📦 Submission Instructions

1. 🏗️ Build: Commit and push your changes to your remote on GitHub
2. 🚢 Ship: Deploy your app to Vercel
3. 🚀 Share: Submit your completed challenge through the [Typeform submission link](https://maven.com/aimakerspace/admin/courses/ai-eng-bootcamp/syllabus/modules/TYPEFORM_LINK).


### 🎉 Congratulations! 

You just 🏗️ built, 🚢 shipped, and 🚀 shared your first LLM-powered application! 🚀🚀🚀 

**But why stop there?**

Get on LinkedIn and post your results and experience! Make sure to tag us at @AIMakerspace!

Here's a template to get your post started!

```
🚀🎉 Exciting News! 🎉🚀

🏗️ Today, I'm thrilled to announce that I've successfully built and shipped my first-ever LLM using the powerful combination of , and the OpenAI API! 🖥️

Check it out 👇
[LINK TO APP]

A big shoutout to the @AI Makerspace for all making this possible. Couldn't have done it without the incredible community there. 🤗🙏

Looking forward to building with the community! 🙌✨ Here's to many more creations ahead! 🥂🎉

Who else is diving into the world of AI? Let's connect! 🌐💡

#FirstLLMApp 
```
