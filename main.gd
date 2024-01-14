extends Node
@export var coin_scene: PackedScene
@export var powerup_scene: PackedScene
@export var cactus_scene: PackedScene
@export var playtime = 25
@export var additionalTimePerLevel = 5

var level: int
var score: int
var time_left: int
var screensize: Vector2
var playing: bool

func _process(delta):
	if playing and get_tree().get_nodes_in_group("coins").size() == 0:
		delete_old_obstacles()
		level+=1
		time_left += additionalTimePerLevel
		spawn_objects()	
		spawn_powerup(level)

func _ready():
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()
	
func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start()
	$Player.show()
	$GameTimer.start()
	spawn_objects()
	spawn_powerup(level)
	$HUD.update_score(score)
	$HUD.update_timer(time_left)
	
func spawn_objects():
	$LevelSound.play()
	for i in level + 4:
		var c = coin_scene.instantiate()
		add_child(c)
		c.screensize = screensize
		c.position = Vector2(randi_range(0, screensize.x), randi_range(0,screensize.y))
	for i in level:
		var o = cactus_scene.instantiate();
		add_child(o)
		o.position = Vector2(randi_range(0, screensize.x), randi_range(0,screensize.y))
		
func delete_old_obstacles():
	get_tree().call_group("obstacles","queue_free");
	
func game_over():
	$EndSound.play()
	playing = false;
	$GameTimer.stop()
	get_tree().call_group("coins","queue_free")
	$HUD.show_game_over()
	$Player.die()

func _on_game_timer_timeout():
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()
		
func spawn_powerup(level: int):
	$PowerupTimer.wait_time = randi_range(level+2, level+5)
	$PowerupTimer.start()


func _on_player_pickup(type: String):
	match type:
		"coin":
			$CoinSound.play()
			score += 1
			$HUD.update_score(score)
		"powerup":
			$PowerupSound.play()
			time_left += 5
			$HUD.update_timer(time_left)


func _on_player_hurt():
	game_over()

func _on_hud_start_game():
	new_game()

func _on_powerup_timer_timeout():
	var p = powerup_scene.instantiate()
	add_child(p)
	p.screensize = screensize;
	p.position = Vector2(randi_range(0,screensize.x), randi_range(0, screensize.y))
