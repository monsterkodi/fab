extends Node
# singleton Mach

enum Type {
    Invalid,
    Root,
    Prism,
    Storage,
}

var Class = [
    null, 
    MachineRoot,
    MachinePrism,
    MachineStorage,
]

func stringForType(type):
    
    match type:
            Type.Root:    return "Root"
            Type.Prism:   return "Prism"
            Type.Storage: return "Storage"
            _:            return "Invalid"
    
func typeForString(string):
    
    match string:
        "Root":    return Type.Root
        "Prism":   return Type.Prism
        "Storage": return Type.Storage
        _:         return Type.Invalid

func buildingNameForType(type): return "Building" + stringForType(type)
    
func slotsForType(type):
    
    match type:
        Type.Prism: 
            return [
                {"pos": Belt.NEIGHBOR[Belt.E]+Belt.NEIGHBOR[Belt.N], "dir": Belt.E, "color": Color.RED},
                {"pos": Belt.NEIGHBOR[Belt.E],                       "dir": Belt.E, "color": Color.GREEN},
                {"pos": Belt.NEIGHBOR[Belt.E]+Belt.NEIGHBOR[Belt.S], "dir": Belt.E, "color": Color.BLUE},
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
                {"pos": Vector2i.ZERO, "dir": Belt.W},
            ]
        Type.Storage: 
            return [
                {"pos": Vector2i(0,0), "dir": Belt.W},
            ]
            
    return []
