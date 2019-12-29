extends Node2D

class_name Whackstro

const rest_energy = 0.25 # the proportion of max energy that is regenerated when resting (by default)
const levelup_bonus = 1.05 # the amount stats get multiplied on each levelup

# What IS a Whackstro?
#
# First, what properties does a Whackstro have?
# * species, evolution level
# * list of abilities
# * xp level, current xp
# * max health, current health
# * max energy, current energy
# * current list of statuses and their durations
# * damage
# * speed
# * list of attacks (and their energy cost)
# ***** each attack has three things: a damage, a damage type list (melee/ranged, physical/magical, element), energy cost, health cost, list of possible status inflicted
# * xp given
#
# Second, what actions is a Whackstro able to take?
# * use an attack
# * run away
# * rest
# * be knocked out
# * change property (evolve, gain/lose abilities, gain xp, change max/current health, change damage, change defense, change speed, change list of attacks, xp given)


# whackstros, It's the game just for you. whackstros, Sing it cuz it's true!
# Whackstros, yup that is our name! whackstros, we aren't copying any other game.
# whackstros, This game is really fun. uh huh yup! Whackstros, I promise I won't shoot you with a gun!
# whackstros This game is really cool. Whackstros, If you don't play it go back to school.
# bye,


# these are constantly true for a given whackstro
var species = ""
var whackstro_name = ""
var evol_level = 1
var power = 0
var raw_stats = {"damage":0,"health":0,"energy":0,"speed":0}
var stats = {"damage":0,"health":0,"energy":0,"speed":0}
var possible_attacks = []
var abilities = []

# these are variables that describe the CURRENT state of a whackstro
var xp_level = 0
var xp_amount = 0
var current_attacks = []
var current_health = 0
var current_energy = 0
var current_statuses = []

# for the attacks.csv spreadsheet
var all_attacks = [] # double array, first is the attack index, second is the description
var ahti = {} # attack header to index dictionary


# Called when the node enters the scene tree for the first time.
func _ready():
	set_whackstro_species("Dientete")

func set_whackstro_species(whackstro_name):
	
	# the following lines import the whackstros file into a double list/array
	var file = File.new()
	file.open("res://whackstros.csv", 1)
	var rows = file.get_as_text().split("\n")
	file.close()
	var cells = []
	for peup in rows:
		cells.append(peup.split(","))
	
	# the following lines make the header_to_index dictionary
	var header_to_index = {}
	var i = 0
	for header in cells[0]:
		header_to_index[header] = i
		i = i + 1
		
	# the following lines pick out the proper row, and assign it to whackstrow
	var whackstrow
	for row in cells:
		if whackstro_name == row[header_to_index["Whackstro"]]:
			whackstrow = row
			
	# the following lines set the object's variables equal to those in the spreadsheet to create the specific whackstro
	species = whackstrow[header_to_index["Species"]]
	whackstro_name = whackstrow[header_to_index["Whackstro"]]
	evol_level = whackstrow[header_to_index["Evolution"]]
	power = whackstrow[header_to_index["Power"]]
	raw_stats["damage"] = whackstrow[header_to_index["Damage"]]
	raw_stats["health"] = whackstrow[header_to_index["Health"]]
	raw_stats["energy"] = whackstrow[header_to_index["Energy"]]
	raw_stats["speed"] = whackstrow[header_to_index["Speed"]]
	possible_attacks = whackstrow[header_to_index["Attacks"]] # this should later split the list
	abilities = whackstrow[header_to_index["Abilities"]] # this should later split the list

func load_attacks(): # loads attacks into all_attacks (double array, first is the attack index, second is the description), and sets ahti
	pass

func update_stats(): # calculates "processed" stats
	var new_stats = {}
	var i = 0
	for raw_stat in raw_stats.values():
		new_stats[raw_stats.keys()[i]] = int(float(raw_stat) * float(power) * pow(levelup_bonus, float(xp_level)))
		i = i + 1
	stats = new_stats

func refill_bars(): # refills health and energy
	current_health = stats["health"]
	current_energy = stats["energy"]

func rest(resting_percent = rest_energy): # rests some energy
	current_energy = current_energy + rest_energy * stats["energy"]
	if current_energy > stats["energy"]:
		current_energy = stats["energy"]

func attack(attack_num, opponent):
	pass