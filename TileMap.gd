extends TileMap

var rng = RandomNumberGenerator.new()

export var walkable_tiles = [0,3]
export var tileid_to_encounterChance = {3:0.9} # chance of an encounter for each tile type
export var tileid_to_encounterSet = {3:[["common","uncommon","rare"],[0.5,0.85,1]]}

func put_player_on_spawn():
	var spawn_tiles = get_used_cells_by_id(2)
	$Player.position = map_to_world(spawn_tiles[0]) + cell_size/2
	$Player.original_position = $Player.position # please remove this later
	for tile in spawn_tiles:
		set_cellv(tile,0) # make the spawn tiles grass again
		
func roll_for_encounter(tileid): # rolls for an encounter
	if rng.randf() <= tileid_to_encounterChance[tileid]: # if the roll is 
		var index = 0
		var set_randomizer = rng.randf()
		for i in tileid_to_encounterSet[tileid][1]:
			if set_randomizer > i:
				index = index + 1
		initiate_encounter(tileid_to_encounterSet[tileid][0][index])
		
func initiate_encounter(whackstro): # initiates an encounter with the whackstro in question
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	put_player_on_spawn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
