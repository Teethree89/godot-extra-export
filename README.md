# godot-extra-export for godot 4.2
A simple metadata based plugin to export additional files to your final exe directory, outside of the PCK
Useful for things like not having to copy/paste external scripts or icon files that you want to export with your game.
Not limited by file type etc.

# Installation
1.Drag and drop the addons folder into your main res:// folder
2. Goto Project Settings>Plugins
3. Enable the "Export Dependencies" plugin
4. Restart your editor

# Useage
1. In your addons/export_extras folder double click on the res://addons/export_extras/export_plugin.gd
2. Expand the "Metadata" panel in the inspector.
3. Click on "Array Size" for either Directories To Add or Files to Add.
4. Either add to the array size or click "Add Element".
5. Change the item type (pencil icon on the right) to "PackedStringArray" for each element you add.
6. For Folders: Copy/Paste the folder path res://path/to/your/folder/ make sure to include the trailing / to get all contents of it.
7. For Files: Copy/Paste the direct path res://path/to/your/file.extension.
8. Export your game, you can choose to exclude these files in your resources if you don't want copies in the PCK.

I only tested and made this in Godot 4.2 but feel free to fork it to other versions.
