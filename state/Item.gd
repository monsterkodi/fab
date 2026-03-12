extends Node
# singleton Item

enum Type {
    CubeBlack,
    CubeRed,
    CubeGreen,
    CubeBlue,
    CubeWhite,
    CylinderBlack,
    CylinderRed,
    CylinderGreen,
    CylinderBlue,
    CylinderWhite,
    SphereBlack,
    SphereRed,
    SphereGreen,
    SphereBlue,
    SphereWhite,
    Energy,
    CubeCross,
    CylinderCross,
}

enum Shape {
    Cube,
    Cylinder,
    Sphere,
    Torus,
    CubeCross,
    CylinderCross,
}

var Types     : Array[Type]
var TypeNames : Array[String]
var TypeMap   : Dictionary[String, Type]

var TypeInfo = [                        # energy     # white  # round # sphere
    [Shape.Cube,      COLOR.ITEM_BLACK,      0.1 ,      0.2,    0.1,   0   ],
    [Shape.Cube,      COLOR.ITEM_RED,        0.05,      0.1,    0.1,   0   ],
    [Shape.Cube,      COLOR.ITEM_GREEN,      0.05,      0.1,    0.1,   0   ],
    [Shape.Cube,      COLOR.ITEM_BLUE,       0.05,      0.1,    0.1,   0   ],
    [Shape.Cube,      COLOR.ITEM_WHITE,      0.2 ,      0.0,    0.1,   0   ],
    [Shape.Cylinder,  COLOR.ITEM_BLACK,      0.1 ,        0,      0,   0.1 ],
    [Shape.Cylinder,  COLOR.ITEM_RED,        0.1 ,        0,      0,   0.1 ],
    [Shape.Cylinder,  COLOR.ITEM_GREEN,      0.1 ,        0,      0,   0.1 ],
    [Shape.Cylinder,  COLOR.ITEM_BLUE,       0.1 ,        0,      0,   0.1 ],
    [Shape.Cylinder,  COLOR.ITEM_WHITE,      0.4 ,        0,      0,   0.1 ],
    [Shape.Sphere,    COLOR.ITEM_BLACK,      0.3 ,        0,      0,   0 ],
    [Shape.Sphere,    COLOR.ITEM_RED,        0.15,        0,      0,   0 ],
    [Shape.Sphere,    COLOR.ITEM_GREEN,      0.15,        0,      0,   0 ],
    [Shape.Sphere,    COLOR.ITEM_BLUE,       0.15,        0,      0,   0 ],
    [Shape.Sphere,    COLOR.ITEM_WHITE,      0.644,       0,      0,   0 ],
    [Shape.Torus,     COLOR.ENERGY,          1.0 ,        0,      0,   0 ],
    [Shape.CubeCross, COLOR.ITEM_BLACK,      1.0,         0,      0,   0 ],
    [Shape.CylinderCross, COLOR.ITEM_BLACK,  2.0,         0,      0,   0 ],
]

func _init():
    
    for key in Type:
        Types.push_back(Type[key])
        TypeNames.push_back(key)
        TypeMap[key] = Type[key]
        
func shapeForType(type):    return TypeInfo[type][0]
func colorForType(type):    return TypeInfo[type][1]
func energyForType(type):   return TypeInfo[type][2]
func whiteningCost(type):   return TypeInfo[type][3]
func cylinderCost(type):    return TypeInfo[type][4]
func sphereCost(type):      return TypeInfo[type][5]
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
