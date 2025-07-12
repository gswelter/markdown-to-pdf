# md2pdf.sh - Markdown to PDF Converter

`md2pdf.sh` is a shell script that produces high-quality, professional PDFs from Markdown files.

It acts as a convenient wrapper for Pandoc and XeLaTeX, providing polished typography, proper hyphenation, and multiple font themes out of the box. The goal is to offer a simple, command-line method for creating print-ready documents that look significantly better than default Markdown-to-PDF conversions.

## Quick Start

To see what this script can do, convert the included sample file:
```bash
./md2pdf.sh sample_showcase.md
```

To convert the sample file with the classic `termes` font theme:
```bash
./md2pdf.sh sample_showcase.md -t termes
```

## Showcase

This repository includes `sample_showcase.md` to demonstrate many of the script's capabilities, including advanced features like citations, math, and cross-referencing.

To generate it with the elegant `pagella` theme, run:
```bash
./md2pdf.sh sample_showcase.md -t pagella
```

## Usage

The script is designed to be flexible. The input `.md` file can be placed anywhere in the command.

### General
`./md2pdf.sh [options] input_file.md`

### Options

| Flag | Description | Example |
| :--- | :--- | :--- |
| `-t THEME` | Set the font theme. | `./md2pdf.sh -t heros sample_showcase.md` |
| | **Themes:** `modern` (default), `heros`, `termes`, `pagella`. | |
| `-l LANG` | Set the document language for hyphenation and typography. | `./md2pdf.sh -l pt sample_showcase.md` |
| | **Languages:** `en` (default), `pt`, `es`, etc. | |
| `-o FILE` | Specify a custom name for the output PDF. | `./md2pdf.sh sample_showcase.md -o my_file.pdf` |
| `-f "FONT"` | Use a specific system font. (Cannot be used with `-t`). | `./md2pdf.sh -f "DejaVu Sans" sample_showcase.md` |
| `-y, --yes` | Bypass the confirmation prompt when overwriting an existing PDF. | `./md2pdf.sh -y sample_showcase.md` |
| `-h, --help` | Show the help message and exit. | `./md2pdf.sh --help` |
| `--diagnostics` | Check for all required programs and fonts and then exit. | `./md2pdf.sh --diagnostics` |
| `--list-fonts`| List all usable fonts available on your system and then exit. | `./md2pdf.sh --list-fonts` |


## Prerequisites

Before you begin, ensure you have the following software installed.

1.  **Pandoc**: The universal document converter.
2.  **A TeX/LaTeX Distribution**: A complete LaTeX environment is required. **TeX Live** is highly recommended.
3.  **Fontconfig**: Used for the `--list-fonts` and `--diagnostics` features.

On Debian-based systems (like Ubuntu, Mint), you can install everything you need with a single command:
```bash
sudo apt-get update && sudo apt-get install -y \
  pandoc \
  texlive-xetex \
  texlive-latex-extra \
  texlive-fonts-recommended \
  fontconfig
```
*Note: `texlive-fonts-recommended` provides the fonts for the built-in themes.*

## Installation

To make `md2pdf.sh` available as a command from anywhere in your terminal, follow these steps:

1.  **Move the Script:** Place `md2pdf.sh` in a local script directory.
    ```bash
    mkdir -p ~/.local/bin
    mv md2pdf.sh ~/.local/bin/
    ```
2.  **Make it Executable:**
    ```bash
    chmod +x ~/.local/bin/md2pdf.sh
    ```
3.  **Update your PATH:** Add the script's directory to your shell's configuration file (`~/.bashrc`, `~/.zshrc`, etc.) and create a simple alias.
    ```bash
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    echo "alias md2pdf='md2pdf.sh'" >> ~/.bashrc
    ```
4.  **Apply the Changes:**
    ```bash
    source ~/.bashrc
    ```
You can now use the `md2pdf` command from any directory.

## License

This project is licensed under the MIT License.
