extends Node3D

var dict = {"dot": [], "belt": [], "temp": []}
var beltNames = [
    "ES_W", 
    "NES_W", 
    "NE_W",  
    "NS_W",  
    "SW_NE", 
    "WE_NS", 
    "W_E", 
    "W_ES", 
    "W_N",  
    "W_NE", 
    "W_NES",
    "W_NS", 
    "W_S",  
    ]
var beltPieces = {
 #0b0001_0000: ["W_E",   0],
 #0b0000_0100: ["W_E",   0],
 0b0001_0100: ["W_E",   0],
 0b1000_0100: ["W_N",   0],
 0b0010_0100: ["W_S",   0],
 0b0011_0100: ["W_ES",  0],
 0b1001_0100: ["W_NE",  0],
 0b1010_0100: ["W_NS",  0],
 0b0100_0011: ["ES_W",  0],
 0b0100_1001: ["NE_W",  0],
 0b0100_1010: ["NS_W",  0],
 0b1011_0100: ["W_NES", 0],
 0b0100_1011: ["NES_W", 0],
 0b1001_0110: ["SW_NE", 0],
 0b1010_0101: ["WE_NS", 0],

 #0b0010_0000: ["W_E",   1],
 #0b0000_1000: ["W_E",   1],
 0b0010_1000: ["W_E",   1],
 0b0001_1000: ["W_N",   1],
 0b0100_1000: ["W_S",   1],
 0b0110_1000: ["W_ES",  1],
 0b0011_1000: ["W_NE",  1],
 0b0101_1000: ["W_NS",  1],
 0b1000_0110: ["ES_W",  1],
 0b1000_0011: ["NE_W",  1],
 0b1000_0101: ["NS_W",  1],
 0b0111_1000: ["W_NES", 1],
 0b1000_0111: ["NES_W", 1],
 0b0011_1100: ["SW_NE", 1],
 0b0101_1010: ["WE_NS", 1],

 #0b0100_0000: ["W_E",   2],
 #0b0000_0001: ["W_E",   2],
 0b0100_0001: ["W_E",   2],
 0b0010_0001: ["W_N",   2],
 0b1000_0001: ["W_S",   2],
 0b1100_0001: ["W_ES",  2],
 0b0110_0001: ["W_NE",  2],
 0b1010_0001: ["W_NS",  2],
 0b0001_1100: ["ES_W",  2],
 0b0001_0110: ["NE_W",  2],
 0b0001_1010: ["NS_W",  2],
 0b1110_0001: ["W_NES", 2],
 0b0001_1110: ["NES_W", 2],
 0b0110_1001: ["SW_NE", 2],

 #0b1000_0000: ["W_E",   3],
 #0b0000_0010: ["W_E",   3],
 0b1000_0010: ["W_E",   3],
 0b0100_0010: ["W_N",   3],
 0b0001_0010: ["W_S",   3],
 0b1001_0010: ["W_ES",  3],
 0b1100_0010: ["W_NE",  3],
 0b0101_0010: ["W_NS",  3],
 0b0010_1001: ["ES_W",  3],
 0b0010_1100: ["NE_W",  3],
 0b0010_0101: ["NS_W",  3],
 0b1101_0010: ["W_NES", 3],
 0b0010_1101: ["NES_W", 3],
 0b1100_0011: ["SW_NE", 3],
}

func _ready():
    
    for key in beltNames:
        var mesh : PlaneMesh = get_node("Temp_"+key).multimesh.mesh
        var material : ShaderMaterial = mesh.material
        material.set_shader_parameter("RimColor", Color(0.392, 0.392, 1.0, 1.0))
        material.set_shader_parameter("SpokeColor", Color(0.238, 0.238, 0.61, 1.0))
        material.render_priority = 10
    
func add(typ:String, node):

    dict[typ].append(node)
    
func del(typ:String, node):
    
    dict[typ].erase(node)
    
func clear(typ:String):
    
    dict[typ].clear()

func _process(delta:float):
    
    var dots = dict.dot
    var num = dots.size()  
    $Dot.multimesh.instance_count = num 
    for i in range(num):
        var trans = Transform3D.IDENTITY
        trans.origin.x = dots[i].x
        trans.origin.z = dots[i].y
        trans.origin.y = 0.02
        var sc = 0.25
        trans = trans.scaled_local(Vector3(sc,sc,sc))
        $Dot.multimesh.set_instance_transform(i, trans)

    drawPieces(dict.belt, "Belt_")
    drawPieces(dict.temp, "Temp_")
    
func drawPieces(pieces, prefix):
    
    var count : Dictionary[String, int]
    
    for key in beltNames:
        count[key] = 0
        
    for n in range(pieces.size()):
        var t = pieces[n].z
        if beltPieces.has(t): 
            count[beltPieces[t][0]] += 1
            
    for key in count:
        get_node(prefix+key).multimesh.instance_count = count[key]
        count[key] = 0
        
    for n in range(pieces.size()):
        var t = pieces[n].z
        if not beltPieces.has(t): 
            #Log.log("nt", n, t, Belt.stringForType(t))
            continue
        var key = beltPieces[t][0]
        var mm = get_node(prefix+key).multimesh
        var trans = Transform3D.IDENTITY
        if beltPieces[t][1]:
            trans = trans.rotated(Vector3.UP, deg_to_rad(-90*beltPieces[t][1]))
        trans = trans.translated(Vector3(pieces[n].x, 0.04, pieces[n].y))
        mm.set_instance_transform(count[key], trans)
        count[key] += 1
        
