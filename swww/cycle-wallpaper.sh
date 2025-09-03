#!/bin/bash

# Configuration
WALLPAPER_DIR="$HOME/Pictures/wallpapers" # Change this to your wallpaper directory
STATE_FILE="$HOME/.config/swww/current_wallpaper"
TRANSITION_TYPE="wipe" # Options: simple, fade, wipe, center, outer, random, any
TRANSITION_STEP="90"
TRANSITION_FPS="60"

# Create config directory if it doesn't exist
mkdir -p "$(dirname "$STATE_FILE")"

# Check if swww daemon is running
if ! pgrep -x "swww-daemon" >/dev/null; then
  echo "Starting swww daemon..."
  swww-daemon &
  sleep 1
fi

# Get list of supported image files
get_wallpapers() {
  find "$WALLPAPER_DIR" -type f \( \
    -iname "*.jpg" -o \
    -iname "*.jpeg" -o \
    -iname "*.png" -o \
    -iname "*.gif" -o \
    -iname "*.webp" -o \
    -iname "*.bmp" -o \
    -iname "*.tiff" -o \
    -iname "*.tga" -o \
    -iname "*.pnm" -o \
    -iname "*.farbfeld" \
    \) | sort
}

# Get current wallpaper index
get_current_index() {
  if [[ -f "$STATE_FILE" ]]; then
    cat "$STATE_FILE"
  else
    echo "0"
  fi
}

# Set wallpaper and update state
set_wallpaper() {
  local wallpaper="$1"
  local index="$2"

  echo "Setting wallpaper: $(basename "$wallpaper")"

  swww img "$wallpaper" \
    --transition-type "$TRANSITION_TYPE" \
    --transition-step "$TRANSITION_STEP" \
    --transition-fps "$TRANSITION_FPS"

  echo "$index" >"$STATE_FILE"
}

# Main cycling logic
cycle_wallpaper() {
  local wallpapers=()
  while IFS= read -r -d '' wallpaper; do
    wallpapers+=("$wallpaper")
  done < <(get_wallpapers | tr '\n' '\0')

  if [[ ${#wallpapers[@]} -eq 0 ]]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
  fi

  local current_index=$(get_current_index)
  local next_index=$(((current_index + 1) % ${#wallpapers[@]}))

  set_wallpaper "${wallpapers[$next_index]}" "$next_index"
}

# Handle command line arguments
case "${1:-cycle}" in
"cycle")
  cycle_wallpaper
  ;;
"prev")
  # Cycle backwards
  local wallpapers=()
  while IFS= read -r -d '' wallpaper; do
    wallpapers+=("$wallpaper")
  done < <(get_wallpapers | tr '\n' '\0')

  if [[ ${#wallpapers[@]} -eq 0 ]]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
  fi

  local current_index=$(get_current_index)
  local prev_index=$(((current_index - 1 + ${#wallpapers[@]}) % ${#wallpapers[@]}))

  set_wallpaper "${wallpapers[$prev_index]}" "$prev_index"
  ;;
"random")
  # Set random wallpaper
  local wallpapers=()
  while IFS= read -r -d '' wallpaper; do
    wallpapers+=("$wallpaper")
  done < <(get_wallpapers | tr '\n' '\0')

  if [[ ${#wallpapers[@]} -eq 0 ]]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
  fi

  local random_index=$((RANDOM % ${#wallpapers[@]}))
  set_wallpaper "${wallpapers[$random_index]}" "$random_index"
  ;;
"current")
  # Show current wallpaper info
  local wallpapers=()
  while IFS= read -r -d '' wallpaper; do
    wallpapers+=("$wallpaper")
  done < <(get_wallpapers | tr '\n' '\0')

  local current_index=$(get_current_index)
  if [[ $current_index -lt ${#wallpapers[@]} ]]; then
    echo "Current: $(basename "${wallpapers[$current_index]}")"
  else
    echo "No current wallpaper set"
  fi
  ;;
*)
  echo "Usage: $0 [cycle|prev|random|current]"
  echo "  cycle  - Next wallpaper (default)"
  echo "  prev   - Previous wallpaper"
  echo "  random - Random wallpaper"
  echo "  current- Show current wallpaper"
  exit 1
  ;;
esac
