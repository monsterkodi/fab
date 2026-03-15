extends Node
# singleton Mach

enum Type {
    Belt,
    Tunnel,
    Tunnel2,
    Tunnel3,
    Root,
    Storage,
    Prism,
    Mixer,
    Burner,
    Whitener,
    Cylinder,
    Sphere,
    Counter,
    CubeCross,
    CylinderCross,
    Cubecule,
    Molecule,
    Tree,
}

var ROT_Y   = Basis.from_euler(Vector3(0, deg_to_rad(90), 0))
var ROT_Y45 = Basis.from_euler(Vector3(0, deg_to_rad(45), 0))
var ROT_TIP = Basis.from_euler(Vector3(deg_to_rad(35.5), 0, deg_to_rad(45)))
var SCL_ITM = Basis.from_scale(Vector3(0.4, 0.2, 0.4))

var Def : Dictionary[Mach.Type,Dictionary] = {
    Type.Belt:          { 
        "cost": {Item.Type.CubeBlack:     1},
        "mods": [
                ],
        },
    Type.Tunnel:        {
        "cost": {Item.Type.CubeBlack:     10},
        "mods": [
                {"in": Vector2i.ZERO,            "dir": Belt.W, "type": Module.Type.TUNNEL_BOX, "color": COLOR.TUNNEL},
                {"out": Belt.NEIGHBOR[Belt.E]*2, "dir": Belt.E, "type": Module.Type.TUNNEL_BOX, "color": COLOR.TUNNEL},
                {"pos": Vector3(1.16, 0.2, 0),                  "type": Module.Type.ARROW,      "color": COLOR.TUNNEL, "basis": ROT_Y },
                ],
        },
    Type.Tunnel2:       {
        "cost": {Item.Type.CylinderBlack: 20},
        "mods": [
                {"in": Vector2i.ZERO,            "dir": Belt.W, "type": Module.Type.TUNNEL_BOX, "color": COLOR.TUNNEL},
                {"out": Belt.NEIGHBOR[Belt.E]*3, "dir": Belt.E, "type": Module.Type.TUNNEL_BOX, "color": COLOR.TUNNEL},
                {"pos": Vector3(1.16, 0.2, 0),                  "type": Module.Type.ARROW,      "color": COLOR.TUNNEL, "basis": ROT_Y },
                {"pos": Vector3(2.16, 0.2, 0),                  "type": Module.Type.ARROW,      "color": COLOR.TUNNEL, "basis": ROT_Y },
                ],
        },
    Type.Tunnel3:       {
        "cost": {Item.Type.SphereBlack:   30},
        "mods": [
                {"in": Vector2i.ZERO,            "dir": Belt.W, "type": Module.Type.TUNNEL_BOX, "color": COLOR.TUNNEL},
                {"out": Belt.NEIGHBOR[Belt.E]*4, "dir": Belt.E, "type": Module.Type.TUNNEL_BOX, "color": COLOR.TUNNEL},
                {"pos": Vector3(1.16, 0.2, 0),                  "type": Module.Type.ARROW,      "color": COLOR.TUNNEL, "basis": ROT_Y },
                {"pos": Vector3(2.16, 0.2, 0),                  "type": Module.Type.ARROW,      "color": COLOR.TUNNEL, "basis": ROT_Y },
                {"pos": Vector3(3.16, 0.2, 0),                  "type": Module.Type.ARROW,      "color": COLOR.TUNNEL, "basis": ROT_Y },
                ],
        },
    Type.Root:          {
        "cost": {Item.Type.CubeCross:   1000, Item.Type.CylinderCross: 1000},
        "mods": [
                {"out": Belt.NEIGHBOR[Belt.E], "dir": Belt.E},
                {"out": Belt.NEIGHBOR[Belt.S], "dir": Belt.S},
                {"out": Belt.NEIGHBOR[Belt.W], "dir": Belt.W},
                {"out": Belt.NEIGHBOR[Belt.N], "dir": Belt.N},
                {"pos": Vector3(0, 0.5, 0), "type": Module.Type.BOX,  "color": COLOR.BUILDING },
                {"pos": Vector3(0, 2.3, 0), "type": Module.Type.CUBE, "color": COLOR.ITEM_BLACK, "basis": ROT_TIP.scaled(Vector3(1.5,1.5,1.5)) },
                ],
        },
    Type.Storage:       {
        "cost": {Item.Type.CubeBlack:     10},
        "mods": [
                {"in": Vector2i.ZERO, "dir": Belt.W},
                {"pos": Vector3(0, 1.6, 0), "type": Module.Type.STORAGE, "color": COLOR.BUILDING},
                ],
        },
    Type.Prism:         {
        "cost": {Item.Type.CubeBlack:     30},
        "mods": [
                {"in": Vector2i.ZERO,                                "dir": Belt.W, "item": Item.Type.CubeBlack},
                {"out": Belt.NEIGHBOR[Belt.E]+Belt.NEIGHBOR[Belt.N], "dir": Belt.E, "item": Item.Type.CubeRed},
                {"out": Belt.NEIGHBOR[Belt.E],                       "dir": Belt.E, "item": Item.Type.CubeGreen},
                {"out": Belt.NEIGHBOR[Belt.E]+Belt.NEIGHBOR[Belt.S], "dir": Belt.E, "item": Item.Type.CubeBlue},
                {"pos": Vector3(0, 1, 0),  "type": Module.Type.CUBE, "color": COLOR.ITEM_BLACK, "basis": SCL_ITM },
                {"pos": Vector3(1, 1, -1), "type": Module.Type.CUBE, "color": COLOR.ITEM_RED,   "basis": SCL_ITM },
                {"pos": Vector3(1, 1,  0), "type": Module.Type.CUBE, "color": COLOR.ITEM_GREEN, "basis": SCL_ITM },
                {"pos": Vector3(1, 1,  1), "type": Module.Type.CUBE, "color": COLOR.ITEM_BLUE,  "basis": SCL_ITM },
                ],
        },
    Type.Burner:        {
        "cost": {Item.Type.CubeRed:       10, Item.Type.CubeGreen: 10, Item.Type.CubeBlue: 10},
        "mods": [
                {"in": Vector2i.ZERO,          "dir": Belt.W},
                {"out": Belt.NEIGHBOR[Belt.E], "dir": Belt.E, "item": Item.Type.Energy},
                {"pos": Vector3(1, 1, 0), "type": Module.Type.TORUS, "color": COLOR.ENERGY, "scale": 0.8 },
                {"pos": Vector3(0, 1, 0), "type": Module.Type.GEAR,  "color": COLOR.ENERGY},
                ],
        },
    Type.Mixer:         {
        "cost": {Item.Type.CubeRed:       20, Item.Type.CubeGreen: 20, Item.Type.CubeBlue: 20},
        "mods": [
                {"in":  Belt.NEIGHBOR[Belt.N], "dir": Belt.W, "item": Item.Type.CubeRed},
                {"in":  Vector2i.ZERO,         "dir": Belt.W, "item": Item.Type.CubeGreen},
                {"in":  Belt.NEIGHBOR[Belt.S], "dir": Belt.W, "item": Item.Type.CubeBlue},
                {"out": Belt.NEIGHBOR[Belt.E], "dir": Belt.E, "item": Item.Type.CubeWhite},
                {"pos": Vector3(1, 1, 0),  "type": Module.Type.CUBE, "color": COLOR.ITEM_WHITE, "basis": SCL_ITM },
                {"pos": Vector3(0, 1, -1), "type": Module.Type.CUBE, "color": COLOR.ITEM_RED,   "basis": SCL_ITM },
                {"pos": Vector3(0, 1,  0), "type": Module.Type.CUBE, "color": COLOR.ITEM_GREEN, "basis": SCL_ITM },
                {"pos": Vector3(0, 1,  1), "type": Module.Type.CUBE, "color": COLOR.ITEM_BLUE,  "basis": SCL_ITM },
                ],
        },
    Type.Whitener:      {
        "cost": {Item.Type.Energy:        10},
        "mods": [
                {"in":  Vector2i.ZERO,         "dir": Belt.W, "shape": Item.Shape.Cube},
                {"in":  Belt.NEIGHBOR[Belt.S], "dir": Belt.S, "item":  Item.Type.Energy},
                {"out": Belt.NEIGHBOR[Belt.E], "dir": Belt.E, "item":  Item.Type.CubeWhite},
                {"pos": Vector3(0, 1, 0),     "type": Module.Type.CUBE,  "color": COLOR.BUILDING,   "basis": SCL_ITM },
                {"pos": Vector3(1, 1, 0),     "type": Module.Type.CUBE,  "color": COLOR.ITEM_WHITE, "basis": SCL_ITM },
                {"pos": Vector3(0, 1.025, 1), "type": Module.Type.TORUS, "color": COLOR.ENERGY,     "scale": 0.4 },
                ],
        },
    Type.Cylinder:      {
        "cost": {Item.Type.Energy:        20},
        "mods": [
                {"in":  Vector2i.ZERO,         "dir": Belt.W, "shape": Item.Shape.Cube},
                {"in":  Belt.NEIGHBOR[Belt.S], "dir": Belt.S, "item":  Item.Type.Energy},
                {"out": Belt.NEIGHBOR[Belt.E], "dir": Belt.E},
                {"pos": Vector3(0, 1, 0),     "type": Module.Type.CUBE,     "color": COLOR.BUILDING, "basis": SCL_ITM },
                {"pos": Vector3(1, 1, 0),     "type": Module.Type.CYLINDER, "color": COLOR.BUILDING, "basis": SCL_ITM },
                {"pos": Vector3(0, 1.025, 1), "type": Module.Type.TORUS,    "color": COLOR.ENERGY,   "scale": 0.4 },
                ],
        },
    Type.Sphere:        {
        "cost": {Item.Type.Energy:        30},
        "mods": [
                {"in":  Vector2i.ZERO,         "dir": Belt.W, "shape": Item.Shape.Cylinder},
                {"in":  Belt.NEIGHBOR[Belt.S], "dir": Belt.S, "item":  Item.Type.Energy},
                {"out": Belt.NEIGHBOR[Belt.E], "dir": Belt.E},
                {"pos": Vector3(0, 1, 0),     "type": Module.Type.CYLINDER, "color": COLOR.BUILDING, "basis": SCL_ITM },
                {"pos": Vector3(1, 1, 0),     "type": Module.Type.SPHERE,   "color": COLOR.BUILDING, "basis": SCL_ITM },
                {"pos": Vector3(0, 1.025, 1), "type": Module.Type.TORUS,    "color": COLOR.ENERGY,   "scale": 0.4 },
                ],
        },
    Type.Counter:       {
        "cost": {Item.Type.CubeBlack:     10},
        "mods": [
                {"pos": Vector3(0.0, 0.5, 0), "type": Module.Type.FRAME, "color": COLOR.COUNTER_BOX},
                {"pos": Vector3(0.5, 0.9, 0), "type": Module.Type.ARROW, "color": COLOR.COUNTER_BOX, "basis": ROT_Y },
                #{"belt": Vector2i.ZERO,       "type": Belt.I_W | Belt.O_E },
                ],
        },
    Type.CubeCross:     {
        "cost": {Item.Type.CubeRed:       30, Item.Type.CubeGreen:     30, Item.Type.CubeBlue:     30},
        "mods": [
                {"in":  Belt.NEIGHBOR[Belt.W],                         "dir": Belt.W},
                {"in":  Belt.NEIGHBOR[Belt.W] + Belt.NEIGHBOR[Belt.S], "dir": Belt.W},
                {"in":  Belt.NEIGHBOR[Belt.W] + Belt.NEIGHBOR[Belt.N], "dir": Belt.W},
                {"out": Belt.NEIGHBOR[Belt.E],                         "dir": Belt.E},
                {"pos": Vector3( 0,0.5,0), "type": Module.Type.BOX,     "color": COLOR.BUILDING,   "basis": ROT_Y },
                {"pos": Vector3( 0, 1, 0), "type": Module.Type.GEAR,    "color": COLOR.BUILDING},
                {"pos": Vector3( 1, 1, 0), "type": Module.Type.CUBE_CROSS}, 
                {"pos": Vector3(-1, 1,-1), "type": Module.Type.CUBE,    "color": COLOR.ITEM_RED,   "basis": SCL_ITM },
                {"pos": Vector3(-1, 1, 0), "type": Module.Type.CUBE,    "color": COLOR.ITEM_GREEN, "basis": SCL_ITM },
                {"pos": Vector3(-1, 1, 1), "type": Module.Type.CUBE,    "color": COLOR.ITEM_BLUE,  "basis": SCL_ITM },
                ],
        },
    Type.CylinderCross: {
        "cost": {Item.Type.CylinderRed:   30, Item.Type.CylinderGreen: 30, Item.Type.CylinderBlue: 30},
        "mods": [
                {"in":  Belt.NEIGHBOR[Belt.W],                         "dir": Belt.W},
                {"in":  Belt.NEIGHBOR[Belt.W] + Belt.NEIGHBOR[Belt.S], "dir": Belt.W},
                {"in":  Belt.NEIGHBOR[Belt.W] + Belt.NEIGHBOR[Belt.N], "dir": Belt.W},
                {"out": Belt.NEIGHBOR[Belt.E],                         "dir": Belt.E},
                {"pos": Vector3( 0,0.5,0), "type": Module.Type.BOX,         "color": COLOR.BUILDING,  "basis": ROT_Y },
                {"pos": Vector3( 0, 1, 0), "type": Module.Type.GEAR,        "color": COLOR.BUILDING},
                {"pos": Vector3( 1, 1, 0), "type": Module.Type.CYLINDER_CROSS}, 
                {"pos": Vector3(-1, 1,-1), "type": Module.Type.CYLINDER,    "color": COLOR.ITEM_RED,   "basis": SCL_ITM },
                {"pos": Vector3(-1, 1, 0), "type": Module.Type.CYLINDER,    "color": COLOR.ITEM_GREEN, "basis": SCL_ITM },
                {"pos": Vector3(-1, 1, 1), "type": Module.Type.CYLINDER,    "color": COLOR.ITEM_BLUE,  "basis": SCL_ITM },                
                ],
        },
    Type.Cubecule:      {
        "cost": {Item.Type.CylinderWhite: 30, Item.Type.CubeCross:     30, Item.Type.Energy:       30},
        "mods": [
                {"in":  Belt.NEIGHBOR[Belt.W],                         "dir": Belt.W},
                {"in":  Belt.NEIGHBOR[Belt.W] + Belt.NEIGHBOR[Belt.S], "dir": Belt.S},
                {"in":  Belt.NEIGHBOR[Belt.W] + Belt.NEIGHBOR[Belt.N], "dir": Belt.W},
                {"out": Belt.NEIGHBOR[Belt.E],                         "dir": Belt.E},
                {"pos": Vector3( 0,0.5,0), "type": Module.Type.BOX,      "color": COLOR.BUILDING,   "basis": ROT_Y },
                {"pos": Vector3( 0, 1, 0), "type": Module.Type.GEAR,     "color": COLOR.BUILDING},
                {"pos": Vector3( 1, 1, 0), "type": Module.Type.CUBECULE}, 
                {"pos": Vector3(-1, 1,-1), "type": Module.Type.CYLINDER, "color": COLOR.ITEM_WHITE, "basis": SCL_ITM },
                {"pos": Vector3(-1, 1, 0), "type": Module.Type.CUBE_CROSS },
                {"pos": Vector3(-1, 1, 1), "type": Module.Type.TORUS,    "color": COLOR.ENERGY,     "basis": SCL_ITM },
                ],
        },
    Type.Molecule:      {
        "cost": {Item.Type.SphereWhite:   60, Item.Type.CylinderCross: 60, Item.Type.Energy:       60},
        "mods": [
                {"in":  Belt.NEIGHBOR[Belt.W],                         "dir": Belt.W},
                {"in":  Belt.NEIGHBOR[Belt.W] + Belt.NEIGHBOR[Belt.S], "dir": Belt.S},
                {"in":  Belt.NEIGHBOR[Belt.W] + Belt.NEIGHBOR[Belt.N], "dir": Belt.W},
                {"out": Belt.NEIGHBOR[Belt.E],                         "dir": Belt.E},
                {"pos": Vector3( 0,0.5,0), "type": Module.Type.BOX,      "color": COLOR.BUILDING, "basis": ROT_Y },
                {"pos": Vector3( 0, 1, 0), "type": Module.Type.GEAR,     "color": COLOR.BUILDING},
                {"pos": Vector3( 1, 1, 0), "type": Module.Type.MOLECULE,                          "basis": ROT_Y45 },
                {"pos": Vector3(-1, 1,-1), "type": Module.Type.CYLINDER_CROSS }, 
                {"pos": Vector3(-1, 1, 0), "type": Module.Type.CUBECULE}, 
                {"pos": Vector3(-1, 1, 1), "type": Module.Type.TORUS,    "color": COLOR.ENERGY,   "basis": SCL_ITM },
                ],
        },
    Type.Tree: {
        "cost": {Item.Type.SphereWhite:   60, Item.Type.CylinderCross: 60, Item.Type.Energy:       60},
        "mods": [
                {"in":  Belt.NEIGHBOR[Belt.W], "dir": Belt.W, "item": Item.Type.SphereBlue,    "color": COLOR.TREE_BUILDING},
                {"in":  Belt.NEIGHBOR[Belt.N], "dir": Belt.N, "item": Item.Type.Molecule,      "color": COLOR.TREE_BUILDING},
                {"in":  Belt.NEIGHBOR[Belt.S], "dir": Belt.S, "item": Item.Type.CylinderGreen, "color": COLOR.TREE_BUILDING},
                {"out": Belt.NEIGHBOR[Belt.E], "dir": Belt.E,                                  "color": COLOR.TREE_BUILDING},
                {"pos": Vector3(0, 0.5, 0),       "type": Module.Type.CUBE,         "color": COLOR.TREE_BRANCH},
                {"pos": Vector3(0, 1.0, 0),       "type": Module.Type.TREE_BRANCH,  "color": COLOR.TREE_BRANCH},
                {"pos": Vector3( 1, BRANCH_Y, 0), "type": Module.Type.TREE_BRANCH,  "color": COLOR.TREE_BRANCH, "scale": 0.5},
                {"pos": Vector3(-1, BRANCH_Y, 0), "type": Module.Type.TREE_BRANCH,  "color": COLOR.TREE_BRANCH, "scale": 0.5},
                {"pos": Vector3( 0, BRANCH_Y, 1), "type": Module.Type.TREE_BRANCH,  "color": COLOR.TREE_BRANCH, "scale": 0.5},
                {"pos": Vector3( 0, BRANCH_Y,-1), "type": Module.Type.TREE_BRANCH,  "color": COLOR.TREE_BRANCH, "scale": 0.5},
                {"pos": Vector3( 1, CANOPY_Y, 0), "type": Module.Type.TREE_CANOPY,  "color": COLOR.TREE_CANOPY}, 
                {"pos": Vector3(-1, CANOPY_Y, 0), "type": Module.Type.TREE_CANOPY,  "color": COLOR.TREE_CANOPY}, 
                {"pos": Vector3( 0, CANOPY_Y, 1), "type": Module.Type.TREE_CANOPY,  "color": COLOR.TREE_CANOPY}, 
                {"pos": Vector3( 0, CANOPY_Y,-1), "type": Module.Type.TREE_CANOPY,  "color": COLOR.TREE_CANOPY}, 
                ],
    }
}

var Types     : Array[Type]
var TypeNames : Array[String]

func _init():
    
    for key in Type:
        Types.push_back(Type[key])
        TypeNames.push_back(key)

func costForType(type):
    
    return Def[type].cost

func stringForType(type):   return TypeNames[type]
func typeForString(string): return Type[string]
    
func buildingNameForType(type): return "Building" + stringForType(type)

func beltsForType(type):        
    
    match type:
        
        Type.Counter:
            return [
                {"pos": Vector2i.ZERO, "type": Belt.I_W | Belt.O_E}
            ]
    return []

func slitsForType(type):        
    
    var slits = []
    var mods = Def[type].mods
    for mod in mods:
        if mod.has("in"):
            mod["pos"] = mod["in"]
            slits.append(mod)
    return slits
    
func slotsForType(type):

    var slits = []
    var mods = Def[type].mods
    for mod in mods:
        if mod.has("out"):
            mod["pos"] = mod["out"]
            slits.append(mod)
    return slits
    
const BRANCH_Y = 2.75
const CANOPY_Y = 4.435
    
func decosForType(type):

    var slits = []
    var mods = Def[type].mods
    for mod in mods:
        if mod.has("pos") and not mod.has("in") and not mod.has("out"):
            slits.append(mod)
    return slits
    
func boxTrans(slit, p : Vector3, basis : Basis) -> Transform3D:

    var turns
    match slit.dir:
        Belt.S: turns = 0
        Belt.W: turns = 1
        Belt.N: turns = 2
        Belt.E: turns = 3
        
    var b = basis.rotated(Vector3.UP, turns * deg_to_rad(-90))
    return Transform3D(b, p)
    
func slitArrowTrans(slit, p : Vector3, basis : Basis) -> Transform3D:
    
    var turns
    match slit.dir:
        Belt.S: turns = 2
        Belt.W: turns = 3
        Belt.N: turns = 0
        Belt.E: turns = 1
        
    var b = basis.rotated(Vector3.UP, turns * deg_to_rad(-90))
    return Transform3D(b, p + b * slitArrowOffset())

func slotArrowTrans(slot, p : Vector3, basis : Basis) -> Transform3D:
    
    var turns
    match slot.dir:
        Belt.S: turns = 0
        Belt.W: turns = 1
        Belt.N: turns = 2
        Belt.E: turns = 3
        
    var b = basis.rotated(Vector3.UP, turns * deg_to_rad(-90))
    return Transform3D(b, p + b * slotArrowOffset())
    
func slitArrowOffset() -> Vector3:
    
    return Vector3(0.0, 0.901, -0.2)

func slotArrowOffset() -> Vector3:
    
    return Vector3(0.0, 0.901, 0.5)
