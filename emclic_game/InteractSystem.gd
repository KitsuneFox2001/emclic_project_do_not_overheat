extends Control

onready var interact_label = $IntText
onready var time_bar = $Timeout

var interact_text = "" setget _set_text
var text_visible = false setget _set_visibility
var timeout = 0 setget _set_timeout

func _set_text(new_value:String)->void:
	interact_text = new_value
	interact_label.text = new_value

func _set_visibility(new_value:bool)->void:
	text_visible = new_value
	interact_label.visible = new_value

func _set_timeout(new_value:float)->void:
	timeout = new_value
	time_bar.max_value = new_value * 1000
	time_bar.value = new_value * 1000
	self.set_process(true)
	time_bar.visible = true

func _ready():
	time_bar.visible = false

func _process(delta):
	if timeout <= 0:
		set_process(false)
		time_bar.visible = false
	else:
		timeout -= delta
		time_bar.value = timeout * 1000
	
