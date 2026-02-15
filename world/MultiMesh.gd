extends Node3D

var dict = {"dot": [], "belt": []}

const OUTPUT = [0b0001 << 4, 0b0010 << 4, 0b0100 << 4, 0b1000 << 4]
const INPUT  = [0b0001, 0b0010, 0b0100, 0b1000]

func _ready():
    
    var st = SurfaceTool.new()
    
    st.begin(Mesh.PRIMITIVE_TRIANGLES)
    
    st.set_uv(Vector2(1,0.5))
    st.add_vertex(Vector3(0.375,  0, 0))
    st.set_uv(Vector2(0,0))
    st.add_vertex(Vector3(0.125, 0, 0.15))
    st.set_uv(Vector2(0,1))
    st.add_vertex(Vector3(0.125, 0, -0.15))
    
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
    $Belt.multimesh.instance_count = num * 4
    for n in range(num):
        var t = dots[n].z
        for d in range(4):
            var i = n * 4 + d
            var trans = Transform3D.IDENTITY
                        
            if OUTPUT[d] & t:
                if d == 1:
                    trans = trans.rotated(Vector3.UP, deg_to_rad(270))
                elif d == 2:
                    trans = trans.rotated(Vector3.UP, deg_to_rad(180))
                elif d == 3:
                    trans = trans.rotated(Vector3.UP, deg_to_rad(90))
            elif INPUT[d] & t:
                trans = trans.translated(Vector3(-0.5, 0, 0))
                if d == 1:
                    trans = trans.rotated(Vector3.UP, deg_to_rad(90))
                elif d == 0:
                    trans = trans.rotated(Vector3.UP, deg_to_rad(180))
                elif d == 3:
                    trans = trans.rotated(Vector3.UP, deg_to_rad(270))
            else:
                trans = trans.scaled(Vector3.ZERO)
                
            trans = trans.translated(Vector3(dots[n].x, 0, dots[n].y))
            trans.origin.y = 0.03
      
            $Belt.multimesh.set_instance_transform(i, trans)
    
