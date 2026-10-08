#!/usr/bin/env bash

set -e

echo "=========================================="
echo " 🚀 Instalador de Smart Browser Wrapper   "
echo "=========================================="

# Obtener directorio del script para rutas relativas seguras
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/smart-browser"
CONFIG_FILE="$CONFIG_DIR/config"
BIN_DIR="$HOME/.local/bin"
APP_DIR="$HOME/.local/share/applications"

# 1. Crear directorios necesarios
mkdir -p "$CONFIG_DIR" "$BIN_DIR" "$APP_DIR"

# 2. Otorgar permisos automáticos a los scripts del repositorio
if [ -f "$SCRIPT_DIR/uninstall.sh" ]; then
    chmod +x "$SCRIPT_DIR/uninstall.sh"
    echo "✔ Permisos de ejecución otorgados a uninstall.sh"
fi

# 3. Copiar script principal y dar permisos
cp "$SCRIPT_DIR/smart-browser.sh" "$BIN_DIR/smart-browser.sh"
chmod +x "$BIN_DIR/smart-browser.sh"
echo "✔ Script copiado a $BIN_DIR/smart-browser.sh"

# 4. Matriz de navegadores para escanear
BROWSERS_MAP=(
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

INSTALLED_NAMES=()
INSTALLED_CMDS=()

echo ""
echo "🔍 Buscando navegadores compatibles instalados en tu sistema..."

for entry in "${BROWSERS_MAP[@]}"; do
    name="${entry%%:*}"
    cmd="${entry##*:}"
    if command -v "$cmd" > /dev/null 2>&1; then
        INSTALLED_NAMES+=("$name")
        INSTALLED_CMDS+=("$cmd")
    fi
done

# 5. Menú interactivo de selección
if [ ${#INSTALLED_CMDS[@]} -eq 0 ]; then
    echo "⚠️ No se detectó ningún navegador compatible instalado."
    echo 'DEFAULT_BROWSER=""' > "$CONFIG_FILE"
else
    echo ""
    echo "Navegadores encontrados en tu equipo:"
    for i in "${!INSTALLED_NAMES[@]}"; do
        echo "  $((i+1))) ${INSTALLED_NAMES[$i]} (${INSTALLED_CMDS[$i]})"
    done
    echo ""

    while true; do
        read -r -p "Selecciona cuál será tu navegador predeterminado en frío [1-${#INSTALLED_CMDS[@]}]: " choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#INSTALLED_CMDS[@]}" ]; then
            selected_cmd="${INSTALLED_CMDS[$((choice-1))]}"
            echo "DEFAULT_BROWSER=\"$selected_cmd\"" > "$CONFIG_FILE"
            echo "✔ Navegador en frío guardado en $CONFIG_FILE: $selected_cmd"
            break
        else
            echo "Opción no válida. Ingresa un número entre 1 y ${#INSTALLED_CMDS[@]}."
        fi
    done
fi

# 6. Crear el archivo .desktop
cat << 'DESKTOPEOF' > "$APP_DIR/smart-browser.desktop"
[Desktop Entry]
Version=1.0
Name=Smart Browser Wrapper
GenericName=Web Browser
Comment=Abre enlaces inteligentemente según el navegador en uso
Exec=sh -c '"$HOME/.local/bin/smart-browser.sh" "%U"'
Terminal=false
Type=Application
Icon=web-browser
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;
DESKTOPEOF
echo "✔ Acceso directo creado en $APP_DIR/smart-browser.desktop"

# 7. Actualizar base de datos y esquemas MIME
update-desktop-database "$APP_DIR"
xdg-mime default smart-browser.desktop x-scheme-handler/http
xdg-mime default smart-browser.desktop x-scheme-handler/https
echo "✔ Asignado como navegador predeterminado en xdg-mime"

echo ""
echo "🎉 ¡Instalación y configuración completadas con éxito!"
