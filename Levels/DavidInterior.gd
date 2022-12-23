extends KinematicBody

export var speed = 1.5

onready var navmesh = get_parent().get_node("Ground/Navigation")
onready var anim = $AnimationPlayer
var Cutscene_state = false


var moving = false
var target = Vector3.ZERO
var path = []


func get_ray_position(event):
	
	if Cutscene_state == false:
		
		var from =  get_viewport().get_camera().project_ray_origin(event.position)
		var to = from +  get_viewport().get_camera().project_ray_normal(event.position) * 1000

		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(from, to, [self], collision_mask)
		
		if not result.empty():
			
			return result.position

		return Vector3.ZERO
	if Cutscene_state == true:
		set_process(false)

func _input(event):
	if Cutscene_state == false:
		target = get_ray_position(event) 
	if Input.is_action_pressed("LMBClick"):
		if target:
			calculate_path()
			moving = true
	
	if Cutscene_state == true:
		set_process(false)
			


func _process(delta):
	
	if Cutscene_state == false:
		if (path.size() > 1):
			var to_walk = delta*speed
			var to_watch = Vector3(0, 1, 0)
			while(to_walk > 0 and path.size() >= 2):
				var pfrom = path[path.size() - 1]
				var pto = path[path.size() - 2]
				to_watch = (pto - pfrom).normalized()
				var d = pfrom.distance_to(pto)
				if (d <= to_walk):
					path.remove(path.size() - 1)
					to_walk -= d
				else:
					path[path.size() - 1] = pfrom.linear_interpolate(pto, to_walk/d)
					to_walk = 0


				var atpos = path[path.size() - 1]
				var atdir = to_watch
				atdir.y = 0

				var t = Transform()
				t.origin = atpos
				t=t.looking_at(atpos + atdir, Vector3(0, 1, 0))
				set_transform(t)
				if (path.size() < 2):
					path = []

				if moving == true:
					play_anim("walk")

		else:
			moving = false
			target = Vector3.ZERO
			set_process(false)
			play_anim("idle")
	if Cutscene_state == true:
		set_process(false)

func calculate_path():
	
	if Cutscene_state == false:
		var begin = navmesh.get_closest_point(global_transform.origin)
		var end = navmesh.get_closest_point(target)
		path = navmesh.get_simple_path(begin, end, true) 
		path.invert()
		set_process(true)
	if Cutscene_state == true:
		set_process(false)
		
			
func play_anim(name):
	anim.play(name)



func _on_InteractAB_body_entered(body):
		if body.name != "David":
			return
		Cutscene_state = true
		PortaB_Cutscene()
	
	
func PortaB_Cutscene():
	translation = Vector3(-1.186, -0.127, 3.8)
	rotation_degrees.y = -90
	play_anim("Open Door back")
	


func _on_AnimationPlayer_animation_finished(animation_name):
	
	if animation_name == "Open Door back":
		translation = Vector3(0.622, -0.127, 3.8)
		rotation_degrees.y = -90
		play_anim("idle")
		Cutscene_state = false
	
	if animation_name == "Open door Front":
		translation = Vector3(-1.186, -0.127, 3.8)
		rotation_degrees.y = 90
		play_anim("idle")
		Cutscene_state = false
		
	if animation_name == "SJ_Open Door back":
		translation = Vector3(0.622, -0.127, -0.38)
		rotation_degrees.y = -90
		play_anim("idle")
		Cutscene_state = false
	
	if animation_name == "SJ_Open door Front":
		translation = Vector3(-1.186, -0.127, -0.38)
		rotation_degrees.y = 90
		play_anim("idle")
		Cutscene_state = false



func _on_InteractAF_body_entered(body):
		if body.name != "David":
			return
		Cutscene_state = true
		PortaF_cutscene()
	
		
func PortaF_cutscene():
	translation = Vector3(0.622, -0.127, 3.8)
	rotation_degrees.y = 90
	play_anim("Open door Front")
	
	

func _on_SJ_InteractAF_body_entered(body):
		if body.name != "David":
			return
		Cutscene_state = true
		PortaF_SJ_cutscene()
		set_process(false)

func PortaF_SJ_cutscene():
	translation = Vector3(0.622, -0.127, -0.38)
	rotation_degrees.y = 90
	play_anim("SJ_Open door Front")


func _on_SJ_InteractAB_body_entered(body):
		if body.name != "David":
			return
		Cutscene_state = true
		PortaB_SJ_Cutscene()
	

func PortaB_SJ_Cutscene():
	translation = Vector3(-1.186, -0.127, -0.38)
	rotation_degrees.y = -90
	play_anim("SJ_Open Door back")
