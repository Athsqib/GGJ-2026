extends CharacterBody2D


const ACTUAL_SPEED = 180.0
var SPEED = ACTUAL_SPEED
const JUMP_VELOCITY = -350.0
var alive = true

@onready var animation: AnimatedSprite2D = $Animation
@onready var dash_timer: Timer = $DashTimer
@onready var health_bar: HBoxContainer = $Health_Bar/HealthBar
@onready var dash_cooldown: Timer = $DashCooldown
@onready var progress_bar: TextureProgressBar = $DashProgressBar
@onready var face_mask: Sprite2D = $FaceMask

var heart_list : Array[TextureRect]
var health = 5

func _ready() -> void:
	var hearts_parent = health_bar
	for child in hearts_parent.get_children():
		heart_list.append(child)

func take_damage():
	if health > 0:
		health -= 1
		update_heart_display()
		
func update_heart_display():
	for i in range(heart_list.size()):
		if heart_list[i].get_child_count() > 0:
			var heart_anim = heart_list[i].get_child(0) # Always get child 0
			if i >= health:
				heart_anim.play("Zero")
			else:
				heart_anim.play("Full")
	if health <= 0:
		alive = false
		#death()

func equip_mask(new_mask_texture: Texture2D):
	face_mask.texture = new_mask_texture

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# Get input direction: -1, 0, 1
	var direction := Input.get_axis("left", "right")
	
	# Handle Dash
	if Input.is_action_just_pressed("dash"):
		if dash_timer.is_stopped() and dash_cooldown.is_stopped():
			start_dash(direction)
	
	if dash_timer.is_stopped():
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	# Flip the player animation
	if direction > 0:
		animation.flip_h = false
		face_mask.flip_h = false
	elif direction < 0:
		animation.flip_h = true
		face_mask.flip_h = true
	
	# Play animation
	if is_on_floor():
		if direction == 0:
			animation.play("idle")
		else:
			animation.play("move")
	else:
		animation.play("jump")
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func start_dash(direction):
	dash_timer.start()
	dash_cooldown.start() # Start the cooldown timer immediately
	SPEED = ACTUAL_SPEED * 5
	var dash_dir = direction if direction != 0 else (1 if !animation.flip_h else -1)
	velocity.x = dash_dir * SPEED

func _on_dash_timer_timeout() -> void:
	# Reset speed
	SPEED = ACTUAL_SPEED
	velocity.x = 0

func _on_dash_cooldown_timeout() -> void:
	# Create a quick white flash effect
	var tween = create_tween()
	# Set the character to white (modulate) then back to normal (1,1,1,1)
	tween.tween_property(animation, "modulate", Color(5, 5, 5, 1), 0.1)
	tween.tween_property(animation, "modulate", Color(1, 1, 1, 1), 0.1)
