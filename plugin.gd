@tool
extends EditorPlugin

#Your file settings are located in the following script in the metadata
const GdeScriptPATH = "res://addons/export_extras/export_plugin.gd"
const ExportPlugin = preload(GdeScriptPATH)
var export_plugin_instance = null

const METADATA_FILE_PATH = "res://addons/export_extras/export_plugin_settings.json"

# Default values for metadata
const DEFAULT_DIRECTORIES_TO_ADD = ["res://path/to/dir"]
const DEFAULT_FILES_TO_ADD = ["res://path/to/file"]

# Descriptions for metadata
const DIRECTORIES_TO_ADD_DESCRIPTION = "List of directories to add."
const FILES_TO_ADD_DESCRIPTION = "List of files to add."

func _enter_tree():
	export_plugin_instance = ExportPlugin.new()
	add_export_plugin(export_plugin_instance)
	load_metadata()

func _exit_tree():
	if export_plugin_instance:
		save_metadata()
		remove_export_plugin(export_plugin_instance)

func load_metadata():
	var file = FileAccess.open(METADATA_FILE_PATH, FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		var json = JSON.new()
		var parse_result = json.parse(json_text)
		if parse_result == OK:
			var data = json.get_data()
			var script = export_plugin_instance.get_script()
			if data.has("directories_to_add"):
				script.set_meta("directories_to_add", data["directories_to_add"])
			if data.has("files_to_add"):
				script.set_meta("files_to_add", data["files_to_add"])
		else:
			print("Error parsing metadata JSON: ", parse_result.error_string)
		file.close()
	else:
		print("No metadata file found, using default values.")
		save_default_metadata()

func save_metadata():
	var metadata = {
		"directories_to_add": export_plugin_instance.get_script().get_meta("directories_to_add", DEFAULT_DIRECTORIES_TO_ADD),
		"files_to_add": export_plugin_instance.get_script().get_meta("files_to_add", DEFAULT_FILES_TO_ADD),
		"descriptions": {
			"directories_to_add": DIRECTORIES_TO_ADD_DESCRIPTION,
			"files_to_add": FILES_TO_ADD_DESCRIPTION
		}
	}
	var file = FileAccess.open(METADATA_FILE_PATH, FileAccess.WRITE)
	if file:
		var json = JSON.new()
		file.store_string(json.stringify(metadata))
		file.close()
	else:
		print("Failed to open metadata file for writing.")

func save_default_metadata():
	var metadata = {
		"directories_to_add": DEFAULT_DIRECTORIES_TO_ADD,
		"files_to_add": DEFAULT_FILES_TO_ADD,
		"descriptions": {
			"directories_to_add": DIRECTORIES_TO_ADD_DESCRIPTION,
			"files_to_add": FILES_TO_ADD_DESCRIPTION
		}
	}
	var file = FileAccess.open(METADATA_FILE_PATH, FileAccess.WRITE)
	if file:
		var json = JSON.new()
		file.store_string(json.stringify(metadata))
		file.close()
	else:
		print("Failed to open metadata file for writing.")


