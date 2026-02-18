extends Node

enum {E ,S, W, N}
const DIRS       = [E, S, W, N]
const OPPOSITE   = [W, N, E, S]
const DIRNAME    = ["E", "S", "W", "N"]
const NEIGHBOR   = [Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0), Vector2i(0,-1)]
const I_E        = 1 << E
const I_S        = 1 << S
const I_W        = 1 << W
const I_N        = 1 << N
const O_E        = I_E << 4
const O_S        = I_S << 4
const O_W        = I_W << 4
const O_N        = I_N << 4
const INPUT      = [I_E, I_S, I_W, I_N]
const OUTPUT     = [O_E, O_S, O_W, O_N]
const INPUT_DIR  = [0b0100, 0b1000, 0b0001, 0b0010]
const OUTPUT_DIR = [0b0100_0000, 0b1000_0000, 0b0001_0000, 0b0010_0000]

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
    
func hasNoInput(type):  return not type & 0b0000_1111
func hasNoOutput(type): return not type & 0b1111_0000
func hasOverlap(type):  return (type & 0b1111) & ((type >> 4) & 0b1111)
    
func isInvalidType(type):
    
    var s = ""
    if hasNoInput(type):
        s += "no input "
    if hasNoOutput(type):
        s += "no output "
    if hasOverlap(type):
        s+= "input/output overlap!"
    return s
    
func fixOutput(type):
    
    if not type & 0b1111_0000:
        return type | ((type & 0b0011) << 6) | ((type & 0b1100) << 2) 
    return type
    
func fixInput(type):
    
    if not type & 0b0000_1111:
        return type | ((type & 0b0011_0000) >> 2) | ((type & 0b1100_0000) >> 6) 
    return type
    
func setOutput(type, dir):
    
    return (type | OUTPUT[dir]) & ~INPUT[dir]
    
func setInput(type, dir):
    
    return (type | INPUT[dir]) & ~OUTPUT[dir]
    
func clearInput(type, dir):
    
    return (type & ~INPUT[dir])

func clearOutput(type, dir):
    
    return (type & ~OUTPUT[dir])
    
func addAnyOutput(type):
    
    if hasNoOutput(type):
        for dir in DIRS:
            if type & INPUT[dir] and not type & INPUT[OPPOSITE[dir]]:
                return setOutput(type, OPPOSITE[dir])
        
        for dir in DIRS:
            if not type & INPUT[dir]:
                return setOutput(type, dir)
    return type
        
