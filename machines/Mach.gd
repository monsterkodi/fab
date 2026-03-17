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
    TubeCross,
    Cubecule,
    Molecule,
    Tree,
}

var ROT_TIP = Basis.from_euler(Vector3(deg_to_rad(35.5), 0, deg_to_rad(45)))
const BRANCH_Y = 2.75
const CANOPY_Y = 4.435

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
                {"pos": Vector3(1.16, 0.2, 0),                  "type": Module.Type.ARROW,      "color": COLOR.TUNNEL},
                ],
        },
    Type.Tunnel2:       {
        "cost": {Item.Type.CylinderBlack: 20},
        "mods": [
                {"in": Vector2i.ZERO,            "dir": Belt.W, "type": Module.Type.TUNNEL_BOX, "color": COLOR.TUNNEL},
                {"out": Belt.NEIGHBOR[Belt.E]*3, "dir": Belt.E, "type": Module.Type.TUNNEL_BOX, "color": COLOR.TUNNEL},
                {"pos": Vector3(1.16, 0.2, 0),                  "type": Module.Type.ARROW,      "color": COLOR.TUNNEL},
                {"pos": Vector3(2.16, 0.2, 0),                  "type": Module.Type.ARROW,      "color": COLOR.TUNNEL},
                ],
        },
    Type.Tunnel3:       {
        "cost": {Item.Type.SphereBlack:   30},
        "mods": [
                {"in": Vector2i.ZERO,            "dir": Belt.W, "type": Module.Type.TUNNEL_BOX, "color": COLOR.TUNNEL},
                {"out": Belt.NEIGHBOR[Belt.E]*4, "dir": Belt.E, "type": Module.Type.TUNNEL_BOX, "color": COLOR.TUNNEL},
                {"pos": Vector3(1.16, 0.2, 0),                  "type": Module.Type.ARROW,      "color": COLOR.TUNNEL},
                {"pos": Vector3(2.16, 0.2, 0),                  "type": Module.Type.ARROW,      "color": COLOR.TUNNEL},
                {"pos": Vector3(3.16, 0.2, 0),                  "type": Module.Type.ARROW,      "color": COLOR.TUNNEL},
                ],
        },
    Type.Root:          {
        "cost": {Item.Type.CubeCross:   1000, Item.Type.TubeCross: 1000},
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
                ],
        },
    Type.Burner:        {
        "cost": {Item.Type.CubeRed:       10, Item.Type.CubeGreen: 10, Item.Type.CubeBlue: 10},
        "mods": [
                {"in": Vector2i.ZERO,          "dir": Belt.W},
                {"out": Belt.NEIGHBOR[Belt.E], "dir": Belt.E, "item": Item.Type.Energy},
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
                ],
        },
    Type.Whitener:      {
        "cost": {Item.Type.Energy:        10},
        "mods": [
                {"in":  Vector2i.ZERO,         "dir": Belt.W, "shape": Item.Shape.Cube},
                {"in":  Belt.NEIGHBOR[Belt.S], "dir": Belt.S, "item":  Item.Type.Energy},
                {"out": Belt.NEIGHBOR[Belt.E], "dir": Belt.E, "item":  Item.Type.CubeWhite},
                ],
        },
    Type.Cylinder:      {
        "cost": {Item.Type.Energy:        20},
        "mods": [
                {"in":  Vector2i.ZERO,         "dir": Belt.W, "shape": Item.Shape.Cube},
                {"in":  Belt.NEIGHBOR[Belt.S], "dir": Belt.S, "item":  Item.Type.Energy},
                {"out": Belt.NEIGHBOR[Belt.E], "dir": Belt.E, "shape": Item.Shape.Cylinder},
                ],
        },
    Type.Sphere:        {
        "cost": {Item.Type.Energy:        30},
        "mods": [
                {"in":  Vector2i.ZERO,         "dir": Belt.W, "shape": Item.Shape.Cylinder},
                {"in":  Belt.NEIGHBOR[Belt.S], "dir": Belt.S, "item":  Item.Type.Energy},
                {"out": Belt.NEIGHBOR[Belt.E], "dir": Belt.E, "shape": Item.Shape.Sphere},
                ],
        },
    Type.Counter:       {
        "cost": {Item.Type.CubeBlack:     10},
        "mods": [
                {"pos": Vector3(0.0, 0.5, 0), "type": Module.Type.FRAME, "color": COLOR.COUNTER_BOX},
                {"pos": Vector3(0.5, 0.9, 0), "type": Module.Type.ARROW, "color": COLOR.COUNTER_BOX },
                #{"belt": Vector2i.ZERO,       "type": Belt.I_W | Belt.O_E },
                ],
        },
    Type.CubeCross:     {
        "cost": {Item.Type.CubeRed:       30, Item.Type.CubeGreen:     30, Item.Type.CubeBlue:     30},
        "recipe": { "in":   [[Item.Type.CubeRed,   2], [Item.Type.CubeGreen, 2], [Item.Type.CubeBlue, 2]], 
                    "out":  [[Item.Type.CubeCross, 1]], "time": 2.0},
        "mods": [
                {"in":  Belt.NEIGHBOR[Belt.W] + Belt.NEIGHBOR[Belt.N], "dir": Belt.W},
                {"in":  Belt.NEIGHBOR[Belt.W],                         "dir": Belt.W},
                {"in":  Belt.NEIGHBOR[Belt.W] + Belt.NEIGHBOR[Belt.S], "dir": Belt.W},
                {"out": Belt.NEIGHBOR[Belt.E],                         "dir": Belt.E},
                {"pos": Vector3( 0,0.5,0), "type": Module.Type.BOX,     "color": COLOR.BUILDING },
                {"pos": Vector3( 0, 1, 0), "type": Module.Type.GEAR,    "color": COLOR.BUILDING},
                ],
        },
    Type.TubeCross: {
        "cost": {Item.Type.CylinderRed:   30, Item.Type.CylinderGreen: 30, Item.Type.CylinderBlue: 30},
        "recipe": { "in":   [[Item.Type.CylinderRed,   2], [Item.Type.CylinderGreen, 2], [Item.Type.CylinderBlue, 2]], 
                    "out":  [[Item.Type.TubeCross, 1]], "time": 2.0},
        "mods": [
                {"in":  Belt.NEIGHBOR[Belt.W] + Belt.NEIGHBOR[Belt.N], "dir": Belt.W},
                {"in":  Belt.NEIGHBOR[Belt.W],                         "dir": Belt.W},
                {"in":  Belt.NEIGHBOR[Belt.W] + Belt.NEIGHBOR[Belt.S], "dir": Belt.W},
                {"out": Belt.NEIGHBOR[Belt.E],                         "dir": Belt.E},
                {"pos": Vector3( 0,0.5,0), "type": Module.Type.BOX,    "color": COLOR.BUILDING },
                {"pos": Vector3( 0, 1, 0), "type": Module.Type.GEAR,   "color": COLOR.BUILDING},
                ],
        },
    Type.Cubecule:      {
        "cost": {Item.Type.CylinderWhite: 30, Item.Type.CubeCross:     30, Item.Type.Energy:       30},
        "recipe": { "in":   [[Item.Type.CylinderWhite, 2], [Item.Type.CubeCross, 2], [Item.Type.Energy, 2]], 
                    "out":  [[Item.Type.Cubecule,      1]], "time": 2.0},
        "mods": [
                {"in":  Belt.NEIGHBOR[Belt.W] + Belt.NEIGHBOR[Belt.N], "dir": Belt.W},
                {"in":  Belt.NEIGHBOR[Belt.W],                         "dir": Belt.W},
                {"in":  Belt.NEIGHBOR[Belt.W] + Belt.NEIGHBOR[Belt.S], "dir": Belt.S},
                {"out": Belt.NEIGHBOR[Belt.E],                         "dir": Belt.E},
                {"pos": Vector3( 0,0.5,0), "type": Module.Type.BOX,    "color": COLOR.BUILDING },
                {"pos": Vector3( 0, 1, 0), "type": Module.Type.GEAR,   "color": COLOR.BUILDING},
                ],
        },
    Type.Molecule:      {
        "cost": {Item.Type.TubeCross:   60, Item.Type.Cubecule: 60, Item.Type.Energy:       60},
        "recipe": { "in":  [[Item.Type.TubeCross, 4], [Item.Type.Cubecule, 4], [Item.Type.Energy, 4]], 
                    "out": [[Item.Type.Molecule,  1]], "time": 6.0},
        "mods": [
                {"in":  Belt.NEIGHBOR[Belt.W] + Belt.NEIGHBOR[Belt.N], "dir": Belt.W},
                {"in":  Belt.NEIGHBOR[Belt.W],                         "dir": Belt.W},
                {"in":  Belt.NEIGHBOR[Belt.W] + Belt.NEIGHBOR[Belt.S], "dir": Belt.S},
                {"out": Belt.NEIGHBOR[Belt.E],                         "dir": Belt.E},
                {"pos": Vector3( 0,0.5,0), "type": Module.Type.BOX,    "color": COLOR.BUILDING },
                {"pos": Vector3( 0, 1, 0), "type": Module.Type.GEAR,   "color": COLOR.BUILDING},
                ],
        },
    Type.Tree: {
        "cost": {Item.Type.SphereBlue:   60, Item.Type.Molecule: 10, Item.Type.CylinderGreen: 60},
        "recipe": { "in":   [[Item.Type.CylinderGreen, 2], [Item.Type.Molecule, 0.1], [Item.Type.SphereBlue, 2]], 
                    "out":  [[Item.Type.Molecule, 0.1, Item.Type.CubeBlack, 1.0]], "time": 1.0 },
        "mods": [
                {"in":  Belt.NEIGHBOR[Belt.N], "dir": Belt.N,  "color": COLOR.TREE_BUILDING},
                {"in":  Belt.NEIGHBOR[Belt.W], "dir": Belt.W,  "color": COLOR.TREE_BUILDING},
                {"in":  Belt.NEIGHBOR[Belt.S], "dir": Belt.S,  "color": COLOR.TREE_BUILDING},
                {"out": Belt.NEIGHBOR[Belt.E], "dir": Belt.E,  "color": COLOR.TREE_BUILDING},
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
        
func posOfSlitAtIndex(modules : Array, index : int):
    
    for module in modules:
        if module.has("in"):
            if index > 0: 
                index -= 1
            else:
                return Vector3(module.in.x, 0.5, module.in.y)
    return null

func posOfSlotAtIndex(modules : Array, index : int):
    
    for module in modules:
        if module.has("out"):
            if index > 0: 
                index -= 1
            else:
                return Vector3(module.out.x, 0.5, module.out.y)
    return null
        
func scaleForShape(shape):
    
    var sy = 0.6
    var sx = 0.6

    if shape in [Item.Shape.Cube, Item.Shape.Cylinder, Item.Shape.Sphere, Item.Shape.Torus]:
        sx = 0.4
        if shape in [Item.Shape.Torus, Item.Shape.Sphere]:
            sy = sx
        else:
            sy = 0.2
    return Basis.from_scale(Vector3(sx, sy, sx))    
        
func scaleForItemType(type):
    
    return scaleForShape(Item.shapeForType(type))
            
func modulesForType(type):
    
    var modules = Mach.Def[type].mods.duplicate()
    if Mach.Def[type].has("recipe"):
        for item in Mach.Def[type].recipe.in:
            var itemType = item[0]
            var pos = posOfSlitAtIndex(modules, Mach.Def[type].recipe.in.find(item)) + Vector3(0,0.5,0)
            var modType = moduleTypeForItemType(itemType)
            var color   = colorForItemType(itemType)
            modules.push_back({"pos": pos, "type": modType, "color": color, "basis": scaleForItemType(itemType)})
        for item in Mach.Def[type].recipe.out:
            var itemType = item[0]
            var pos = posOfSlotAtIndex(modules, Mach.Def[type].recipe.out.find(item)) + Vector3(0,0.5,0)
            var modType = moduleTypeForItemType(itemType)
            var color   = colorForItemType(itemType)
            modules.push_back({"pos": pos, "type": modType, "color": color, "basis": scaleForItemType(itemType)})
    else:
        for mod in Mach.Def[type].mods:
            if mod.has("item"):
                var itemType = mod.item
                var pos
                if mod.has("in"):
                    pos = Vector3(mod.in.x, 1.0, mod.in.y)
                else:
                    pos = Vector3(mod.out.x, 1.0, mod.out.y)
                var modType = moduleTypeForItemType(itemType)
                var color   = colorForItemType(itemType)
                modules.push_back({"pos": pos, "type": modType, "color": color, "basis": scaleForItemType(itemType)})
            elif mod.has("shape"):
                var shape = mod.shape
                var pos
                if mod.has("in"):
                    pos = Vector3(mod.in.x, 1.0, mod.in.y)
                else:
                    pos = Vector3(mod.out.x, 1.0, mod.out.y)
                var modType = moduleTypeForShape(shape)
                var color   = COLOR.SHAPE
                modules.push_back({"pos": pos, "type": modType, "color": color, "basis": scaleForShape(shape)})
                
    return modules        
    
func moduleTypeForShape(shape):
    
    return Module.Type[Item.stringForShape(shape).to_upper()]
    
func moduleTypeForItemType(itemType):
    
    return moduleTypeForShape(Item.shapeForType(itemType))
    
func colorForItemType(itemType):
    
    return Item.colorForType(itemType)
    
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
    
    var res = []
    for mod in Def[type].mods:
        if mod.has("in"):
            var dup = mod.duplicate()
            dup["pos"] = dup["in"]
            res.append(dup)
    return res
    
func slotsForType(type):

    var res = []
    for mod in Def[type].mods:
        if mod.has("out"):            
            var dup = mod.duplicate()
            dup["pos"] = dup["out"]
            res.append(dup)
    return res
        
func decosForType(type):

    var res = []
    for mod in Def[type].mods:
        if mod.has("pos") and not mod.has("in") and not mod.has("out"):
            res.append(mod.duplicate())
    return res
    
func recipeForType(type):
    
    if Def[type].has("recipe"):
        return Def[type].recipe.duplicate()
    return null
    
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
