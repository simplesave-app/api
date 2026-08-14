FROM ghcr.io/rails/devcontainer/images/ruby:3.4.8

RUN curl -fsSL https://chatgpt.com/codex/install.sh | \
    CODEX_NON_INTERACTIVE=1 sh \
    && "$HOME/.local/bin/codex" --version
