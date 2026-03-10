@tool
class_name Cross
extends Node3D

@export_range(0.1, 10.0, 0.1) var width  = 1.0: 
    set(v): width  = v; generate()
@export_range(0.1, 10.0, 0.01) var height = 0.33: 
    set(v): height = v; generate()
@export_range(0.0, 1.0, 0.01) var thickness = 0.33:
    set(v): thickness = v; generate()
    
@export var material : Material:
    set(v): material = v; generate()

func _ready():

    generate()

func tri(st : SurfaceTool, p1 : Vector3, p2 : Vector3, p3 : Vector3):

    st.add_vertex(p1)
    st.add_vertex(p2)
    st.add_vertex(p3)
    
func quad(st : SurfaceTool, p1 : Vector3, p2 : Vector3, p3 : Vector3, p4 : Vector3):

    tri(st, p1, p2, p3)
    tri(st, p1, p3, p4)

func quad3(st : SurfaceTool, p1 : Vector3, p2 : Vector3, p3 : Vector3):
    
    quad(st, p1, p2, p3, p3 + (p1-p2))
    
func generate():

    var st = SurfaceTool.new()
    
    st.begin(Mesh.PRIMITIVE_TRIANGLES)
    st.set_smooth_group(-1) # flat shading
    
    var mi = MeshInstance3D.new()
    mi.mesh = st.commit()
    mi.mesh = MachMeshes.cross(width, height, thickness)
    mi.mesh.surface_set_material(0, material)
    mi.transform = Transform3D.IDENTITY
    
    if get_child_count():
        get_child(0).free()
    
    add_child(mi)
