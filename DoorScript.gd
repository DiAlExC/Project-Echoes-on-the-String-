extends Spatial


var player_infront = false
	
var door_state= false 
onready var label = get_node("label") 


func _ready():
	 $label.hide()



func _input(_event):
	
	if Input.is_action_pressed("interact"):
		if player_infront == true and $AnimationPlayer.is_playing() == false:

			door_state = !door_state
			if door_state == true:
				$AnimationPlayer.play("Open")
			else:
				$AnimationPlayer.play("Close")
				

			
func _on_Area_body_entered(body):
	if body.is_in_group("Jogador"):
		player_infront = true
		label.visible = true


func _on_Area_body_exited(body):
	if body.is_in_group("Jogador"):
		player_infront = false
		label.visible = false
