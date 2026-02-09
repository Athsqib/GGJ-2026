extends Control

func _on_com_pressed() -> void:
	TransationFade.transition_to("res://Scene/MainMenu.tscn")
	await TransationFade.on_transition_finished
