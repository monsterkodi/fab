@tool
class_name RegalFrame
extends Node3D

@export_range(0.1, 10.0, 0.1) var height = 1.0:
    set(v): height = v; generate()
@export_range(0.1, 10.0, 0.1) var width = 1.0:
    set(v): width = v; generate()
@export_range(0.1, 10.0, 0.1) var depth = 1.0:
    set(v): depth = v; generate()
@export_range(0.0, 0.5, 0.01) var thickness = 0.2:
    set(v): thickness = v; generate()
@export_range(0.0, 1.0, 0.1) var chamfer = 0.4:
    set(v): chamfer = v; generate()
    
@export var material : Material:
    set(v): material = v; generate()

func _ready():

    generate()
    
func generate():

    var mi = MeshInstance3D.new()
    mi.mesh = MachMeshes.frame(width, height, depth, thickness, chamfer)
    mi.mesh.surface_set_material(0, material)
    mi.transform = Transform3D.IDENTITY
    
    if get_child_count():
        get_child(0).free()
    
    add_child(mi)
