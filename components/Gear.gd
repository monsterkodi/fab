@tool
class_name Gear
extends Node3D

@export_range(0.01, 10.0, 0.01) var outerRadius = 0.5:
    set(v): outerRadius = v; generate()
@export_range(0.0, 1.0, 0.01) var innerFactor = 0.3:
    set(v): innerFactor = v; generate()
@export_range(0.01, 10.0, 0.01) var height = 0.2:
    set(v): height = v; generate()
@export_range(6, 36, 1) var spokeCount = 8:
    set(v): spokeCount = v; generate()
@export_range(0.0, 1.0, 0.01) var spokeLengthFactor = 0.5:
    set(v): spokeLengthFactor = v; generate()
@export_range(0.0, 1.0, 0.01) var spokeWidthFactor = 0.5:
    set(v): spokeWidthFactor = v; generate()
@export var bottom : bool = false:
    set(v): bottom = v; generate()
    
@export var material : Material:
    set(v): material = v; generate()
    
func _ready():
    
    generate()
    
func generate():

    var mi = MeshInstance3D.new()

    mi.mesh = MachMeshes.gear(outerRadius, outerRadius * innerFactor, height, spokeCount, spokeWidthFactor, spokeLengthFactor, bottom)
    mi.mesh.surface_set_material(0, material)
    mi.transform = Transform3D.IDENTITY

    if get_child_count():
        get_child(0).free()
    
    add_child(mi)
