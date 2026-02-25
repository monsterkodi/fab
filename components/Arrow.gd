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
    
    var w  = width/2
    var h  = height/2
    
    st.set_smooth_group(-1) # flat shading
    
    var s  = width * thickness
    var sh = s/2
    var cf = Vector3( 0, h,  0)
    var cb = Vector3( 0, h, -s)
    var rf = Vector3( w, h, -w)
    var lf = Vector3(-w, h, -w)
    var rb = Vector3( w-sh, h, -w-sh)
    var lb = Vector3(-w+sh, h, -w-sh)
    
    quad(st, cf, cb, rb, rf)
    quad(st, cb, cf, lf, lb)
    
    if height > 0:
        
        var bcf = Vector3( 0,    -h,  0)
        var bcb = Vector3( 0,    -h, -s)
        var brf = Vector3( w,    -h, -w)
        var blf = Vector3(-w,    -h, -w)
        var brb = Vector3( w-sh, -h, -w-sh)
        var blb = Vector3(-w+sh, -h, -w-sh)
        
        quad3(st, bcf, cf, rf)
        quad3(st, cf, bcf, blf)

        quad3(st, rf, rb, brb)
        quad3(st, brb, rb, cb)

        quad3(st, lf, blf, blb)
        quad3(st, lb, blb, bcb)
        
        quad(st, brb, bcb, bcf, brf)
        quad(st, blf, bcf, bcb, blb)
        
    st.index()
    st.generate_normals()
    
    var mi = MeshInstance3D.new()
    mi.mesh = st.commit()
    mi.mesh.surface_set_material(0, material)
    mi.transform = Transform3D.IDENTITY
    
    if get_child_count():
        get_child(0).free()
    
    add_child(mi)
