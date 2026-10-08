# Smart Browser Wrapper 🚀

Un enrutador de enlaces (_link wrapper_) ultraligero y dinámico para Linux. Intercepta llamadas del sistema (`xdg-open`) y abre los enlaces directamente en el navegador web que **ya tienes en ejecución en tu memoria RAM**, evitando arranques en frío pesados e innecesarios.

Especialmente útil en gestores de ventanas en Wayland/X11 (como Hyprland, i3 o bspwm) y equipos con memoria ajustada (como 6 GB de RAM), donde abrir navegadores pesados desde cero satura los recursos del sistema.

---

## ⚡ ¿Cómo funciona?

1. **Detección en caliente:** Al abrir un enlace externo (verificaciones, logins, clics en la terminal), inspecciona mediante `pgrep` si alguno de los navegadores soportados ya tiene un proceso activo en memoria. Si lo encuentra, envía la URL instantáneamente a esa ventana activa.
2. **Arranque en frío personalizado:** Si no hay ningún navegador abierto en RAM, consulta la preferencia elegida durante la instalación (`~/.config/smart-browser/config`).
3. **Fallback dinámico:** Si no existe configuración previa, respeta la variable de entorno `$BROWSER` o ejecuta el primer navegador compatible instalado en tu `$PATH`.

---

## 🌐 Navegadores soportados

La matriz de compatibilidad detecta procesos activos y mapea automáticamente sus binarios correspondientes:

- Floorp
- LibreWolf
- Firefox
- Helium (`helium-browser`)
- Min
- Zen Browser
- Brave
- Google Chrome (`google-chrome-stable`)
- Chromium
- Vivaldi
- Thorium
- Qutebrowser
- Epiphany
- Falkon
- Midori

---

## 📦 Instalación

Clona el repositorio y ejecuta el instalador interactivo:

```bash
git clone [https://github.com/TU-USUARIO/smart-browser-wrapper.git](https://github.com/TU-USUARIO/smart-browser-wrapper.git)
cd smart-browser-wrapper
chmod +x install.sh
./install.sh

```

### ¿Qué hace el instalador?

- Escanea qué navegadores compatibles están instalados en tu sistema.
- Despliega un menú en terminal para que elijas tu navegador predeterminado para el arranque en frío.
- Almacena tu elección en `~/.config/smart-browser/config`.
- Copia el ejecutable a `~/.local/bin/smart-browser.sh`.
- Genera la entrada de escritorio en `~/.local/share/applications/smart-browser.desktop`.
- Asigna el manejador como predeterminado para esquemas HTTP y HTTPS con `xdg-mime`.

---

## 🛠️ Personalización

Puedes cambiar tu navegador predeterminado para arranque en frío en cualquier momento editando:

```bash
nano ~/.config/smart-browser/config

```

Por ejemplo:

```bash
DEFAULT_BROWSER="librewolf"

```

---

## 🗑️ Desinstalación

Para restaurar tu navegador habitual y eliminar el wrapper con un menú guiado:

```bash
./uninstall.sh

```

---

## 📄 Licencia

Distribuido bajo la Licencia MIT. Siéntete libre de modificarlo y adaptarlo a tus necesidades.
EOF
