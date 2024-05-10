extends CharacterBody2D
class_name Enemy

enum EnemyBehavior {BACK_FORTH, FOLLOW, NONE, CUSTOM}
@export var behavior : EnemyBehavior
var starting_position : Vector2
@export var max_distance : int = 2000

var max_distance_reached : bool = false



@onready var movement_component = $MovementComponent
@export var to_follow : Node2D
var target_position : Vector2

func _ready():
	starting_position = position
	print ("enemy ready - ", movement_component.speed)

func _physics_process(delta):
	movement_behavior(delta)

	move_and_slide()
	#print(velocity, "    ", position)

func movement_behavior(delta):
	match behavior:
		EnemyBehavior.BACK_FORTH:
			if max_distance_reached:
				max_distance_reached = false
				movement_component.direction *= -1
				starting_position = position
				
				var tween = get_tree().create_tween()
				tween.tween_property(self, "rotation", rotation + deg_to_rad(180), 0.25)
				
			velocity = movement_component.direction * movement_component.speed * delta
			max_distance_reached = position.distance_to(starting_position) >= max_distance
			
			
		EnemyBehavior.FOLLOW:
			look_at(to_follow.position)
			#rotation -= deg_to_rad(90)
			if position.distance_to(to_follow.position) > 250:
				await get_tree().create_timer(0.75).timeout
				target_position = (to_follow.position - position).normalized()
				velocity = target_position * movement_component.speed * delta
			else: velocity = Vector2.ZERO


func dagger_removed(dagger):
	print("DAGGER REMOVED")
	dagger.dagger_marker.queue_free()

