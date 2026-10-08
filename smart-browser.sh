#!/usr/bin/env bash

URL="$1"
CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/smart-browser/config"

# Cargar configuración personalizada si existe
if [ -f "$CONFIG_FILE" ]; then
    # shellcheck source=/dev/null
    source "$CONFIG_FILE"
fi

# Matriz de soporte: "proceso:ejecutable"
BROWSERS=(
    "zen-browser:zen-browser"
    "floorp:floorp"
    "librewolf:librewolf"
    "firefox:firefox"
    "brave:brave"
    "helium:helium-browser"
    "min:min"
    "qutebrowser:qutebrowser"
    "google-chrome:google-chrome-stable"
    "chromium:chromium"
    "vivaldi:vivaldi"
    "thorium:thorium-browser"
    "epiphany:epiphany"
    "falkon:falkon"
    "midori:midori"
)

# 1. Detección en caliente: ¿Hay algún navegador activo en RAM?
for entry in "${BROWSERS[@]}"; do
    proc="${entry%%:*}"
    cmd="${entry##*:}"

    if pgrep -i "$proc" > /dev/null 2>&1; then
        if command -v "$cmd" > /dev/null 2>&1; then
            exec "$cmd" "$URL"
        fi
    fi
done

# 2. Arranque en frío preferido: usar la elección del instalador
if [ -n "$DEFAULT_BROWSER" ] && command -v "$DEFAULT_BROWSER" > /dev/null 2>&1; then
    exec "$DEFAULT_BROWSER" "$URL"
fi

# 3. Respetar variable de entorno del sistema si existe
if [ -n "$BROWSER" ] && command -v "$BROWSER" > /dev/null 2>&1; then
    exec "$BROWSER" "$URL"
fi

# 4. Fallback de emergencia: primer navegador instalado disponible
for entry in "${BROWSERS[@]}"; do
    cmd="${entry##*:}"
    if command -v "$cmd" > /dev/null 2>&1; then
        exec "$cmd" "$URL"
    fi
done

# 5. Notificación si no existe ningún navegador en el sistema
if command -v notify-send > /dev/null 2>&1; then
    notify-send "Smart Browser" "No se encontró ningún navegador web compatible instalado." --urgency=critical
fi

echo "Error: No se encontró ningún navegador web compatible instalado." >&2
exit 1
