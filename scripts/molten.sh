#!/usr/bin/env bash
#
# Script Name: molten.sh
# Description: Create .venv for molten tools

# Create venv
uv venv ~/.venvs/nvim-python

# Install recommended python tools
uv pip install --python ~/.venvs/nvim-python/bin/python \
    pynvim \
    jupyter_client \
    cairosvg \
    pnglatex \
    plotly \
    kaleido \
    pyperclip \
    nbformat \
    pillow \
    requests \
    websocket-client \
    --system-certs



