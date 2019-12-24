extends Node2D

# PLEASE REMEMBER TO FIX OVERALL MOVEMENT

enum {NONE,UP,DOWN,LEFT,RIGHT}
var direction_to_vector = {NONE:Vector2(0,0), UP:Vector2(0,-1), DOWN:Vector2(0,1), LEFT:Vector2(-1,0), RIGHT:Vector2(1,0)}
var vector_to_direction = {Vector2(0,0):NONE, Vector2(0,-1):UP, Vector2(0,1):DOWN, Vector2(-1,0):LEFT, Vector2(1,0):RIGHT}
var direction_to_string = {NONE:"none", UP:"up", DOWN:"down", LEFT:"left", RIGHT:"right"}
var is_moving = false

var walkable_tiles = [0]
var velocity = Vector2(0,0) # used for sliding
export var speed = 320
var original_position = position

# Called when the node enters the scene tree for the first time.
func _ready():
	original_position = position
	$AnimatedSprite.set_animation("stand_down")
	
func check_keypress_direction():
	if Input.is_action_pressed("ui_up"):
		return UP
	elif Input.is_action_pressed("ui_down"):
		return DOWN
	elif Input.is_action_pressed("ui_left"):
		return LEFT
	elif Input.is_action_pressed("ui_right"):
		return RIGHT
	return NONE
	
func check_for_movement():
	var direction = NONE
	if velocity == direction_to_vector[NONE]:
		direction = check_keypress_direction()
		if not is_moving and direction != NONE:
			$AnimatedSprite.set_animation("stand_"+direction_to_string[direction])
	return direction

func new_tile_position(direction): # returns the place the player is trying to move to
	return get_parent().world_to_map(position + get_parent().map_to_world(direction_to_vector[direction]))

func attempt_movement():
	var direction = check_for_movement()
	if direction != NONE:
		var new_position = new_tile_position(direction)
		if get_parent().get_cellv(new_position) in walkable_tiles:
			enact_movement(direction)

func enact_movement(direction):
	velocity = direction_to_vector[direction]
	is_moving = true
	$AnimatedSprite.set_animation("run_"+direction_to_string[direction])

func complete_movement(delta):
	if velocity != direction_to_vector[NONE]:
		position = position + velocity * speed * delta
		if velocity == direction_to_vector[RIGHT] or velocity == direction_to_vector[DOWN]:
			if position >= original_position + get_parent().map_to_world(velocity):
				stop_movement()
		else:
			if position <= original_position + get_parent().map_to_world(velocity):
				stop_movement()
			
func stop_movement(): # at the end of movement, even if key is still held down
	position = get_parent().map_to_world(get_parent().world_to_map(position)) + get_parent().cell_size/2 # this will recenter the player after the movement
	original_position = position
	if check_keypress_direction() == NONE or not (get_parent().get_cellv(new_tile_position(vector_to_direction[velocity])) in walkable_tiles):
		end_movement()
	velocity = direction_to_vector[NONE] # stops velocity

func end_movement(): # if no keys held down
	$AnimatedSprite.set_animation("stand_"+direction_to_string[vector_to_direction[velocity]]) # sets to the standing animation at the end of movement
	is_moving = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	attempt_movement()
	complete_movement(delta)
		