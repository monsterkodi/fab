extends Node
# singleton Mach

enum Type {
    Belt,
    Root,
    Storage,
    Prism,
    Mixer,
    Burner,
    Whitener,
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
    MachineRoot,
    MachineStorage,
    MachinePrism,
    MachineMixer,
    MachineBurner,
    MachineWhitener,
]

func costForType(type):

    match type:
            Type.Root:      return {Item.Type.CubeRed: 1000, Item.Type.CubeGreen: 1000, Item.Type.CubeBlue: 1000}
            Type.Storage:   return {Item.Type.CubeBlack: 10}
            Type.Prism:     return {Item.Type.CubeBlack: 30}
            Type.Burner:    return {Item.Type.CubeRed:   10, Item.Type.CubeGreen: 10, Item.Type.CubeBlue: 10}
            Type.Mixer:     return {Item.Type.CubeRed:   20, Item.Type.CubeGreen: 20, Item.Type.CubeBlue: 20}
            Type.Whitener:  return {Item.Type.CubeWhite: 10}
            _:              return {Item.Type.CubeBlack: 1}

func stringForType(type):   return TypeNames[type]
func typeForString(string): return TypeMap[string]
    
func buildingNameForType(type): return "Building" + stringForType(type)

func slitsForType(type):        
    
    match type:
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
            
    return []
    
func slotsForType(type):
    
    match type:
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
    return []
