extends Node3D

@onready var freeFlight: Camera3D = %FreeFlight

func _ready():
    
    freeFlight.current = true
    
func on_save(data:Dictionary):

    data.Camera = {}
    data.Camera.freeflight_transform = freeFlight.transform
    data.Camera.transform   = transform
    
func on_load(data:Dictionary):

    if data.has("Camera"):
        transform = data.Camera.transform
        freeFlight.transform = data.Camera.freeflight_transform

func get_pos():
    
    return freeFlight.global_transform.origin
    
    
