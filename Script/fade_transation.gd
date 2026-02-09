extends CanvasLayer

signal on_transition_finished

@onready var color_rect: ColorRect = $ColorRect
@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready():
	color_rect.visible = false
	animation.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name):
	if anim_name == "fadetoBlack":
		on_transition_finished.emit()
		animation.play("fadeToNormal")
	elif anim_name == "fadeToNormal":
		color_rect.visible = false
	
func transition_to(target_scene: String):
	# 1. Make the overlay visible and play fade out
	color_rect.visible = true
	animation.play("fadeToBlack")
	
	# 2. WAIT right here until the animation finishes
	await animation.animation_finished
	
	# 3. NOW change the scene
	get_tree().change_scene_to_file(target_scene)
	
	# 4. Fade back to normal
	animation.play("fadeToNormal")
	
	# 5. Wait for it to finish before hiding the rect
	await animation.animation_finished
	color_rect.visible = false
