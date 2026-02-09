extends Control

func _on_play_b_pressed() -> void:
	TransationFade.transition_to("res://Scene/gudang.tscn")
	await TransationFade.on_transition_finished

func _on_option_b_pressed() -> void:
	TransationFade.transition_to("res://Scene/control.tscn")
	await TransationFade.on_transition_finished

func _on_exit_b_pressed() -> void:
	get_tree().quit()
