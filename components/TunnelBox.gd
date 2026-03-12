@tool
class_name TunnelBox
extends Node3D

@export_range(0.0, 1.0, 0.001) var thickness = 0.2:
    set(v): thickness = v; generate()
@export_range(0.0, 1.0, 0.001) var chamfer = 0.05:
    set(v): chamfer = v; generate()
    
@export var material : Material:
    set(v): material = v; generate()
    
func _ready():
    
    generate()
    
func generate():

    var mi = MeshInstance3D.new()

    mi.mesh = MachMeshes.tunnelBox(1.0, 1.0, 1.0, thickness, chamfer)
    mi.mesh.surface_set_material(0, material)
    mi.transform = Transform3D.IDENTITY
    
    if get_child_count():
        get_child(0).free()
    
    add_child(mi)
