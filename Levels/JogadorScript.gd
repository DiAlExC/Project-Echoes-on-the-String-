extends KinematicBody

onready var agent : NavigationAgent = $David/Agent
var speed = 1

func _ready():
	agent.set_target_location(Vector3.ZERO)

func _physics_process(delta):
	var next = agent.get_next_location()
	var velocity = (next - transform.origin).normalized() * speed * delta
	
	move_and_collide(velocity)
