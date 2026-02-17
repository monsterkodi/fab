extends Node

enum {E ,S, W, N}
const DIRS    = [E, S, W, N]
const DIRNAME = ["E", "S", "W", "N"]
const NEIGHBOR = [Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0), Vector2i(0,-1)]
const I_E     = 1 << E
const I_S     = 1 << S
const I_W     = 1 << W
const I_N     = 1 << N
const O_E     = I_E << 4
const O_S     = I_S << 4
const O_W     = I_W << 4
const O_N     = I_N << 4
const INPUT  = [I_E, I_S, I_W, I_N]
const OUTPUT = [O_E, O_S, O_W, O_N]

func stringForType(type):
    
    var s = "[" + String.num_int64(type) + " " + String.num_int64(type, 2).pad_zeros(8) + " "
    for d in DIRS:
        if type & INPUT[d]:
            s += DIRNAME[d]
    s += "_"
    for d in DIRS:
        if type & OUTPUT[d]:
            s += DIRNAME[d]
    s += "]" 
    if isInvalidType(type):
        s += " " + isInvalidType(type)
    return s    
    
func isInvalidType(type):
    var s = ""
    if not type & 0b1111:
        s += "no input "
    if not type & 0b1111_0000:
        s += "no output "
    if (type & 0b1111) & ((type >> 4) & 0b1111):
        s+= "input/output overlap!"
    return s
    
func fixOutput(type):
    if not type & 0b1111_0000:
        return type | ((type & 0b0011) << 6) | ((type & 0b1100) << 2) 
    return type
        
