@tool
class_name Arrow
extends Node3D

@export_range(0.0, 1.0, 0.01) var height = 0.1:
    set(v): height = v; generate()
@export_range(0.1, 10.0, 0.1) var width = 1.0:
    set(v): width = v; generate()
@export_range(0.0, 1.0, 0.001) var thickness = 0.5:
    set(v): thickness = v; generate()
    
@export var material : Material:
    set(v): material = v; generate()
    
func _ready():
    
    generate()
    
func generate():

    var mi = MeshInstance3D.new()

    mi.mesh = MachMeshes.arrow(width, height, thickness)
    mi.mesh.surface_set_material(0, material)
    mi.transform = Transform3D.IDENTITY
    
    if get_child_count():
        get_child(0).free()
    
    add_child(mi)
