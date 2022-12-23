extends RigidBody
class_name Door 

onready var interact_box = $InteractArea
onready var position = $out_position
var is_open : bool = false

func _ready():
	interact_box.connect("body_entered",self,"_on_InteractArea_body_entered")

#make player go near door
func _wait_interaction(from):
	print(from.name," wants to interact")
	from.navigation.set_target_location(self.global_transform.origin)
	#from.agent.set_target()

#open door
func _interact(body):
	is_open = not is_open
	get_tree().create_timer(0.1).connect("timeout",self,"animation_finish",[body])

func animation_finish(body):
	body.navigation.set_target_location(position.global_transform.origin)
	body.current_state = body.STATE.FOLLOW_AGENT

func _on_InteractArea_body_entered(body):
	if body is KinematicBody:
		body.current_state = body.STATE.ANIMATION
		_interact(body)
