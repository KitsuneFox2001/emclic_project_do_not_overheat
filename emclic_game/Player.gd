extends KinematicBody

onready var camera_pivot = $CameraPivot
onready var raycast = $CameraPivot/RayCast
onready var UI = $HUD
onready var intSys = $HUD/InteractSystem

export var speed = 10.0
export var acceleration = 10.0
export var gravity = 50
export var jump = 15
export var sensitivity = 1.0
export var min_angle = -80
export var max_angle = 90

var process_game = true
var interacting = false
var interacting_timeout = 0

var look_rotation = Vector3.ZERO
var move_direction = Vector3.ZERO
var velocity = Vector3.ZERO

var fwd_bck
var lft_rht
var boost

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _physics_process(delta):
	handle_interaction(delta)
	camera_pivot.rotation_degrees.x = look_rotation.x
	rotation_degrees.y = look_rotation.y
	
	if not is_on_floor():
		velocity.y -= gravity*delta
	elif Input.is_action_pressed("jump"):
		velocity.y = jump
	
	#bieganie
	fwd_bck = Input.get_action_strength("backward") - Input.get_action_strength("forward")
	lft_rht = Input.get_action_strength("right") - Input.get_action_strength("left")
	if Input.is_action_pressed("run") && fwd_bck < 0:
		boost = 2
	else:
		boost = 1
	
	
	move_direction = Vector3(
		lft_rht,
		0,
		fwd_bck
	).normalized().rotated(Vector3.UP, rotation.y)*boost
	
	velocity.x = lerp(velocity.x, move_direction.x * speed, acceleration * delta)
	velocity.z = lerp(velocity.z, move_direction.z * speed, acceleration * delta)
	
	velocity = move_and_slide(velocity, Vector3.UP)


func _input(event):
	if event is InputEventMouseMotion:
		look_rotation.x -= (event.relative.y * sensitivity)
		look_rotation.y -= (event.relative.x * sensitivity)
		look_rotation.x = clamp(look_rotation.x, min_angle, max_angle)

func handle_interaction(delta):
	if interacting_timeout > 0:
		interacting_timeout -= delta
		if interacting_timeout <= 0:
			interacting_timeout = 0
			interacting = false #<- po co to, nie wiem
	
	raycast.force_raycast_update();
	if raycast.is_colliding():
		var object = raycast.get_collider()
		if object.is_in_group("Interactable"):
			if process_game: 
				intSys.text_visible = true
			intSys.interact_text = object.interact_text
			if Input.is_action_just_pressed("ui_interact") && !interacting:
				interacting = true
				interacting_timeout = object.timeout
				intSys.timeout = interacting_timeout
				object.do_something()
				intSys.text_visible = false
				#self.target_velocity = Vector3.ZERO
		else:
			intSys.text_visible = false
	else:
		intSys.text_visible = false
