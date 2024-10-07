extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# if space is  pressed
	if Input.is_action_just_pressed("ui_select"):
		print("space pressed, starting simulation")
		start_simulation()

func start_simulation():
	# copy all  nodes from $Construction to $Simulation
	for child in $Construction.get_children():
		var copy = child.duplicate()
		$Simulation.add_child(copy)
	pass

func stop_simulation():
	for child in $Simulation.get_children():
		child.queue_free()
