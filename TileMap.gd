extends TileMap

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func put_player_on_spawn():
	var spawn_tiles = get_used_cells_by_id(2)
	$Player.position = map_to_world(spawn_tiles[0]) + cell_size/2
	$Player.original_position = $Player.position # please remove this later
	for tile in spawn_tiles:
		set_cellv(tile,0) # make the spawn tiles grass again

# Called when the node enters the scene tree for the first time.
func _ready():
	put_player_on_spawn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
