extends Node2D

signal game_over

#score signals
signal lose
signal win
var score := 0 #setget set_score
var remaining_time:=20 #setget set_time
var enemy_scene=load("res://wateringenemy.tscn")
var player_scene=load("res://wateringplayer.tscn")
var droplet_scene=load("res://watering_Droplet.tscn")
func start_game():
	$wateringScoreInterface.scale=Vector2(1,1)
	$wateringplayer.start($startposition.position)
	#var player=player_scene.instance()
	#player.position=$startposition.position
	#add_child(player)
	score = 0
	$wateringScoreInterface.update_score(score)
	remaining_time = 20
	$wateringScoreInterface.update_time(remaining_time)
	$Timer.start()
	$bgm.play()
func _on_Timer_timeout():
	remaining_time-=1
	$wateringScoreInterface.update_time(remaining_time)
	if remaining_time<=0:
		gameover()
	var temp=randi()%9+1
	var temp2=randi()%(temp)
	if remaining_time%temp==(temp2):
		var enemy=enemy_scene.instance()
		enemy.position.x=490
		enemy.position.y=672
		add_child(enemy)
	var drops=droplet_scene.instance()
	if remaining_time%1==0: #every second meron
		drops.position.x=rand_range(32,420)
		drops.position.y=0
		add_child(drops)
	if remaining_time%3==0: #xtra drop per 3 seconds
		drops.position.x=rand_range(32,420)
		drops.position.y=11
		add_child(drops)
func killed():
	#get_tree().paused=true
	#yield(get_tree().create_timer(0.5),"timeout")
	get_tree().paused=false
	$wateringplayer.hide()
	gameover()
func gameover():
	$bgm.stop()
	$Timer.stop()
	$wateringHUD.final_score(score)
	$wateringScoreInterface.scale=Vector2(0,0)
	emit_signal("game_over")
	get_tree().call_group("enemy","queue_free")
	get_tree().call_group("droplet","queue_free")
	if score <7:
		$lose_sound.play()
		emit_signal("lose")
	else:
		$win_sound.play()
		emit_signal("win")
		
func _on_wateringHUD_restart():
#	get_tree().reload_current_scene()
	#get_tree().change_scene("res://wateringmain.tscn")
	$lose_sound.stop()
	$win_sound.stop()
	$Timer.start()
	start_game()
	
func _on_MenuButton_go():
	$wateringHUD.start_screen_show()

func _on_wateringHUD_exit():
	$lose_sound.stop()
	$win_sound.stop()
	$wateringHUD.scale = Vector2(0,0)
	$wateringScoreInterface.scale=Vector2(0,0)
	self.visible = false
	
func _on_wateringplayer_update_score():
	score+=1
	$wateringScoreInterface.update_score(score)
