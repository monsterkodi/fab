extends Node
# singleton Item

enum Type {
    Energy,    
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
    CubeCross,
    TubeCross,
    Cubecule,
    Molecule,
    Icosaeder,
    Dodecaeder,
    Octaeder,
    Tetraeder,
    DodecaIcosa,
}

enum Shape {
    Cube,
    Cylinder,
    Sphere,
    Torus,
    CubeCross,
    TubeCross,
    Cubecule,
    Molecule,
    Icosaeder,
    Dodecaeder,
    Octaeder,
    Tetraeder,
    DodecaIcosa,
}

var Types      : Array[Type]
var TypeNames  : Array[String]
var ShapeNames : Array[String]

var TypeInfo = [                                 # energy  white   round  sphere
    [Shape.Torus,         COLOR.ENERGY,          1.0 ,        0,      0,   0   ],    
    [Shape.Cube,          COLOR.ITEM_BLACK,      0.1 ,      0.2,    0.1,   0   ],
    [Shape.Cube,          COLOR.ITEM_RED,        0.05,      0.1,    0.1,   0   ],
    [Shape.Cube,          COLOR.ITEM_GREEN,      0.05,      0.1,    0.1,   0   ],
    [Shape.Cube,          COLOR.ITEM_BLUE,       0.05,      0.1,    0.1,   0   ],
    [Shape.Cube,          COLOR.ITEM_WHITE,      0.2 ,      0.0,    0.1,   0   ],
    [Shape.Cylinder,      COLOR.ITEM_BLACK,      0.1 ,        0,      0,   0.1 ],
    [Shape.Cylinder,      COLOR.ITEM_RED,        0.1 ,        0,      0,   0.1 ],
    [Shape.Cylinder,      COLOR.ITEM_GREEN,      0.1 ,        0,      0,   0.1 ],
    [Shape.Cylinder,      COLOR.ITEM_BLUE,       0.1 ,        0,      0,   0.1 ],
    [Shape.Cylinder,      COLOR.ITEM_WHITE,      0.4 ,        0,      0,   0.1 ],
    [Shape.Sphere,        COLOR.ITEM_BLACK,      0.3 ,        0,      0,   0 ],
    [Shape.Sphere,        COLOR.ITEM_RED,        0.15,        0,      0,   0 ],
    [Shape.Sphere,        COLOR.ITEM_GREEN,      0.15,        0,      0,   0 ],
    [Shape.Sphere,        COLOR.ITEM_BLUE,       0.15,        0,      0,   0 ],
    [Shape.Sphere,        COLOR.ITEM_WHITE,      0.644,       0,      0,   0 ],
    [Shape.CubeCross,     COLOR.ITEM_RED,        1.0,         0,      0,   0 ],
    [Shape.TubeCross,     COLOR.ITEM_GREEN,      2.0,         0,      0,   0 ],
    [Shape.Cubecule,      COLOR.ITEM_WHITE,      4.0,         0,      0,   0 ],
    [Shape.Molecule,      COLOR.ITEM_GREEN,      8.0,         0,      0,   0 ],
    [Shape.Icosaeder,     COLOR.ITEM_RED,        4.0,         0,      0,   0 ],
    [Shape.Dodecaeder,    COLOR.ITEM_BLUE,       8.0,         0,      0,   0 ],
    [Shape.Octaeder,      COLOR.ITEM_WHITE,      4.0,         0,      0,   0 ],
    [Shape.Tetraeder,     COLOR.ITEM_RED,        8.0,         0,      0,   0 ],
    [Shape.DodecaIcosa,   COLOR.ITEM_WHITE,      8.0,         0,      0,   0 ],
]

func _init():
    
    for key in Type:
        Types.push_back(Type[key])
        TypeNames.push_back(key)

    for key in Shape:
        ShapeNames.push_back(key)
        
func shapeForType(type):    return TypeInfo[type][0]
func colorForType(type):    return TypeInfo[type][1]
func energyForType(type):   return TypeInfo[type][2]
func whiteningCost(type):   return TypeInfo[type][3]
func cylinderCost(type):    return TypeInfo[type][4]
func sphereCost(type):      return TypeInfo[type][5]
func typeForString(string): return Type[string]
func stringForType(type):   return TypeNames[type]
func stringForShape(shape): return ShapeNames[shape]
func iconResForType(type):  return "res://icons/items/" + stringForType(type) + ".png"

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

func meshForShape(shape : Shape):
    
    var mesh
    match shape:
        Shape.Cube:        mesh = BoxMesh.new(); mesh.size = Vector3(0.3, 0.3, 0.3)
        Shape.Torus:       mesh = TorusMesh.new(); mesh.outer_radius = 0.17; mesh.inner_radius = 0.055; mesh.ring_segments = 8; mesh.rings = 24
        Shape.Sphere:      mesh = SphereMesh.new(); mesh.radius = 0.2; mesh.height = 0.4; mesh.radial_segments = 24; mesh.rings = 12
        Shape.Cylinder:    mesh = CylinderMesh.new(); mesh.top_radius = 0.18; mesh.bottom_radius = 0.18; mesh.height = 0.3; mesh.rings = 1; mesh.radial_segments = 16
        Shape.CubeCross:   mesh = MachMeshes.cubeCross(    0.4,             COLOR.ITEM_CUBECROSS)
        Shape.TubeCross:   mesh = MachMeshes.cylinderCross(0.4, 0.1,        COLOR.ITEM_TUBECROSS)
        Shape.Cubecule:    mesh = MachMeshes.cubecule(     0.4, 0.3, 0.12,  COLOR.ITEM_CUBECULE)
        Shape.Molecule:    mesh = MachMeshes.molecule(     0.4, 0.04, 0.09, COLOR.ITEM_MOLECULE)
        Shape.Icosaeder:   mesh = Polyhedron.icosahedron(  0.2 )
        Shape.Dodecaeder:  mesh = Polyhedron.dodecahedron( 0.2 )
        Shape.Octaeder:    mesh = Polyhedron.twinOctahedron( 0.15,          COLOR.ITEM_OCTAEDER)
        Shape.Tetraeder:   mesh = Polyhedron.twinTetrahedron( 0.15,          COLOR.ITEM_TETRAEDER)
        Shape.DodecaIcosa: mesh = Polyhedron.twinDodecahedron( 0.2,         COLOR.ITEM_DODECAICOSA)
    return mesh
    
func multiMeshForShape(shape : Shape):
    
    var mm = MultiMeshInstance3D.new()
    mm.name = stringForShape(shape)
    mm.multimesh = MultiMesh.new()
    mm.multimesh.mesh = meshForShape(shape)
    assert(mm.multimesh.mesh)
    
    mm.material_override =  preload("uid://bi5n2lthhnyix")
        
    mm.multimesh.transform_format = MultiMesh.TRANSFORM_3D
    match shape:
        Shape.DodecaIcosa, \
        Shape.Tetraeder, \
        Shape.Octaeder, \
        Shape.CubeCross, \
        Shape.TubeCross, \
        Shape.Cubecule, \
        Shape.Molecule: 
            mm.multimesh.use_colors = false
        _ : mm.multimesh.use_colors = true

    return mm  
