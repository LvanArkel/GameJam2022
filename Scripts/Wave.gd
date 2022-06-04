extends Node

var ghosts
var trojans 
var worms

var max_alive
var time_between_spawns

func _init(ghosts, trojans, worms, max_alive = 5, time_between_spawns = 5):
	self.ghosts = ghosts
	self.trojans = trojans
	self.worms = worms
	self.max_alive = max_alive
	self.time_between_spawns = time_between_spawns
