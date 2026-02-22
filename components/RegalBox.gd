@tool
class_name RegalBox
extends Node3D

@export_range(0.1, 10.0, 0.1) var height = 1.0:
    set(v): height = v; generate()
@export_range(0.1, 10.0, 0.1) var width = 1.0:
    set(v): width = v; generate()
@export_range(0.1, 10.0, 0.1) var depth = 1.0:
    set(v): depth = v; generate()
@export_range(0.0, 0.5, 0.01) var thickness = 0.2:
    set(v): thickness = v; generate()
    
@export var material : Material

func _ready():
    
    generate()
    
func quad(st : SurfaceTool, p1 : Vector3, p2 : Vector3, p3 : Vector3, p4 : Vector3):

    st.add_vertex(p1)
    st.add_vertex(p2)
    st.add_vertex(p3)

    st.add_vertex(p1)
    st.add_vertex(p3)
    st.add_vertex(p4)
    
func quad3(st : SurfaceTool, p1 : Vector3, p2 : Vector3, p3 : Vector3):
    
    quad(st, p1, p2, p3, p3 + (p1-p2))
    
func generate():

    var st = SurfaceTool.new()
    
    st.begin(Mesh.PRIMITIVE_TRIANGLES)
    
    var tip  = height*Vector3.UP
    
    var w2 = width/2
    var h2 = height/2
    var d2 = depth/2
    
    st.set_smooth_group(-1)
    
    # outer box
    quad3(st, Vector3(-w2,  h2, -d2),  Vector3(-w2, -h2, -d2), Vector3( w2, -h2, -d2)) # rear 
    quad3(st, Vector3(-w2,  h2,  d2),  Vector3(-w2,  h2, -d2), Vector3( w2,  h2, -d2)) # top 
    quad3(st, Vector3( w2,  h2, -d2),  Vector3( w2, -h2, -d2), Vector3( w2, -h2,  d2)) # right 
    quad3(st, Vector3(-w2, -h2,  d2),  Vector3(-w2, -h2, -d2), Vector3(-w2,  h2, -d2)) # left
    quad3(st, Vector3( w2, -h2, -d2),  Vector3(-w2, -h2, -d2), Vector3(-w2, -h2,  d2)) # bottom  

    var iw2 = w2 - thickness
    var ih2 = h2 - thickness
    var id2 = d2 - thickness

    # inner box
    
    quad3(st, Vector3( iw2, -ih2, -id2),  Vector3(-iw2, -ih2, -id2), Vector3(-iw2,  ih2, -id2)) # rear 
    quad3(st, Vector3( iw2,  ih2, -id2),  Vector3(-iw2,  ih2, -id2), Vector3(-iw2,  ih2,   d2)) # top 
    quad3(st, Vector3( iw2, -ih2,   d2),  Vector3( iw2, -ih2, -id2), Vector3( iw2,  ih2, -id2)) # right 
    quad3(st, Vector3(-iw2,  ih2, -id2),  Vector3(-iw2, -ih2, -id2), Vector3(-iw2, -ih2,   d2)) # left
    quad3(st, Vector3(-iw2, -ih2,   d2),  Vector3(-iw2, -ih2, -id2), Vector3( iw2, -ih2, -id2)) # bottom  
    
    # outer front frame
    
    quad(st, Vector3(-w2, h2, d2),  Vector3(w2, h2, d2), Vector3( iw2, ih2, d2), Vector3( -iw2, ih2, d2)) # top
    quad(st, Vector3(-w2, h2, d2),  Vector3(-iw2, ih2, d2), Vector3( -iw2, -ih2, d2), Vector3( -w2, -h2, d2)) # left
    quad(st, Vector3( w2, h2, d2),  Vector3(  w2, -h2, d2), Vector3(  iw2, -ih2, d2), Vector3( iw2, ih2, d2)) # right
    quad(st, Vector3(-w2, -h2, d2), Vector3( -iw2, -ih2, d2), Vector3( iw2, -ih2, d2), Vector3(w2, -h2, d2)) # bottom
    
    st.index()
    st.generate_normals()
    
    var mi = MeshInstance3D.new()
    mi.mesh = st.commit()
    mi.material_override = material
    mi.transform = Transform3D.IDENTITY
    
    if get_child_count():
        get_child(0).free()
    
    self.add_child(mi)
