class_name ItemColor
extends Node3D

@export var color : Color = Color(0.3, 0.3, 0.3)

func _ready():
    
    var mat : StandardMaterial3D = $Mesh.get_surface_override_material(0)
    mat = mat.duplicate()
    mat.vertex_color_use_as_albedo = false
    mat.albedo_color = color
    $Mesh.set_surface_override_material(0, mat)
