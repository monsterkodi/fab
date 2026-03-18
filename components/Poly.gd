@tool
class_name Poly
extends Node3D

@export_range(0.0, 10.0, 0.01) var size = 1.0:
    set(v): size = v; generate()
    
@export var material : Material:
    set(v): material = v; generate()
    
func _ready():
    
    generate()
    
func generate():

    var mi = MeshInstance3D.new()

    mi.mesh = Polyhedron.icosahedron(size)
    mi.mesh.surface_set_material(0, material)
    mi.transform = Transform3D.IDENTITY
    
    if get_child_count():
        get_child(0).free()
    
    add_child(mi)
