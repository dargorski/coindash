extends Area2D
signal pickup
signal hurt
@export var speed = 350
@export var animationNode: Node

var velocity = Vector2.ZERO
var screensize = Vector2(480,720)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y,0,screensize.y)
	
	velocity = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	#print(velocity)
	position += velocity * speed * delta
	
	if velocity.length() > 0:
		animationNode.animation = "run"
	else :
		animationNode.animation = "idle"
	if velocity.x != 0:
		animationNode.flip_h = velocity.x < 0
		
func start():
	set_process(true)
	animationNode.animation = "idle"
	position.x = screensize.x / 2
	position.y = screensize.y / 2
	
func die():
	animationNode.animation = "hurt"
	set_process(false)


func _on_area_entered(area):
	if area.is_in_group("coins"):
		area.pickup()
		pickup.emit("coin")
	if area.is_in_group("powerup"):
		area.pickup()
		pickup.emit("powerup")
	if area.is_in_group("obstacles"):
		hurt.emit()
		die()
