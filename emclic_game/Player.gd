extends KinematicBody

onready var camera_pivot = $CameraPivot

export var speed = 10.0
export var acceleration = 10.0
export var sensitivity = 1.0
export var min_angle = -80
export var max_angle = 90

var look_rotation = Vector3.ZERO
var move_direction = Vector3.ZERO
var velocity = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _physics_process(delta):
	camera_pivot.rotation_degrees.x = look_rotation.x
	rotation_degrees.y = look_rotation.y
	
	#bieganie
	
	move_direction = Vector3(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		0,
		Input.get_action_strength("backward") - Input.get_action_strength("forward")
	).normalized().rotated(Vector3.UP, rotation.y)
	#lerp(velocity.x, move_direction.x * speed, acceleration * delta)
	velocity.x = lerp(velocity.x, move_direction.x * speed, acceleration * delta)
	velocity.z = lerp(velocity.z, move_direction.z * speed, acceleration * delta)
	
	velocity = move_and_slide(velocity)


func _input(event):
	if event is InputEventMouseMotion:
		look_rotation.x -= (event.relative.y * sensitivity)
		look_rotation.y -= (event.relative.x * sensitivity)
		look_rotation.x = clamp(look_rotation.x, min_angle, max_angle)
