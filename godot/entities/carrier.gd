extends CharacterBody2D  # Use KinematicBody2D for Godot 3.x

var gravity = 980  # Adjust this value to change gravity strength
var speed = 400  # Horizontal movement speed
var direction = 1

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	move_horizontally(delta)
	move_and_slide()

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta


func move_horizontally(delta: float) -> void:
	velocity.x = speed * delta * direction
	# the ray casts forward and down, check if it hits anything, if it doesn't turn around
	$RayCast2D.force_raycast_update()
	if not $RayCast2D.is_colliding():
		self.scale.x = -self.scale.x
		direction *= -1
