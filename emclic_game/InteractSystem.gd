extends Control

onready var interact_label = $IntText

var interact_text = "" setget _set_text
var text_visible = false setget _set_visibility

func _set_text(new_value:String)->void:
	interact_text = new_value
	interact_label.text = new_value

func _set_visibility(new_value:bool)->void:
	text_visible = new_value
	interact_label.visible = new_value

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
