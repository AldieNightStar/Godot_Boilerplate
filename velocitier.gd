extends Node

# var lib = load("res//this/script/file").new()

# var vel = lib.apply(kinematicBody2D, normalize, fallDown)

# vel.move(x, y=0)
# vel.limit(x,y)
# vel.fall = true / false
# vel.norm = true / false

# ### Signals ###
# 	obstacle_x(collider)
# 	obstacle_y(collider)









class Velocitier extends Node:
	var velocity : Vector2 = Vector2(0, 0)
	var norm : bool = false
	var fall : bool = false
	var body : KinematicBody2D
	var maxX : int = 50
	var maxY : int = 50
	
	signal obstacle_x(collider)
	signal obstacle_y(collider)
	
	func _init(normalize: bool, fallDown: bool):
		norm = normalize
		fall = fallDown
		name = "velocitier"
	
	func move(x: int, y: int = 0):
		# X manipulation
		if x > 0 and velocity.x < 0:
			velocity.x = 0
		elif x < 0 and velocity.x > 0:
			velocity.x = 0
		velocity.x += x
		# Y manipulation
		if y > 0 and velocity.y < 0:
			velocity.y = 0
		elif y < 0 and velocity.y > 0:
			velocity.y = 0
		velocity.y += y
	
	func limit(x: int, y: int):
		maxX = x
		maxY = y
			
	func _ready():
		body = get_parent()
		
	func _physics_process(delta):
		if fall: velocity.y += 1
		var obstacle_y = body.move_and_collide(Vector2(0, velocity.y))
		if obstacle_y:
			if velocity.y > 1 or velocity.y < -1:
				emit_signal("obstacle_y", obstacle_y)
			velocity.y = 0
		if velocity.x != 0: # If Horizontal Velocity is <> than 0
			var obstacle_x = body.move_and_collide(Vector2(velocity.x, 0))
			if obstacle_x:
				emit_signal("obstacle_x", obstacle_x)
				velocity.x = 0
		if norm: # If Normalisation is turned on
			if velocity.x < 0: velocity.x += 1
			if velocity.x > 0: velocity.x -= 1
			if velocity.x > maxX: velocity.x = maxX
			if velocity.x < -maxX: velocity.x = -maxX
			if !fall: # If Body isn't falling, then normalize also velocity's Y
				if velocity.y < 0: velocity.y += 1
				if velocity.y > 0: velocity.y -= 1
				if velocity.y > maxY: velocity.y = maxY
				if velocity.y < -maxY: velocity.y = -maxY

func apply(k : KinematicBody2D, normalize:bool, fallingDown:bool):
	if k.has_node("velocitier"):
		print("Velocitier: Already applied!")
		return
	var node = Velocitier.new(normalize, fallingDown)
	k.add_child(node)
	return node