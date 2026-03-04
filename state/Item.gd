extends Node
# singleton Item

enum Type {
    CubeBlack,
    CubeRed,
    CubeGreen,
    CubeBlue,
    CubeWhite,
}

enum Shape {
    Cube
}

var Types     : Array[Type]
var TypeNames : Array[String]

func _init():
    
    for key in Type:
        Types.push_back(Type[key])
        TypeNames.push_back(key)
        Log.log(Type[key], key)
        
    #Log.log("Item Types", Types, TypeNames)

class Inst:
    
    var pos     : Vector2i
    var dir     = 0
    var type    = Type.CubeBlack
    var shape   = Shape.Cube
    var advance = 0.0
    var scale   = 0.0
    var color   = Color.RED
    var mvd     = false
    var blckd   = 0
    var skip    = 0
    func dpos(): return Vector3i(pos.x, pos.y, dir)
