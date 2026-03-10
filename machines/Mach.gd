extends Node
# singleton Mach

enum Type {
    Belt,
    Tunnel,
    Root,
    Storage,
    Prism,
    Mixer,
    Burner,
    Whitener,
    Rounder,
    Sphere,
    Counter,
}

var Types     : Array[Type]
var TypeNames : Array[String]
var TypeMap   : Dictionary[String,Type]

func _init():
    
    for key in Type:
        Types.push_back(Type[key])
        TypeNames.push_back(key)
        TypeMap[key] = Type[key]

var Class = [
    null, 
    MachineTunnel,
    MachineRoot,
    MachineStorage,
    MachinePrism,
    MachineMixer,
    MachineBurner,
    MachineWhitener,
    MachineRounder,
    MachineSphere,
    MachineCounter,
]

func costForType(type):

    match type:
            Type.Tunnel:    return {Item.Type.CubeBlack: 10}
            Type.Root:      return {Item.Type.CubeRed: 1000, Item.Type.CubeGreen: 1000, Item.Type.CubeBlue: 1000}
            Type.Storage:   return {Item.Type.CubeBlack: 10}
            Type.Prism:     return {Item.Type.CubeBlack: 30}
            Type.Burner:    return {Item.Type.CubeRed:   10, Item.Type.CubeGreen: 10, Item.Type.CubeBlue: 10}
            Type.Mixer:     return {Item.Type.CubeRed:   20, Item.Type.CubeGreen: 20, Item.Type.CubeBlue: 20}
            Type.Whitener:  return {Item.Type.CubeWhite: 10}
            Type.Rounder:   return {Item.Type.CubeBlack: 20}
            Type.Sphere:    return {Item.Type.CubeBlack: 20}
            Type.Counter:   return {Item.Type.CubeBlack: 10}
            _:              return {Item.Type.CubeBlack: 1}

func stringForType(type):   return TypeNames[type]
func typeForString(string): return TypeMap[string]
    
func buildingNameForType(type): return "Building" + stringForType(type)

func beltsForType(type):        
    
    match type:
        
        Type.Counter:
            return [
                {"pos": Vector2i.ZERO, "type": Belt.I_W | Belt.O_E}
            ]
    return []

func slitsForType(type):        
    
    match type:
        Type.Tunnel: 
            return [
                {"pos": Vector2i.ZERO, "dir": Belt.W},
            ]
        Type.Prism: 
            return [
                {"pos": Vector2i.ZERO, "dir": Belt.W, "item": Item.Type.CubeBlack},
            ]
        Type.Burner: 
            return [
                {"pos": Vector2i.ZERO, "dir": Belt.W},
            ]
        Type.Mixer: 
            return [
                {"pos": Belt.NEIGHBOR[Belt.N], "dir": Belt.W, "item": Item.Type.CubeRed},
                {"pos": Vector2i.ZERO,         "dir": Belt.W, "item": Item.Type.CubeGreen},
                {"pos": Belt.NEIGHBOR[Belt.S], "dir": Belt.W, "item": Item.Type.CubeBlue},
            ]
        Type.Storage: 
            return [
                {"pos": Vector2i.ZERO, "dir": Belt.W},
            ]
        Type.Whitener: 
            return [
                {"pos": Vector2i.ZERO,         "dir": Belt.W, "shape": Item.Shape.Cube},
                {"pos": Belt.NEIGHBOR[Belt.S], "dir": Belt.S, "item":  Item.Type.TorusYellow},
            ]
        Type.Rounder: 
            return [
                {"pos": Vector2i.ZERO,         "dir": Belt.W, "shape": Item.Shape.Cube},
                {"pos": Belt.NEIGHBOR[Belt.S], "dir": Belt.S, "item":  Item.Type.TorusYellow},
            ]
        Type.Sphere: 
            return [
                {"pos": Vector2i.ZERO,         "dir": Belt.W, "shape": Item.Shape.Cylinder},
                {"pos": Belt.NEIGHBOR[Belt.S], "dir": Belt.S, "item":  Item.Type.TorusYellow},
            ]
    return []
    
func slotsForType(type):
    
    match type:
        Type.Tunnel: 
            return [
                {"pos": Belt.NEIGHBOR[Belt.E]*2,                     "dir": Belt.E},
            ]
        Type.Prism: 
            return [
                {"pos": Belt.NEIGHBOR[Belt.E]+Belt.NEIGHBOR[Belt.N], "dir": Belt.E, "item": Item.Type.CubeRed},
                {"pos": Belt.NEIGHBOR[Belt.E],                       "dir": Belt.E, "item": Item.Type.CubeGreen},
                {"pos": Belt.NEIGHBOR[Belt.E]+Belt.NEIGHBOR[Belt.S], "dir": Belt.E, "item": Item.Type.CubeBlue},
                ]
        Type.Burner: 
            return [
                {"pos": Belt.NEIGHBOR[Belt.E],                       "dir": Belt.E, "item": Item.Type.TorusYellow},
                ]
        Type.Mixer: 
            return [
                {"pos": Belt.NEIGHBOR[Belt.E],                       "dir": Belt.E, "item": Item.Type.CubeWhite},
                ]
        Type.Root:   
            return [
                {"pos": Belt.NEIGHBOR[Belt.E], "dir": Belt.E},
                {"pos": Belt.NEIGHBOR[Belt.S], "dir": Belt.S},
                {"pos": Belt.NEIGHBOR[Belt.W], "dir": Belt.W},
                {"pos": Belt.NEIGHBOR[Belt.N], "dir": Belt.N},
                ]
        Type.Whitener: 
            return [
                {"pos": Belt.NEIGHBOR[Belt.E],                       "dir": Belt.E, "item": Item.Type.CubeWhite},
                ]
        Type.Rounder: 
            return [
                {"pos": Belt.NEIGHBOR[Belt.E],                       "dir": Belt.E},
                ]
        Type.Sphere: 
            return [
                {"pos": Belt.NEIGHBOR[Belt.E],                       "dir": Belt.E},
                ]
    return []
    
func decosForType(type):
    
    match type:
        
        Type.Root:   
            return [ 
                {"pos": Vector3(0, 0.5, 0), "type": MachState.Module.Type.BOX, "color": COLOR.BUILDING },
                {"pos": Vector3(0, 2.3, 0), "type": MachState.Module.Type.CUBE, "color": COLOR.ITEM_BLACK, 
                    "basis": Basis.from_euler(Vector3(deg_to_rad(35.5), 0, deg_to_rad(45))).scaled(Vector3(1.5,1.5,1.5)) },
                ]
        Type.Storage: 
            return [
                {"pos": Vector3(0, 1.7, 0), "type": MachState.Module.Type.CYLINDER, "color": COLOR.BUILDING,
                    "basis": Basis.from_scale(Vector3(0.9, 0.6, 0.9))},
                {"pos": Vector3(0, 1.2, 0), "type": MachState.Module.Type.CYLINDER, "color": COLOR.BUILDING, 
                    "basis": Basis.from_scale(Vector3(0.2, 0.4, 0.2))},
                {"pos": Vector3(0, 2.045, 0), "type": MachState.Module.Type.CYLINDER_CHAMFER, "color": COLOR.BUILDING, 
                    "basis": Basis.from_scale(Vector3(0.9, 0.9, 0.9))},
            ]
        Type.Prism: 
            return [
                {"pos": Vector3(0, 1, 0), "type": MachState.Module.Type.CUBE, "color": COLOR.ITEM_BLACK, 
                    "basis": Basis.from_scale(Vector3(0.4,0.2,0.4)) },
                {"pos": Vector3(1, 1, -1), "type": MachState.Module.Type.CUBE, "color": COLOR.ITEM_RED, 
                    "basis": Basis.from_scale(Vector3(0.4,0.2,0.4)) },
                {"pos": Vector3(1, 1,  0), "type": MachState.Module.Type.CUBE, "color": COLOR.ITEM_GREEN, 
                    "basis": Basis.from_scale(Vector3(0.4,0.2,0.4)) },
                {"pos": Vector3(1, 1,  1), "type": MachState.Module.Type.CUBE, "color": COLOR.ITEM_BLUE, 
                    "basis": Basis.from_scale(Vector3(0.4,0.2,0.4)) },
            ]            
        Type.Mixer: 
            return [
                {"pos": Vector3(1, 1, 0), "type": MachState.Module.Type.CUBE, "color": COLOR.ITEM_WHITE, 
                    "basis": Basis.from_scale(Vector3(0.4,0.2,0.4)) },
                {"pos": Vector3(0, 1, -1), "type": MachState.Module.Type.CUBE, "color": COLOR.ITEM_RED, 
                    "basis": Basis.from_scale(Vector3(0.4,0.2,0.4)) },
                {"pos": Vector3(0, 1,  0), "type": MachState.Module.Type.CUBE, "color": COLOR.ITEM_GREEN, 
                    "basis": Basis.from_scale(Vector3(0.4,0.2,0.4)) },
                {"pos": Vector3(0, 1,  1), "type": MachState.Module.Type.CUBE, "color": COLOR.ITEM_BLUE, 
                    "basis": Basis.from_scale(Vector3(0.4,0.2,0.4)) },
            ]            
        Type.Burner: 
            return [
                {"pos": Vector3(1, 1, 0), "type": MachState.Module.Type.TORUS, "color": COLOR.ENERGY, 
                    "basis": Basis.from_scale(Vector3(0.8,0.8,0.8)) },
                {"pos": Vector3(0, 1, 0), "type": MachState.Module.Type.GEAR, "color": COLOR.ENERGY},
                ]
        Type.Whitener: 
            return [
                {"pos": Vector3(0, 1, 0), "type": MachState.Module.Type.CUBE, "color": COLOR.BUILDING, 
                    "basis": Basis.from_scale(Vector3(0.4,0.2,0.4)) },
                {"pos": Vector3(1, 1, 0), "type": MachState.Module.Type.CUBE, "color": COLOR.ITEM_WHITE, 
                    "basis": Basis.from_scale(Vector3(0.4,0.2,0.4)) },
                {"pos": Vector3(0, 1.025, 1), "type": MachState.Module.Type.TORUS, "color": COLOR.ENERGY, 
                    "basis": Basis.from_scale(Vector3(0.4,0.4,0.4)) },
                ]
        Type.Rounder: 
            return [
                {"pos": Vector3(0, 1, 0), "type": MachState.Module.Type.CUBE, "color": COLOR.BUILDING, 
                    "basis": Basis.from_scale(Vector3(0.4,0.2,0.4)) },
                {"pos": Vector3(1, 1, 0), "type": MachState.Module.Type.CYLINDER, "color": COLOR.BUILDING, 
                    "basis": Basis.from_scale(Vector3(0.4,0.2,0.4)) },
                {"pos": Vector3(0, 1.025, 1), "type": MachState.Module.Type.TORUS, "color": COLOR.ENERGY, 
                    "basis": Basis.from_scale(Vector3(0.4,0.4,0.4)) },
                ]
        Type.Sphere: 
            return [
                {"pos": Vector3(0, 1, 0), "type": MachState.Module.Type.CYLINDER, "color": COLOR.BUILDING, 
                    "basis": Basis.from_scale(Vector3(0.4,0.2,0.4)) },
                {"pos": Vector3(1, 1, 0), "type": MachState.Module.Type.SPHERE, "color": COLOR.BUILDING, 
                    "basis": Basis.from_scale(Vector3(0.4,0.2,0.4)) },
                {"pos": Vector3(0, 1.025, 1), "type": MachState.Module.Type.TORUS, "color": COLOR.ENERGY, 
                    "basis": Basis.from_scale(Vector3(0.4,0.4,0.4)) },
                ]
        Type.Counter:
            return [
                #{"pos": Vector3(0, 0.5, 0), "type": MachState.Module.Type.BOX, "color": COLOR.BUILDING},
                {"pos": Vector3(0, 1.5, 0), "type": MachState.Module.Type.CUBE, "color": COLOR.BUILDING,
                    "basis": Basis.from_scale(Vector3(0.4,0.2,0.4)) },
                ]
    return []
    
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
