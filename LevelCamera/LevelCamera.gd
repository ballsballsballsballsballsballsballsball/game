extends Camera2D



func _on_Button_pressed():
	$ConfirmationDialog.popup()


func _on_ConfirmationDialog_confirmed():
	get_tree().quit()
