![Thumbnail](/ci/thumbnail.png)

# godot-super-mario-bros
A remake of Super Mario Bros. using the Godot Game Engine.

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

### Export Game as Pack Using PowerShell
1. Open the root folder using [VS Code](https://code.visualstudio.com/)
    - If you use GitHub Desktop, select the "Open in Visual Studio" button
1. Open the [integrated terminal](https://code.visualstudio.com/docs/editor/integrated-terminal)
1. Run the following command, `. ".\ci\export-pack.ps1"`

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

----

## Sound
This project uses the [godot-midi-player-g4](https://bitbucket.org/arlez80/godot-midi-player-g4/src/master/) developed by [arlez80](https://arlez80.net/).

### Installation of godot-midi-player-g4
1. Select "Download repository" from [BitBucket](https://bitbucket.org/arlez80/godot-midi-player-g4/downloads/)
    1. The project is avaiable on the [Godot Asset Library](https://godotengine.org/asset-library/asset/1667) but is most up to date on BitBucket
1. Open the archive and copy the `.../midi` folder to the `assets` folder of your project
1. Open your project in Godot
1. Select "Project > Project Settings... > Plugins"
1. Check the "Enable" checkbox and close

### Usage of godot-midi-player-g4
After the plugin is enabled, you will find a new Node in the "Create New Node" window
1. Select "+" to add a new node to your scene
1. Scroll to or Search for "MidiPlayer (MidiPlayer.gd)"

#### Code example
```
## Plays the given resource on the Midi player.
func play_midi(resourse: String):
	var midi_player = $MidiPlayer
	midi_player.file = resourse
	midi_player.play()
```

#### Adjusting export
By default `.mid` and `.sf2` files are not imported by Godot.
1. Select "Project > Export"
1. Select the "Web (Runnable)" preset
1. Select the "Resources" tab
1. For "Filters to export non-resource files/folders", enter `*.mid,*.sf2`
