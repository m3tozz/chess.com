# Made By M3TOZZ                       
# https://m3tozz.github.io        

export CWD="${PWD}"			# Current Working Directory
export BASENAME="${0##*/}"	# Script base name

# Functions
help() {
	echo -e "Usage:\n
  ${BASENAME} --install    : Install Chess application.
  ${BASENAME} --uninstall  : Uninstall Chess application.
  ${BASENAME} --launch     : Run without installation.
  ${BASENAME} --help       : Show this help page.
"
}

mtz:launch() {
	npm start
}

mtz:install() {
	set -e
	echo "[*] Installing Chess application..."
	sudo mkdir -p /opt/chess
	sudo cp -r ./* /opt/chess

	sudo ln -sf /opt/chess/node_modules/.bin/electron /usr/local/bin/chess

	sudo install -Dm644 logo.png /usr/share/icons/hicolor/128x128/apps/chess-icon.png

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

# Argument parser
case "${1,,}" in
	"--install"|"-i")
		mtz:install
		;;
	"--uninstall"|"-u")
		mtz:uninstall
		;;
	"--launch"|"-l")
		mtz:launch
		;;
	"--help"|"-h"|*)
		help
		;;
esac
