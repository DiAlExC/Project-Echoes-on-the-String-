extends Area

onready var David = $"../../David"

var mouse_on_area = false

func _ready():
	connect("mouse_entered", self, "has_entered")
	connect("mouse_exited", self, "has_left")
	
func has_entered():
	mouse_on_area = true
	
func has_left():
	mouse_on_area = false
	David.Cutscene_state = false
	
func _on_ClickArea_input_event(camera, event, position, normal, shape_idx):
	if mouse_on_area == true and Input.is_action_pressed("LMBClick"):
		$"../InteractAB/InteractCB".disabled = false
		$"../InteractAF/InteractCF".disabled = false
		David.Cutscene_state = true


func _process(delta):
	if David.Cutscene_state == true:
		$"../InteractAB/InteractCB".disabled = true
		$"../InteractAF/InteractCF".disabled = true
	if mouse_on_area == false and Input.is_action_pressed("LMBClick"):
		
		$"../InteractAB/InteractCB".disabled = true
		$"../InteractAF/InteractCF".disabled = true
		print ("coll off")
