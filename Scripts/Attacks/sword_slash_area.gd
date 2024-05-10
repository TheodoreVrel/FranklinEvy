extends Area2D

@onready var collision_shape_left : CollisionShape2D = $CollisionShape2D
@onready var collision_shape_right : CollisionShape2D = $CollisionShape2D2

func _ready():
	select_swing_area(true)

func swing(swing_num : int):
	var tween = get_tree().create_tween()
	match swing_num:
		
		1:
			select_swing_area(true)
			tween.tween_property(self, "rotation", deg_to_rad(190), 0.13)
		2:
			select_swing_area(false)
			tween.tween_property(self, "rotation", deg_to_rad(-155), 0.13)
		3: 
			select_swing_area(true)
			tween.tween_property(self, "rotation", deg_to_rad(235), 0.13)
		
	rotation = 0
	#print (swing_num)

func select_swing_area(swing_side_right : bool, reset : bool = false):
	collision_shape_left.visible = !swing_side_right
	collision_shape_right.visible = swing_side_right
	if reset:
		collision_shape_left.visible = false
		collision_shape_right.visible = false
