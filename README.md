![Thumbnail](/ci/thumbnail.png)

# godot-super-mario-bros
A remake of Super Mario Bros. using the Godot Game Engine.

## Project Setup
This project serves as an example of how to join a few concepts I have been working on; Addons, Game Packs, and Compatability Builds.

### Addons
This project uses the [godot-2d-player-controller](https://github.com/kirbycope/godot-2d-player-controller). That addon requires an auto-load, [Globals.gd](https://github.com/kirbycope/godot-2d-player-controller/blob/main/scenes/globals.gd).

### Installing the Addon
1. Download [install-2d-player-controller.sh](ci/install-3d-player-controller.sh)
1. Move the file to a folder names `ci` in your project
1. Open your project in VS Code
1. Open the "Git Bash" terminal
1. Run `bash ci/install-2d-player-controller.sh`
    - This script will download the [2d_player_controller](/addons/3d_player_controller) folder from _this_ repo and then cleanup the `.git` files/folders.

## Game Pack
This game can be [exported](https://docs.godotengine.org/en/stable/tutorials/export/exporting_pcks.html#generating-pck-files) as a `.pck` and [imported](https://docs.godotengine.org/en/stable/tutorials/export/exporting_pcks.html#opening-pck-files-at-runtime) into another Godot game client. Download the [pack](ci\godot-super-mario-bros.pck).

### Export Game as Pack
1. Select "Project" > "Export.."
    1. Download the Presets, if prompted
1. Select "Add..."
1. Select "Web"
1. Select "Export PCK/ZIP..."
1. Change the type to "Godot Project Pack (*.pck)"
1. Select "Save"

### Export Game as Pack Using Bash
1. Open the root folder using [VS Code](https://code.visualstudio.com/)
    - If you use GitHub Desktop, select the "Open in Visual Studio" button
1. Open the [integrated terminal](https://code.visualstudio.com/docs/editor/integrated-terminal) using the "Git Bash" profile
1. Run the following command, `bash ci/export-pack.sh`

## Web Host
This game can be hosted on GitHub Pages. Play it at [timothycope.com/godot-super-mario-bros/](https://timothycope.com/godot-super-mario-bros/).

### Setting Up GitHub Pages
Note: This only needs to be done once.
1. Go to the "Settings" tab of the repo
1. Select "Pages" from left-nav
1. Select `main` branch and `/docs` directory, then select "Save"
    - A GitHub Action will deploy your website
1. On the main page of the GitHub repo, click the gear icon next to "About"
1. Select "Use your GitHub Pages website", then select "Save changes"

### Setting Up Godot
Note: This only needs to be done once.</br>
The following is needed to work with GitHub Pages.
1. Select "Project" > "Export..."
    - If you see errors, click the link for "Manage Export Templates" and then click "Download and Install"
1. Select the preset "Web (Runnable)"
1. For "Head Include", enter `<script src="coi-serviceworker.js"></script>`
1. Download [coi.js](https://github.com/gzuidhof/coi-serviceworker/raw/master/coi-serviceworker.js) and add it to the `/docs` directory

### Exporting to Web
1. Select "Project" > "Export..."
1. Select the preset "Web (Runnable)"
1. Select "Export Project..."
1. Select the "docs" folder
    - The GitHub Pages config points to the `main` branch and `/docs` directory
1. Enter `index.html`
1. Select "Save"
1. Commit the code to trigger a GitHub Pages deployment (above)

---

## Run Application on Remote Devices Using Wifi
Godot Remote Debug is great for testing on your `localhost`. This section will enable testing using devices on the same wifi network.

### Install and Enable Live Server
[Live Server](https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer) allows you to host web pages, locally, from VSCode.

### Generate HTTPS Certificate
"Secure Context - Check web server configuration (use HTTPS)" The following features required to run Godot projects on the Web. Do the following to setup
1. Download and install the [ssl binary](https://wiki.openssl.org/index.php/Binaries)
	- I use [OpenSSL for Windows](https://slproweb.com/products/Win32OpenSSL.html)
	- Confirm installation by running `openssl -v` in cmd/terminal
1. Open the root folder using [VS Code](https://code.visualstudio.com/)
    - If you use GitHub Desktop, select the "Open in Visual Studio" button
1. Open the [integrated terminal](https://code.visualstudio.com/docs/editor/integrated-terminal)
1. Run `openssl genrsa -aes256 -out localhost.key 2048`
	- You will be prompted for a "PEM pass phrase", remember this for the next step
	- `godot`
1. Run `openssl req -days 3650 -new -newkey rsa:2048 -key localhost.key -x509 -out localhost.pem`
	- You will be prompted for the "PEM pass phrase"
	- Fill out the rest of the information as the prompts request
		- "Country Name (2 letter code) [AU]:"`US`
		- "State or Province Name (full name) [Some-State]:"`WA`
		- "Locality Name (eg, city) []:"`Seattle`
		- "Organization Name (eg, company) [Internet Widgits Pty Ltd]:"`Timothy Cope`
		- "Organizational Unit Name (eg, section) []:"`Development`
		- "Common Name (e.g. server FQDN or YOUR name) []:"`localhost`
		- "Email Address []:"`kirbycope@gmail.com`
1. Open/Create `.vscode/settings.json` in the root of your project
1. Copy+paste the following:
	```
	{
		"liveServer.settings.root": "/",
		"liveServer.settings.https": {
			"enable": true,
			"cert": "localhost.pem",
			"key": "localhost.key",
			"passphrase": "{PEM pass phrase}"
		}
	}
	```
	- Replace `{PEM pass phrase}` with your "PEM pass phrase" from earlier
1. Restart VSCode (or the terminal, at least)

### Running/Hosting the App Locally
1. In VSCode's Explorer right-click on [docs/index.html](docs/index.html) and select "Open with Live Server"
1. When you visit [https://127.0.0.1:5500/docs/index.html](https://127.0.0.1:5500/docs/index.html)
1. To get your "Host Local IP Address", use terminal to run:
	- [Windows] `ipconfig`
	- [MacOS] `ipconfig getifaddr en0`
1. On a device connected to the same wifi as the host, navigate to `https://{host.local.ip.address}:5500/docs/index.html`
	- Replace `{host.local.ip.address}` with your "Host Local IP Address" from earlier
