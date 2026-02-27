extends Node
# singleton Belt

enum {E ,S, W, N}
const GLOBAL_Y     = 0.205 # height above ground, slightly bigger than slot thickness
const HALFSIZE     = 0.251 # half of the maximum distance between items
const FULLSIZE     = HALFSIZE*2
const DIRS         = [E, S, W, N]
const OPPOSITE     = [W, N, E, S]
const DIRNAME      = ["E", "S", "W", "N"]
const NEIGHBOR     = [Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0), Vector2i(0,-1)]
const NORM         = [Vector3(1,0,0), Vector3(0,0,1), Vector3(-1,0,0), Vector3(0,0,-1)]
const I_E          = 1 << E
const I_S          = 1 << S
const I_W          = 1 << W
const I_N          = 1 << N
const O_E          = I_E << 4
const O_S          = I_S << 4
const O_W          = I_W << 4
const O_N          = I_N << 4
const INPUT        = [I_E, I_S, I_W, I_N]
const OUTPUT       = [O_E, O_S, O_W, O_N]
const INPUT_DIR    = [0b0100, 0b1000, 0b0001, 0b0010]
const OUTPUT_DIR   = [0b0100_0000, 0b1000_0000, 0b0001_0000, 0b0010_0000]
const SINK_TYPES   = [I_W, I_N, I_E, I_S]
const SOURCE_TYPES = [O_E, O_S, O_W, O_N]

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
    if type <= 0:
        s += "-zero" 
    if hasOverlap(type):
        s += "input/output overlap!"
    return s
    
func isValidType(type): return not isInvalidType(type)
    
func noInOut(type): return hasNoInput(type) or hasNoOutput(type)
    
func fixInOut(type):

    return fixOutput(fixInput(type))
    
func fixOutput(type):
    
    if hasNoOutput(type):
        for d in DIRS:
            if type & INPUT[d] and not type & INPUT[OPPOSITE[d]]:
                return type | OUTPUT[OPPOSITE[d]]
        for d in DIRS:
            if not type & INPUT[d]:
                return type | OUTPUT[d]
    return type
    
func fixInput(type):
    
    if hasNoInput(type):
        for d in DIRS:
            if type & OUTPUT[d] and not type & OUTPUT[OPPOSITE[d]]:
                return type | INPUT[OPPOSITE[d]]            
        for d in DIRS:
            if not type & OUTPUT[d]:
                return type | INPUT[d]
    return type
    
func setOutput(type, dir):
    
    if dir >= 0:
        return (type | OUTPUT[dir]) & ~INPUT[dir]
    return type
    
func setInput(type, dir):
    
    if dir >= 0:
        return (type | INPUT[dir]) & ~OUTPUT[dir]
    return type
    
func clearInput(type, dir):
    
    if dir >= 0:
        return (type & ~INPUT[dir])
    return type

func clearOutput(type, dir):
    
    if dir >= 0:
        return (type & ~OUTPUT[dir])
    return type
    
func isUnset(type, dir):
    
    return type & (INPUT[dir] | OUTPUT[dir]) == 0
       
func srcConnect(src, tgt, dir):
    
    if tgt:
        if isUnset(src, dir):
            if   tgt & INPUT_DIR[dir]:  src = setOutput(src, dir)
            elif tgt & OUTPUT_DIR[dir]: src = setInput(src, dir)
    
    return src
    
func connectNeighbors(pos : Vector2i, neighbors : Array[int], type : int):
    
    for d in DIRS:
        type = srcConnect(type, neighbors[d], d)
    return type
    
func dirForPositions(src, tgt):
    
    if   src.x < tgt.x: return E
    elif src.y < tgt.y: return S
    elif src.x > tgt.x: return W
    elif src.y > tgt.y: return N
    return -1
    
func singleIn(type):  return INPUT_DIR.has (type & 0b1111)
func singleOut(type): return OUTPUT_DIR.has(type & 0b1111_0000)
    
func isSimple(type):
    
    return singleIn(type) and singleOut(type)
    
func offsetForAdvanceAndDir(type, advance, dir) -> Vector3:
    
    var offset = Vector3.ZERO
    var rad = advance * PI * 0.5
    match type:
        Belt.O_E | Belt.I_S: return Vector3(( 1.0 - cos(rad)) * 0.5, 0, ( 1.0 - sin(rad)) * 0.5) # cw
        Belt.O_S | Belt.I_W: return Vector3((-1.0 + sin(rad)) * 0.5, 0, ( 1.0 - cos(rad)) * 0.5) # cw
        Belt.O_W | Belt.I_N: return Vector3((-1.0 + cos(rad)) * 0.5, 0, (-1.0 + sin(rad)) * 0.5) # cw
        Belt.O_N | Belt.I_E: return Vector3(( 1.0 - sin(rad)) * 0.5, 0, (-1.0 + cos(rad)) * 0.5) # cw
        Belt.O_E | Belt.I_N: return Vector3(( 1.0 - cos(rad)) * 0.5, 0, (-1.0 + sin(rad)) * 0.5) # ccw
        Belt.O_S | Belt.I_E: return Vector3(( 1.0 - sin(rad)) * 0.5, 0, ( 1.0 - cos(rad)) * 0.5) # ccw
        Belt.O_W | Belt.I_S: return Vector3((-1.0 + cos(rad)) * 0.5, 0, ( 1.0 - sin(rad)) * 0.5) # ccw
        Belt.O_N | Belt.I_W: return Vector3((-1.0 + sin(rad)) * 0.5, 0, (-1.0 + cos(rad)) * 0.5) # ccw
    
    if advance <= 0.5:
        return NORM[dir] * (0.5 - advance)
    else:
        return NORM[dir] * (advance - 0.5)
        
func orientatePos(orientation, pos):
    
    return Vector2i(Vector2(pos).rotated(deg_to_rad(90*orientation)).round())
    
func orientateDir(orientation, dir):
    
    return (dir + orientation) % 4
    
func dirForSinkType(type):
    
    match type:
        I_W: return E
        I_E: return W
        I_N: return S
        I_S: return N
    return -1
    
func isSinkType(type):
    
    return type in SINK_TYPES

func isSourceType(type):
    
    return type in SOURCE_TYPES
    
func rotateType(type):
    
    match type:
        I_W | O_E: return I_N | O_S
        I_N | O_S: return I_E | O_W
        I_E | O_W: return I_S | O_N
        I_S | O_N: return I_W | O_E
        _: return type 
        
func orientateType(type, orientation):
    
    for i in range(orientation):
        type = rotateType(type)
    return type       
