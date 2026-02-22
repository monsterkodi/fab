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
@export_range(0.0, 1.0, 0.1) var chamfer = 0.4:
    set(v): chamfer = v; generate()
    
@export var material : Material

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
    
    var tip  = height*Vector3.UP
    
    var w  = width/2
    var h  = height/2
    var d  = depth/2
    var cw = w
    var ch = h
    var cd = d
    var iw = w - thickness
    var ih = h - thickness
    var id = d - thickness
    
    st.set_smooth_group(-1) # flat shading
    
    if chamfer > 0:
        cw = w - thickness * chamfer
        ch = h - thickness * chamfer
        cd = d - thickness * chamfer

        quad3(st, Vector3( cw,  h, -cd), Vector3(-cw,  h, -cd), Vector3(-cw,  ch, -d)) # rear top
        quad3(st, Vector3( cw, -ch, -d), Vector3( w, -ch, -cd), Vector3( w,  ch, -cd)) # rear right
        quad3(st, Vector3(-cw,  ch, -d), Vector3(-w,  ch, -cd), Vector3(-w, -ch, -cd)) # rear left
        quad3(st, Vector3(-cw, -h, -cd), Vector3( cw, -h, -cd), Vector3( cw, -ch, -d)) # rear bottom

        quad3(st, Vector3(-cw,  ch,  d), Vector3(-cw,  h,  cd), Vector3( cw,  h,  cd)) # front top
        quad3(st, Vector3( w,  ch,  cd), Vector3( w, -ch,  cd), Vector3( cw, -ch,  d)) # front right
        quad3(st, Vector3(-w, -ch,  cd), Vector3(-w,  ch,  cd), Vector3(-cw,  ch,  d)) # front left
        quad3(st, Vector3( cw, -ch,  d), Vector3( cw, -h,  cd), Vector3(-cw, -h,  cd)) # front bottom
        
        quad3(st, Vector3(-cw,  h,  cd), Vector3(-w,  ch, cd), Vector3( -w,  ch, -cd)) # top left
        quad3(st, Vector3( w,  ch, -cd), Vector3( w,  ch, cd), Vector3( cw,   h,  cd)) # top right
        quad3(st, Vector3(-w, -ch, -cd), Vector3(-w, -ch, cd), Vector3(-cw,  -h,  cd)) # bottom left
        quad3(st, Vector3( cw, -h,  cd), Vector3( w, -ch, cd), Vector3(  w, -ch, -cd)) # bottom right
        
        tri(st, Vector3(-cw,  ch,  d), Vector3(-w,  ch,  cd), Vector3(-cw,  h,  cd)) # top left front
        tri(st, Vector3( cw,  ch,  d), Vector3(cw,   h,  cd), Vector3( w,  ch,  cd)) # top right front
        tri(st, Vector3(-cw,  h, -cd), Vector3(-w,  ch, -cd), Vector3(-cw,  ch, -d)) # top left  rear
        tri(st, Vector3( w,  ch, -cd), Vector3(cw,   h, -cd), Vector3( cw,  ch, -d)) # top right rear

        tri(st, Vector3(-cw,  -h, cd), Vector3(-w, -ch,  cd), Vector3(-cw, -ch,  d)) # bottom left front
        tri(st, Vector3( w,  -ch, cd), Vector3(cw,  -h,  cd), Vector3( cw, -ch,  d)) # bottom right front
        tri(st, Vector3(-cw, -ch, -d), Vector3(-w, -ch, -cd), Vector3(-cw,  -h,-cd)) # bottom left  rear
        tri(st, Vector3( cw, -ch, -d), Vector3(cw,  -h, -cd), Vector3( w,  -ch,-cd)) # bottom right rear
    
    # outer box
    quad3(st, Vector3(-cw,  ch, -d),  Vector3(-cw, -ch, -d), Vector3( cw, -ch, -d)) # rear 
    quad3(st, Vector3(-cw,  h,  cd),  Vector3(-cw,  h, -cd), Vector3( cw,  h, -cd)) # top 
    quad3(st, Vector3( w,  ch, -cd),  Vector3( w, -ch, -cd), Vector3( w, -ch,  cd)) # right 
    quad3(st, Vector3(-w, -ch,  cd),  Vector3(-w, -ch, -cd), Vector3(-w,  ch, -cd)) # left
    quad3(st, Vector3( cw, -h, -cd),  Vector3(-cw, -h, -cd), Vector3(-cw, -h,  cd)) # bottom  

    # outer front frame
    quad(st, Vector3(-cw, ch, d), Vector3( cw,  ch, d), Vector3( iw,  ih, d), Vector3(-iw,  ih, d)) # top
    quad(st, Vector3(-cw, ch, d), Vector3(-iw,  ih, d), Vector3(-iw, -ih, d), Vector3(-cw, -ch, d)) # left
    quad(st, Vector3( cw, ch, d), Vector3( cw, -ch, d), Vector3( iw, -ih, d), Vector3( iw,  ih, d)) # right
    quad(st, Vector3(-cw,-ch, d), Vector3(-iw, -ih, d), Vector3( iw, -ih, d), Vector3( cw, -ch, d)) # bottom

    # inner box
    
    quad3(st, Vector3( iw, -ih, -id),  Vector3(-iw, -ih, -id), Vector3(-iw,  ih, -id)) # rear 
    quad3(st, Vector3( iw,  ih, -id),  Vector3(-iw,  ih, -id), Vector3(-iw,  ih,   d)) # top 
    quad3(st, Vector3( iw, -ih,   d),  Vector3( iw, -ih, -id), Vector3( iw,  ih, -id)) # right 
    quad3(st, Vector3(-iw,  ih, -id),  Vector3(-iw, -ih, -id), Vector3(-iw, -ih,   d)) # left
    quad3(st, Vector3(-iw, -ih,   d),  Vector3(-iw, -ih, -id), Vector3( iw, -ih, -id)) # bottom  
        
    st.index()
    st.generate_normals()
    
    var mi = MeshInstance3D.new()
    mi.mesh = st.commit()
    mi.material_override = material
    mi.transform = Transform3D.IDENTITY
    
    if get_child_count():
        get_child(0).free()
    
    self.add_child(mi)
