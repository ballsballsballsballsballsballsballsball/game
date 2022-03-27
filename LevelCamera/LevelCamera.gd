extends Camera2D



func _on_Button_pressed():
	get_tree().quit()


func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://MainMenu.tscn")


func _on_SaveButton_pressed():
	save_game()

func save():
	var save_dict = {
		"level": get_parent().get_parent().get_name()
	}
	return save_dict

func save_game():
	var save_game = File.new()
	save_game.open_encrypted_with_pass("user://game.save", File.WRITE, OS.get_unique_id())
	var data = save()
	save_game.store_line(to_json(data))
	save_game.close()
