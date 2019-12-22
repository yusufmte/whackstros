extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func check_for_movement(): # returns the place the player is trying to move to
	if Input.is_action_just_pressed("ui_up"):
		return position + get_parent().map_to_world(Vector2(0,-1))
	if Input.is_action_just_pressed("ui_down"):
		return position + get_parent().map_to_world(Vector2(0,1))
	if Input.is_action_just_pressed("ui_left"):
		return position + get_parent().map_to_world(Vector2(-1,0))
	if Input.is_action_just_pressed("ui_right"):
		return position + get_parent().map_to_world(Vector2(1,0))
	return position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var new_position = check_for_movement()