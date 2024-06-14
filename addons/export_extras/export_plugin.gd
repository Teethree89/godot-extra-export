@tool
extends EditorExportPlugin

#1. Add new elements to the metadata as PackedStringArray items
#2. Paste in your direct paths
#Note: Folders/Directories should be res://path/to/your/folder/ to get all of its files inside.
#Note: Files should be the exact path res://path/to/your/file.extension

# Initialize variables
var directories_to_add = []
var files_to_add = []

func _export_begin(features, is_debug, path, flags):
	var script = self.get_script()
	directories_to_add = script.get_meta("directories_to_add", [])
	files_to_add = script.get_meta("files_to_add", [])
	print("Directories to add: ", directories_to_add)
	print("Files to add: ", files_to_add)
	
	var export_dir = path.get_base_dir()
	print("Export directory: ", export_dir)
	
	# Ensure the export directory exists
	var dir = DirAccess.open(export_dir)
	if dir:
		print("Opened export directory successfully!")
		
		# Process directories
		for source_dir_path in directories_to_add:
			var relative_path = source_dir_path.replace("res://", "")
			var target_path = export_dir + "/" + relative_path
			
			var target_dir = DirAccess.open(target_path)
			if target_dir == null:
				print("Directory path does not exist, creating: ", target_path)
				var make_dir = DirAccess.open(export_dir)
				if make_dir != null:
					make_dir.make_dir_recursive(relative_path)
			
			var source_dir = DirAccess.open(source_dir_path)
			if source_dir:
				print("Opened source directory successfully: ", source_dir_path)
				source_dir.list_dir_begin()
				var file_name = source_dir.get_next()
				while file_name != "":
					if file_name != "." and file_name != "..":
						var source_file_path = source_dir_path + file_name
						var dest_file_path = target_path + "/" + file_name
						print("Copying file from ", source_file_path, " to ", dest_file_path)
						_copy_file(source_file_path, dest_file_path)
					file_name = source_dir.get_next()
				source_dir.list_dir_end()
			else:
				print("Could not find the source directory: ", source_dir_path)
				
		# Process individual files
		for source_file_path in files_to_add:
			var relative_file_path = source_file_path.replace("res://", "")
			var dest_file_path = export_dir + "/" + relative_file_path
			if FileAccess.file_exists(source_file_path):
				print("Found the file: ", source_file_path)
				_copy_file(source_file_path, dest_file_path)
				print("Copied the file to ", dest_file_path)
			else:
				print("Could not find the file: ", source_file_path)
	else:
		print("Could not open the export directory :(")

func _copy_file(source_path, dest_path):
	print("Attempting to copy from ", source_path, " to ", dest_path)
	var src_file = FileAccess.open(source_path, FileAccess.READ)
	if src_file:
		var dst_file = FileAccess.open(dest_path, FileAccess.WRITE)
		if dst_file:
			var buffer = src_file.get_buffer(src_file.get_length())
			dst_file.store_buffer(buffer)
			dst_file.close()
			print("Successfully copied file to ", dest_path)
		else:
			print("Failed to open destination file: ", dest_path)
		src_file.close()
	else:
		print("Failed to open source file: ", source_path)
