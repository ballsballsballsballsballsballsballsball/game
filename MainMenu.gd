extends Control

onready var popup = $PopupMenu

onready var version : String = '1.0.0-alpha.14'
onready var github : String = 'https://github.com/ballsballsballsballsballsballsballsball/game'

func _on_StartButton_pressed():
	get_tree().change_scene("res://levels/Level1.tscn")

func _ready():
	$VersionLabel.text = version
	if OS.is_debug_build():
		$VBoxContainer/DevButton.visible = true
		
	var lvls = dir_contents("res://levels")
	var save = File.new()
	var save_exists = save.file_exists("user://game.save")
	if save_exists:
		$VBoxContainer/LoadButton.disabled = false
	for lvl in lvls:
		var lvlName = lvl.split('.tscn')[0]
		var lvlId = lvlName[-1]
		popup.add_item(lvlName, int(lvlId))
	

func dir_contents(path):
	var dir = Directory.new()
	var files = []
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			else:
				if file_name.ends_with('tscn'):
					files.append(file_name)
			file_name = dir.get_next()
	return files

func _on_QuitButton_pressed():
	get_tree().quit()


func _on_DevButton_pressed():
	popup.popup_centered()


func _on_PopupMenu_id_pressed(id):
	get_tree().change_scene("res://levels/Level" + str(id) + ".tscn")


func _on_GHButton_pressed():
	OS.shell_open(github)


func _on_LoadButton_pressed():
	load_game()
	
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://game.save"):
		return
	save_game.open_encrypted_with_pass("user://game.save", File.READ, OS.get_unique_id())
	var level = parse_json(save_game.get_line())
	get_tree().change_scene("res://levels/" + level['level'] + ".tscn")
