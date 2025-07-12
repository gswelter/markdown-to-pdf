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

To use `md2pdf` like a regular command from anywhere in your terminal, follow these simple steps. These commands are safe and will only add a new shortcut to your system.

**1. Clone the Repository**

First, download the project into a dedicated directory in your home folder. A common and safe choice is `~/scripts`.

```bash
# Create the directory (if it doesn't already exist) and enter it.
mkdir -p ~/scripts
cd ~/scripts

# Download the project from GitHub into a new "markdown-to-pdf" folder.
git clone https://github.com/gswelter/markdown-to-pdf.git
```

**2. Create a Permanent Shortcut (Alias)**

Now, navigate into the project directory you just created.

```bash
cd markdown-to-pdf
```

Run the command below. It automatically finds the script's exact location and creates a permanent `md2pdf` shortcut for you.

```bash
# This command is safe: it simply adds one line of text to the end
# of your shell's configuration file.
echo "alias md2pdf='$(pwd)/md2pdf.sh'" >> ~/.bashrc
```

**3. Activate the New Command**

Finally, apply the changes to your current terminal session.

```bash
source ~/.bashrc
```

That's it! You can now run the `md2pdf` command from any directory.

## License

This project is licensed under the MIT License.
