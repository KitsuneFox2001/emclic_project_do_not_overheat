extends Spatial

#placehodler
onready var marker = $MeshInstance

export var interact_text = "press [E]"
export var timeout = 1.0

var material : SpatialMaterial = null
var default_color = null
var alt_color = Color.greenyellow
var is_activated = false

func _ready():
	_make_material_unique()

func _make_material_unique():
	material = marker.get("material/0").duplicate()
	default_color = material.albedo_color
	marker.set("material/0", material)

func do_something():
	is_activated = !is_activated
	if is_activated:
		material.albedo_color = alt_color
	else:
		material.albedo_color = default_color
