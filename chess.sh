# Made By M3TOZZ                       
# https://m3tozz.github.io        

export CWD="${PWD}"           # Current Working Directory
export BASENAME="${0##*/}"    # Script base name

check_npm() {
  if ! command -v npm &>/dev/null; then
    echo -e "\033[1;31mnpm is not installed! Please install Node.js and npm first.\033[0m\n"
    echo -e "\033[1;32mFor Ubuntu/Debian:\033[0m"
    echo -e "  sudo apt update && sudo apt install nodejs npm\n"
    echo -e "\033[1;35mFor Arch Linux:\033[0m"
    echo -e "  sudo pacman -S nodejs npm\n"
    echo -e "\033[1;34mFor Fedora:\033[0m"
    echo -e "  sudo dnf install nodejs npm\033[0m"
    exit 1
  fi
}

help() {
  echo -e "Usage:\n
  ${BASENAME} --install    : Install Chess application.
  ${BASENAME} --uninstall  : Uninstall Chess application.
  ${BASENAME} --launch     : Run without installation.
  ${BASENAME} --help       : Show this help page.
"
}

mtz:launch() {
  check_npm
  echo "[*] Checking dependencies..."
  if [ ! -d "node_modules" ]; then
    echo "[*] node_modules not found, installing..."
    npm install
  else
    echo "[✓] node_modules found, skipping installation."
  fi

  echo "[*] Launching the application..."
  npm start
}

mtz:install() {
  set -e
  check_npm
  echo "[*] Installing Chess application..."
  npm install

  sudo mkdir -p /opt/chess
  sudo cp -r ./* /opt/chess

  sudo ln -sf /opt/chess/node_modules/.bin/electron /usr/local/bin/chess

  sudo install -Dm644 icon/logo.png /usr/share/icons/hicolor/128x128/apps/chess-icon.png

  sudo tee /usr/share/applications/chess.desktop > /dev/null <<EOF
[Desktop Entry]
Name=Chess
Comment=Electron based Chess browser
Exec=/usr/local/bin/chess /opt/chess/main.js
Icon=chess-icon
Terminal=false
Type=Application
Categories=Network;WebBrowser;
EOF

  echo "[✓] Installation complete!"
}

mtz:uninstall() {
  set -e
  echo "[*] Uninstalling Chess application..."
  sudo rm -f /usr/share/applications/chess.desktop
  sudo rm -rf /opt/chess
  sudo rm -f /usr/local/bin/chess
  sudo rm -f /usr/share/icons/hicolor/128x128/apps/chess-icon.png
  echo "[✓] Chess application has been uninstalled."
}

case "${1,,}" in
  "--install"|"-i") mtz:install ;;
  "--uninstall"|"-u") mtz:uninstall ;;
  "--launch"|"-l") mtz:launch ;;
  "--help"|"-h"|*) help ;;
esac
