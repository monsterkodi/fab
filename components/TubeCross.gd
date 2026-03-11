@tool
class_name TubeCross
extends Node3D

@export_range(0.0, 10.0, 0.01) var width = 1.0:
    set(v): width = v; generate()
@export_range(0.0, 5.0, 0.01) var radius = 0.2:
    set(v): radius = v; generate()
@export_range(8, 36, 1) var segments = 18:
    set(v): segments = v; generate()
    
@export var material : Material:
    set(v): material = v; generate()
    
func _ready():
    
    generate()
    
func generate():

    var mi = MeshInstance3D.new()

    mi.mesh = MachMeshes.cylinderCross(width, radius, [Color.RED, Color.GREEN, Color.BLUE], segments)
    mi.mesh.surface_set_material(0, material)
    mi.transform = Transform3D.IDENTITY
    
    if get_child_count():
        get_child(0).free()
    
    add_child(mi)
