extends Node
# singleton Mach

enum Type {
    Belt,
    Root,
    Storage,
    Prism,
    Mixer,
    Burner,
}

var Class = [
    null, 
    MachineRoot,
    MachineStorage,
    MachinePrism,
    MachineMixer,
    MachineBurner,
]

func costForType(type):

    match type:
            Type.Root:    return {Item.Type.CubeRed: 1000, Item.Type.CubeGreen: 1000, Item.Type.CubeBlue: 1000}
            Type.Storage: return {Item.Type.CubeBlack: 10}
            Type.Prism:   return {Item.Type.CubeBlack: 30}
            Type.Mixer:   return {Item.Type.CubeRed:   30, Item.Type.CubeGreen: 30, Item.Type.CubeBlue: 30}
            Type.Burner:  return {Item.Type.CubeBlack: 10} #{Item.Type.CubeRed:   10, Item.Type.CubeGreen: 10, Item.Type.CubeBlue: 10}
            _:            return {Item.Type.CubeBlack: 1}
    

func stringForType(type):
    
    match type:
            Type.Root:    return "Root"
            Type.Storage: return "Storage"
            Type.Prism:   return "Prism"
            Type.Mixer:   return "Mixer"
            Type.Burner:  return "Burner"
            _:            return "Belt"
    
func typeForString(string):
    
    match string:
        "Root":    return Type.Root
        "Storage": return Type.Storage
        "Prism":   return Type.Prism
        "Mixer":   return Type.Mixer
        "Burner":  return Type.Burner
        _:         return Type.Belt

func buildingNameForType(type): return "Building" + stringForType(type)
    
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
    return []

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
            
    return []
