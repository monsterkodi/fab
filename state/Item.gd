extends Node
# singleton Item

enum Type {
    CubeBlack,
    CubeRed,
    CubeGreen,
    CubeBlue,
    CubeWhite,
    TorusYellow,
}

enum Shape {
    Cube,
    Torus,
    Sphere,
}

var Types     : Array[Type]
var TypeNames : Array[String]
var TypeMap   : Dictionary[String, Type]

var TypeInfo = [
    [Shape.Cube,  Color.BLACK,      0.1],
    [Shape.Cube,  Color.RED,        0.05],
    [Shape.Cube,  Color.GREEN,      0.05],
    [Shape.Cube,  Color.BLUE,       0.05],
    [Shape.Cube,  Color.WHITE,      0.5],
    [Shape.Torus, Color.ORANGE_RED, 1.0],
]

func _init():
    
    for key in Type:
        Types.push_back(Type[key])
        TypeNames.push_back(key)
        TypeMap[key] = Type[key]
        
func shapeForType(type):    return TypeInfo[type][0]
func colorForType(type):    return TypeInfo[type][1]
func energyForType(type):   return TypeInfo[type][2]
func typeForString(string): return TypeMap[string]
func stringForType(type):   return TypeNames[type]

class Inst:
    
    var pos     : Vector2i
    var dir     = 0
    
    var type    = Type.CubeBlack
    var shape   = Shape.Cube
    var color   = Color.RED
    
    var advance = 0.0
    var scale   = 0.0
    var mvd     = false
    var blckd   = 0
    var skip    = 0
    
    func _init(t):

        type = t
        color = Item.colorForType(type)
        shape = Item.shapeForType(type)
        
    func dpos(): return Vector3i(pos.x, pos.y, dir)
