@tool
class_name Torus
extends Node3D

@export_range(0.0, 10.0, 0.01) var radius = 1.0:
    set(v): radius = v; generate()
@export_range(0.0, 1.0, 0.01) var thickness = 0.5:
    set(v): thickness = v; generate()
@export_range(-1.0, 1.0, 0.01) var start = 0.0:
    set(v): start = v; generate()
@export_range(0.0, 1.0, 0.01) var partial = 1.0:
    set(v): partial = v; generate()
@export_range(4, 36, 1) var segments = 16:
    set(v): segments = v; generate()    
@export_range(4, 36, 1) var ringSegments = 8:
    set(v): ringSegments = v; generate()    
@export var smooth := false:
    set(v): smooth = v; generate()    
    
@export var material : Material:
    set(v): material = v; generate()
    
func _ready():
    
    generate()
    
func generate():

    var mi = MeshInstance3D.new()

    var startSegment = round(segments * start)
    var numSegments  = ceil(segments * partial)

    mi.mesh = MachMeshes.torus(radius, thickness, segments, ringSegments, startSegment, numSegments, smooth)
    mi.mesh.surface_set_material(0, material)
    mi.transform = Transform3D.IDENTITY
    
    if get_child_count():
        get_child(0).free()
    
    add_child(mi)
