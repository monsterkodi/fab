extends Node3D

var dict = {"dot": [], "belt": []}

func _ready():
    
    var st = SurfaceTool.new()
    
    st.begin(Mesh.PRIMITIVE_TRIANGLES)
    
    st.set_uv(Vector2(1,0.5))
    st.add_vertex(Vector3(0.5,  0, 0))
    st.set_uv(Vector2(0,0))
    st.add_vertex(Vector3(0.25, 0, 0.25))
    st.set_uv(Vector2(0,1))
    st.add_vertex(Vector3(0.25, 0, -0.25))
    
    st.index()
    st.generate_normals()
    $Belt.multimesh.mesh = st.commit()
    
func add(typ:String, node):

    dict[typ].append(node)
    
func del(typ:String, node):
    
    dict[typ].erase(node)
    
func clear(typ:String):
    
    dict[typ].clear()

func _process(delta:float):
    
    var num:int
    
    var dots = dict.dot
    num = dots.size()  
    $Dot.multimesh.instance_count = num 
    for i in range(num):
        var trans = Transform3D.IDENTITY
        trans.origin.x = dots[i].x
        trans.origin.z = dots[i].y
        trans.origin.y = 0.02
        var sc = 0.25
        trans = trans.scaled_local(Vector3(sc,sc,sc))
        $Dot.multimesh.set_instance_transform(i, trans)

    dots = dict.belt
    num = dots.size()  
    $Belt.multimesh.instance_count = num 
    for i in range(num):
        var trans = Transform3D.IDENTITY
        
        if dots[i].z == 2:
            trans = trans.rotated(Vector3.UP, deg_to_rad(180))
        elif dots[i].z == 1:
            trans = trans.rotated(Vector3.UP, deg_to_rad(90))
        elif dots[i].z == 3:
            trans = trans.rotated(Vector3.UP, deg_to_rad(-90))
            
        trans.origin.x = dots[i].x
        trans.origin.z = dots[i].y
        trans.origin.y = 0.02
                
        $Belt.multimesh.set_instance_transform(i, trans)
    
