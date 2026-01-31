extends HBoxContainer

@onready var mask_inventory: HBoxContainer = $"."

var unlocked_slots : Array[bool] = [false, false, false]
var inventory_list : Array[TextureRect]
var slot = 3
var items_held = 0

func _ready() -> void:
	for child in get_children():
		if child is TextureRect:
			inventory_list.append(child)
			# Optional: Center the pivot now so scaling always looks good
			child.pivot_offset = child.size / 2
	
	for i in range(inventory_list.size()):
		var slot = inventory_list[i]
		if slot.get_child_count() > 0:
			var anim = slot.get_child(0) # Inventory_A
			if anim.get_child_count() > 0:
				var mask_sprite = anim.get_child(0) # Mask1
				mask_sprite.visible = false # Make it invisible!

func add_item(new_texture: Texture2D):
	if items_held < inventory_list.size():
		var current_slot = inventory_list[items_held]
		current_slot.texture = new_texture
		
		# Optional: Do you want it to flash when you pick it up?
		play_pick_effect(items_held)
		items_held += 1

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Inventory 1"):
		activate_slot(0)
	elif Input.is_action_just_pressed("Inventory 2"):
		activate_slot(1)
	elif Input.is_action_just_pressed("Inventory 3"):
		activate_slot(2)

func activate_slot(selected_index: int):
	var player = get_tree().get_first_node_in_group("Player")
	if unlocked_slots[selected_index] == false:
		print("This slot is locked! You haven't picked up this mask yet.")
		return
	# Loop through ALL slots to update them
	for i in range(inventory_list.size()):
		var slot = inventory_list[i]
		
		# Safety check for animation child
		if slot.get_child_count() > 0:
			var anim = slot.get_child(0)
			
			if i == selected_index:
				# --- THIS IS THE CHOSEN SLOT ---
				
				# 1. Force restart the animation
				anim.stop() 
				anim.frame = 0 
				anim.play("Select")
				
				# 2. Call the Tween function here!
				play_pick_effect(i)
				
				if anim.get_child_count() > 0:
					var mask_sprite = anim.get_child(0) # This gets 'Mask1'
					
					if mask_sprite is Sprite2D and player:
						print("Found mask texture on: ", mask_sprite.name)
						player.equip_mask(mask_sprite.texture)
				else:
					print("Error: No Sprite2D found inside the Animation node!")
				
			else:
				# --- THESE ARE THE OTHER SLOTS ---
				# Reset them to Idle
				anim.play("Idle")

func play_pick_effect(slot_index: int):
	var target_slot = inventory_list[slot_index]
	
	# Create a new tween
	var tween = create_tween()
	
	# Important: Ensure the pivot is in the center, or it scales from the corner
	target_slot.pivot_offset = target_slot.size / 2 
	
	# Scale Up -> Wait -> Scale Down
	tween.tween_property(target_slot, "scale", Vector2(1.2, 1.2), 0.1)
	tween.tween_property(target_slot, "scale", Vector2(1.0, 1.0), 0.1)
