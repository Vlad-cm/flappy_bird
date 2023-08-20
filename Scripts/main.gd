extends Node2D


var pipes = preload("res://Scenes/pipes.tscn")
var score = 0
var highest_score = 0
var is_started = false
var is_restarted = false
var is_music_playing = false


func _ready():
	$Menu/TextureRect.hide()
	$Player.start($StartPosition.position)
	$Player.z_index = 2
	$StartMusic.play()
	load_score()
	$CanvasLayer2/Score.text = str(highest_score)


func _unhandled_input(event):
	if ((event is InputEventScreenTouch) or (event is InputEventKey and event.keycode == KEY_SPACE)) and event.is_pressed():
		if not is_music_playing:
			$StartMusic.stop()
			$BackgroundMusic.play()
			is_music_playing = true
		$Player.jump()
		if is_started:
			return
		is_started = true
		get_tree().paused = false
		new_game(is_restarted)
		is_restarted = true
		
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			save_score()
			get_tree().quit()
		
			
func _process(delta):		
	if is_started:
		$Menu.hide()
		$CanvasLayer.show()
		
		if $Timer.is_stopped():
			$Timer.start()
		
		$CanvasLayer/RichTextLabel.text = str(score)
		$CanvasLayer2/Score.text = str(highest_score)
		if score > highest_score:
			highest_score = score
	

func _on_timer_timeout():
	pipes.instantiate().spawn(get_parent())


func new_game(change_color: bool):
	score = 0
	$CanvasLayer.hide()
	$Player.start($StartPosition.position, change_color)
	for N in get_parent().get_children():
		for child in N.get_children():
			if child.name == "UpperPipe":
				N.queue_free()


func game_over():
	$BackgroundMusic.stop()
	$Smash.play()
	$Menu.show()
	$Timer.stop()
	$Menu/TextureRect.show()
	
	save_score()
	
	is_music_playing = false
	is_started = false
	get_tree().paused = true


func _on_player_body_entered(body):
	if body.name == "UpperPipe" or body.name == "BottomPipe":
		game_over()
	
	
func _on_screen_area_entered(area):
	if area.name == "Player":
		game_over()


func _on_point_area_entered(area):
	if area.name == "PointZone":
		$Point.play()
		score += 1


func save_score():
	var save_score = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var json_string = JSON.stringify({"highscore": highest_score})
	save_score.store_line(json_string)
	
	
func load_score():
	if not FileAccess.file_exists("user://savegame.save"):
		return
	var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
	var json_string = save_game.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	var node_data = json.get_data()
	highest_score = node_data["highscore"]
