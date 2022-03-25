extends Camera2D



func _on_Button_pressed():
	get_tree().quit()


func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
