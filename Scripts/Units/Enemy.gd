extends CharacterBody2D
class_name Enemy

enum EnemyBehavior {BACK_FORTH, NONE}
@export var behavior : EnemyBehavior
var starting_position : Vector2
@export var max_distance : int = 2000

var max_distance_reached : bool = false

var direction = Vector2(0, 1)

@onready var movement_component = $MovementComponent

func _ready():
	starting_position = position
	print ("enemy ready - ", movement_component.speed)

func _physics_process(delta):
	movement_behavior(behavior, delta)

	move_and_slide()
	#print(velocity, "    ", position)

func movement_behavior(behavior, delta):
	match behavior:
		0:
			if max_distance_reached:
				max_distance_reached = false
				direction *= -1
				starting_position = position
			velocity = direction * movement_component.speed * delta
			max_distance_reached = position.distance_to(starting_position) >= max_distance


func dagger_removed(dagger):
	print("DAGGER REMOVED")
	dagger.dagger_marker.queue_free()
	
