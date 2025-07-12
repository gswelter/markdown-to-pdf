#!/bin/bash

# ==============================================================================
# md2pdf.sh
#
# A smart script to convert Markdown files to high-quality PDFs.
# It uses Pandoc with the XeLaTeX engine for professional typography.
#
# Author: Gemini
# Version: 15.0 (Definitive)
#
# Changelog:
# - Refactored font handling to use Pandoc variables (-V mainfont) instead
#   of temporary files. This is a cleaner and more reliable method.
# ==============================================================================

# --- Default Configuration ---
DEFAULT_LANG="en"
DEFAULT_THEME="modern"
FONT_SIZE="11pt"
GEOMETRY="a4paper,left=3cm,right=2cm,top=2.5cm,bottom=2.5cm"
HIGHLIGHT_STYLE="tango"


# --- Function to show usage ---
usage() {
  echo "Usage: $(basename "$0") [options] input_file.md"
  echo "Converts a Markdown file to a high-quality PDF using Pandoc and XeLaTeX."
  echo
  echo "Arguments:"
  echo "  input_file.md   The Markdown file to convert."
  echo
  echo "Options:"
  echo "  -t THEME        Set the font theme. Default is 'modern'."
  echo "                  Themes: modern, heros, termes, pagella."
  echo "  -l LANG         Set the document language (e.g., en, es, pt). Default is 'en'."
  echo "  -f FONT_NAME    Advanced: Use a custom system font. Cannot be used with -t."
  echo "  -o OUTPUT_FILE  Specify the name of the output PDF file."
  echo "  -y, --yes       Bypass the overwrite confirmation prompt."
  echo "  -h, --help      Show this help message."
  echo "  --diagnostics   Run a check for dependencies (like pandoc, xelatex, and fonts) and exit."
  echo "  --list-fonts    List recommended, usable fonts from your system and exit."
  exit 0
}

# --- Function to run diagnostics ---
run_diagnostics() {
  echo "--- Running System Diagnostics ---"
  echo "This tool will check for required programs and fonts."
  echo

  # 1. Check for essential programs
  echo "[1] Checking for required programs..."
  local all_programs_found=true
  for prog in pandoc xelatex fc-list; do
    if command -v "$prog" &> /dev/null; then
      echo "  ✅ Found: $prog"
    else
      echo "  ❌ Missing: $prog"
      all_programs_found=false
    fi
  done

  if [ "$all_programs_found" = false ]; then
    echo "  -> Suggestion: Install missing programs. On Debian/Ubuntu, try:"
    echo "     sudo apt-get install pandoc texlive-xetex fontconfig"
  fi
  echo

  # 2. Check for required fonts
  echo "[2] Checking for required font themes..."
  if ! command -v fc-list &> /dev/null; then
    echo "  ⚠️ Could not check for fonts because 'fc-list' is not installed."
    echo "  -> Suggestion: Install the 'fontconfig' package."
    return
  fi

  local all_fonts_found=true
  declare -A FONT_THEMES
  FONT_THEMES["modern"]="Latin Modern Roman"
  FONT_THEMES["heros"]="TeX Gyre Heros"
  FONT_THEMES["termes"]="TeX Gyre Termes"
  FONT_THEMES["pagella"]="TeX Gyre Pagella"

  for theme in "${!FONT_THEMES[@]}"; do
    local font_name="${FONT_THEMES[$theme]}"
    if fc-list | grep -q "$font_name"; then
      echo "  ✅ Found font for theme '$theme': $font_name"
    else
      echo "  ❌ Missing font for theme '$theme': $font_name"
      all_fonts_found=false
    fi
  done

  if [ "$all_fonts_found" = false ]; then
    echo "  -> Suggestion: Install the 'texlive-fonts-recommended' package."
    echo "     On Debian/Ubuntu, try: sudo apt-get install texlive-fonts-recommended"
  fi
  echo

  echo "--- Diagnostics Complete ---"
}

# --- Function to list system fonts ---
list_system_fonts() {
  echo "--- Searching for Recommended System Fonts ---"
  echo "The following fonts are likely suitable for use with the -f flag."
  echo

  if ! command -v fc-list &> /dev/null; then
    echo "  ❌ Error: 'fc-list' command not found."
    echo "  -> Suggestion: Install the 'fontconfig' package to use this feature."
    return
  fi

  # This command finds all fonts that have a "Regular" or "Book" style,
  # extracts their family name, filters out known non-text fonts,
  # and then sorts the list uniquely.
  fc-list -f "%{family[0]}
" | sort -u

  echo
  echo "Usage Tip: To use a font with spaces in its name, enclose it in quotes."
  echo "Example: ./md2pdf.sh -f \"DejaVu Sans\" my_document.md"
}

# --- Pre-emptive Flag Handling ---
# This logic ensures that --help has the highest priority, followed by --diagnostics.

# 1. Check for --help flag first.
for arg in "$@"; do
  if [ "$arg" == "--help" ] || [ "$arg" == "-h" ]; then
    usage # The usage function exits the script.
  fi
done

# 2. If no --help flag was found, check for --diagnostics.
for arg in "$@"; do
  if [ "$arg" == "--diagnostics" ]; then
    run_diagnostics
    exit 0
  fi
done

# 3. If no other high-priority flag was found, check for --list-fonts.
for arg in "$@"; do
  if [ "$arg" == "--list-fonts" ]; then
    list_system_fonts
    exit 0
  fi
done

# --- Argument Parsing ---
# This manual parser allows options and the input file to be in any order.

# 1. Initialize variables
INPUT_FILE=""
CUSTOM_FONT=""
CUSTOM_OUTPUT_FILE=""
LANG="$DEFAULT_LANG"
THEME="$DEFAULT_THEME"
ASSUME_YES=false

# 2. Pre-scan for high-priority, script-halting flags
for arg in "$@"; do
  if [ "$arg" == "--help" ] || [ "$arg" == "-h" ]; then usage; fi
done
for arg in "$@"; do
  if [ "$arg" == "--diagnostics" ]; then run_diagnostics; exit 0; fi
done
for arg in "$@"; do
  if [ "$arg" == "--list-fonts" ]; then list_system_fonts; exit 0; fi
done

# 3. Manually parse all other arguments
while [ "$#" -gt 0 ]; do
  case "$1" in
    -t|--theme) THEME="$2"; shift 2;;
    -l|--lang) LANG="$2"; shift 2;;
    -f|--font) CUSTOM_FONT="$2"; shift 2;;
    -o|--output) CUSTOM_OUTPUT_FILE="$2"; shift 2;;
    -y|--yes) ASSUME_YES=true; shift 1;;
    -h|--help) usage; shift;; # Should have been caught above, but for safety
    --diagnostics) run_diagnostics; exit 0;; # Should have been caught above
    --list-fonts) list_system_fonts; exit 0;; # Should have been caught above
    *.md)
      if [ -n "$INPUT_FILE" ]; then
        echo "Error: Multiple input files specified ('$INPUT_FILE' and '$1')." >&2
        exit 1
      fi
      INPUT_FILE="$1"
      shift 1
      ;;
    *)
      # Unknown argument
      echo "Warning: Ignoring unknown argument: $1" >&2
      shift 1
      ;;
  esac
done

# 4. Check for conflicting options
if [ "$THEME" != "$DEFAULT_THEME" ] && [ -n "$CUSTOM_FONT" ]; then
  echo "Error: The -t (theme) and -f (custom font) options are mutually exclusive." >&2
  echo "Please use one or the other, but not both." >&2
  exit 1
fi

# --- Determine Input File ---
# Final check to ensure an input file was provided and that it exists.
if [ -z "$INPUT_FILE" ]; then
  echo "Error: No input file specified." >&2
  usage
fi
if [ ! -f "$INPUT_FILE" ]; then
  echo "Error: Input file '$INPUT_FILE' not found." >&2
  exit 1
fi


# --- Determine Output File ---
if [ -n "$CUSTOM_OUTPUT_FILE" ]; then
  OUTPUT_FILE="$CUSTOM_OUTPUT_FILE"
else
  OUTPUT_FILE="${INPUT_FILE%.md}.pdf"
fi

# --- Check for Overwrite ---
if [ "$ASSUME_YES" = false ] && [ -f "$OUTPUT_FILE" ]; then
  read -p "File '$OUTPUT_FILE' already exists. Overwrite? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Operation cancelled."
    exit 1
  fi
fi

# --- Build Pandoc Command in an Array ---
PANDOC_ARGS=(
  "$INPUT_FILE"
  --standalone
  --pdf-engine=xelatex
  --highlight-style="$HIGHLIGHT_STYLE"
  -V "fontsize=$FONT_SIZE"
  -V "geometry:$GEOMETRY"
  -V "lang=$LANG"
  -V lmodern=false
  -V urlcolor=blue
  -o "$OUTPUT_FILE"
)

# --- Handle Language-Specific Typesetting and URL wrapping ---
HEADER_INCLUDES="\usepackage{xurl}"
if [ "$LANG" = "pt" ] || [ "$LANG" = "es" ]; then
  # For Portuguese and Spanish, use traditional paragraph indentation for ALL paragraphs.
  HEADER_INCLUDES="$HEADER_INCLUDES\n\usepackage{indentfirst}\n\setlength{\parindent}{1.5em}\n\setlength{\parskip}{0pt}"
fi
PANDOC_ARGS+=(-V "header-includes=$HEADER_INCLUDES")


# --- Handle Font Selection ---
FONT_INFO=""
if [ -n "$CUSTOM_FONT" ]; then
  PANDOC_ARGS+=(-V "mainfont=$CUSTOM_FONT")
  FONT_INFO="$CUSTOM_FONT (Custom)"
else
  case $THEME in
    heros)
      PANDOC_ARGS+=(-V "mainfont=TeX Gyre Heros")
      FONT_INFO="TeX Gyre Heros (Theme: heros)"
      ;;
    termes)
      PANDOC_ARGS+=(-V "mainfont=TeX Gyre Termes")
      FONT_INFO="TeX Gyre Termes (Theme: termes)"
      ;;
    pagella)
      PANDOC_ARGS+=(-V "mainfont=TeX Gyre Pagella")
      FONT_INFO="TeX Gyre Pagella (Theme: pagella)"
      ;;
    *)
      # For 'modern', we don't set any mainfont, letting Pandoc default to Latin Modern.
      FONT_INFO="Latin Modern (Theme: modern)"
      ;;
  esac
fi

# --- Add optional local files ---
if [ -f "style.tex" ]; then
  PANDOC_ARGS+=(-H "style.tex")
  echo "Found and using local 'style.tex'."
fi
if [ -f "filter.lua" ]; then
  PANDOC_ARGS+=(--lua-filter="filter.lua")
  echo "Found and using local 'filter.lua'."
fi

# --- Handle Language-Specific Typesetting ---
if [ "$LANG" = "pt" ] || [ "$LANG" = "es" ]; then
  # For Portuguese and Spanish, use traditional paragraph indentation for ALL paragraphs.
  PANDOC_ARGS+=(-V "header-includes=\usepackage{indentfirst}\setlength{\parindent}{1.5em}\setlength{\parskip}{0pt}")
fi

# --- Execute Conversion ---

echo "---"
echo "Input:    ${INPUT_FILE}"
echo "Output:   ${OUTPUT_FILE}"
echo "Font:     ${FONT_INFO}"
echo "Language: ${LANG}"
echo "---"

pandoc "${PANDOC_ARGS[@]}"
PANDOC_EXIT_CODE=$?



# --- Verification ---
if [ $PANDOC_EXIT_CODE -eq 0 ]; then
  echo "✅ Successfully created ${OUTPUT_FILE}"
  exit 0
else
  echo "❌ Error: PDF generation failed." >&2
  exit 1
fi