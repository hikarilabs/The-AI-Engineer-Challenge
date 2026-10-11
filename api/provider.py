# --- Provider configuration -------------------------------------------------
# Each provider is reachable through the OpenAI-compatible Chat Completions API.
# We only change base_url / api_key / default model per provider.

PROVIDERS = {
    "openai": {
        "base_url": None,  # SDK default (https://api.openai.com/v1)
        "api_key_env": "OPENAI_API_KEY",
        "default_model": os.getenv("OPENAI_MODEL", "gpt-4o-mini"),
    },
    "anthropic": {
        # Anthropic exposes an OpenAI-compatible endpoint.
        "base_url": os.getenv("ANTHROPIC_BASE_URL", "https://api.anthropic.com/v1/"),
        "api_key_env": "ANTHROPIC_API_KEY",
        "default_model": os.getenv("ANTHROPIC_MODEL", ""),
    },
    "local": {
        # Works with Ollama, LM Studio, llama.cpp, vLLM, etc.
        # e.g. Ollama default: http://localhost:11434/v1
        "base_url": os.getenv("LOCAL_BASE_URL", "http://localhost:11434/v1"),
        "api_key_env": "LOCAL_API_KEY",  # usually unused; any non-empty string works
        "default_model": os.getenv("LOCAL_MODEL", "llama3.1"),
    },
}

def get_client(provider: str) -> tuple[OpenAI, str]:
    """Return an OpenAI-compatible client and the default model for a provider."""

    config = PROVIDERS.get(provider)

    if config is None:
        raise HTTPException(
            status_code=400,
            detail=f"Unknown provider '{provider}'. Choose one of: {', '.join(PROVIDERS)}",
        )

    # Local servers usually don't need a real key, but the SDK requires a value.
    api_key = os.getenv(config["api_key_env"]) or ("not-needed" if provider == "local" else None)
    if not api_key:
        raise HTTPException(
            status_code=500,
            detail=f"{config['api_key_env']} not configured for provider '{provider}'",
        )

    client = OpenAI(api_key=api_key, base_url=config["base_url"])

    return client, config["default_model"]
