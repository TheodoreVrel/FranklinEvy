extends Node

var missions_cleared : Array = [0, 1]

var speaking_to : String

var spoken_to : Array
func has_spoken_to(character_name):
	return character_name in spoken_to
func add_spoken_to(character_name):
	spoken_to.append(character_name)


var hydra_head_left : String

var found_Glory : bool = false

var Auron_escaped : bool
var let_Auron_go : bool


