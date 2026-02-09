extends Area2D

@onready var animation_player_2D: AnimationPlayer = $AnimationPlayer
@onready var face_mask: Sprite2D = $Animation/FaceMask

func _on_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("Player"):
		# 2. Find the Inventory node (adjust path if needed)
		# If your inventory is in a 'UI' canvas layer, you might need a different path
		var inventory = get_tree().get_first_node_in_group("Inventory")
		
		if inventory:
			# 3. Unlock the first mask (index 0)
			inventory.unlocked_slots[0] = true
			print("Mask 1 Unlocked!")
	animation_player_2D.play("pick")
