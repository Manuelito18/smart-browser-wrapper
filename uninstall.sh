#!/usr/bin/env bash

set -e

echo "============================================="
echo " 🗑️  Desinstalador de Smart Browser Wrapper   "
echo "============================================="

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/smart-browser"
BIN_FILE="$HOME/.local/bin/smart-browser.sh"
DESKTOP_FILE="$HOME/.local/share/applications/smart-browser.desktop"
APP_DIR="$HOME/.local/share/applications"

# 1. Limpieza de archivos del wrapper
echo "🧹 Eliminando archivos de la aplicación..."
rm -f "$BIN_FILE"
rm -f "$DESKTOP_FILE"
rm -rf "$CONFIG_DIR"
echo "✔ Binarios, accesos .desktop y configuraciones eliminados."

# 2. Actualizar base de datos de aplicaciones de escritorio
if command -v update-desktop-database > /dev/null 2>&1; then
    update-desktop-database "$APP_DIR"
fi

# 3. Menú interactivo para restaurar el navegador predeterminado del sistema
echo ""
echo "🔍 Buscando navegadores disponibles para restaurar..."

BROWSERS_MAP=(
    "google-chrome:google-chrome.desktop"
    "floorp:floorp.desktop"
    "librewolf:librewolf.desktop"
    "firefox:firefox.desktop"
    "brave:brave-browser.desktop"
    "helium:helium.desktop"
    "min:min.desktop"
    "chromium:chromium.desktop"
)

AVAILABLE_NAMES=()
AVAILABLE_DESKTOPS=()

for entry in "${BROWSERS_MAP[@]}"; do
    name="${entry%%:*}"
    desktop="${entry##*:}"
    if [ -f "/usr/share/applications/$desktop" ] || [ -f "$HOME/.local/share/applications/$desktop" ]; then
        AVAILABLE_NAMES+=("$name")
        AVAILABLE_DESKTOPS+=("$desktop")
    fi
done

if [ ${#AVAILABLE_DESKTOPS[@]} -gt 0 ]; then
    echo "Navegadores disponibles en tu equipo:"
    for i in "${!AVAILABLE_NAMES[@]}"; do
        echo "  $((i+1))) ${AVAILABLE_NAMES[$i]} (${AVAILABLE_DESKTOPS[$i]})"
    done
    echo ""

    while true; do
        read -r -p "Selecciona qué navegador restaurar como predeterminado [1-${#AVAILABLE_DESKTOPS[@]}]: " choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#AVAILABLE_DESKTOPS[@]}" ]; then
            chosen_desktop="${AVAILABLE_DESKTOPS[$((choice-1))]}"
            xdg-mime default "$chosen_desktop" x-scheme-handler/http
            xdg-mime default "$chosen_desktop" x-scheme-handler/https
            echo "✔ Navegador predeterminado restaurado a: $chosen_desktop"
            break
        else
            echo "Opción no válida. Ingresa un número entre 1 y ${#AVAILABLE_DESKTOPS[@]}."
        fi
    done
else
    echo "⚠️ No se detectaron archivos .desktop conocidos."
    echo "Puedes configurar tu navegador manualmente usando: xdg-mime default <archivo>.desktop x-scheme-handler/http"
fi

echo ""
echo "✨ ¡Smart Browser Wrapper ha sido desinstalado completamente!"
