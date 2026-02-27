class_name TrackState
extends Node3D

enum MeshIdx {
    ES_W, 
    NES_W, 
    NE_W,  
    NS_W,  
    SW_NE, 
    WE_NS, 
    W_E, 
    W_ES, 
    W_N,  
    W_NE, 
    W_NES,
    W_NS, 
    W_S,  
    }

var typeMap = {
 0b0001_0100: [MeshIdx.W_E,   0],
 0b0000_0100: [MeshIdx.W_E,   0],
 0b0001_0000: [MeshIdx.W_E,   0],
 0b1000_0100: [MeshIdx.W_N,   0],
 0b0010_0100: [MeshIdx.W_S,   0],
 0b0011_0100: [MeshIdx.W_ES,  0],
 0b1001_0100: [MeshIdx.W_NE,  0],
 0b1010_0100: [MeshIdx.W_NS,  0],
 0b0100_0011: [MeshIdx.ES_W,  0],
 0b0100_1001: [MeshIdx.NE_W,  0],
 0b0100_1010: [MeshIdx.NS_W,  0],
 0b1011_0100: [MeshIdx.W_NES, 0],
 0b0100_1011: [MeshIdx.NES_W, 0],
 0b1001_0110: [MeshIdx.SW_NE, 0],
 0b1010_0101: [MeshIdx.WE_NS, 0],

 0b0010_1000: [MeshIdx.W_E,   1],
 0b0000_1000: [MeshIdx.W_E,   1],
 0b0010_0000: [MeshIdx.W_E,   1],
 0b0001_1000: [MeshIdx.W_N,   1],
 0b0100_1000: [MeshIdx.W_S,   1],
 0b0110_1000: [MeshIdx.W_ES,  1],
 0b0011_1000: [MeshIdx.W_NE,  1],
 0b0101_1000: [MeshIdx.W_NS,  1],
 0b1000_0110: [MeshIdx.ES_W,  1],
 0b1000_0011: [MeshIdx.NE_W,  1],
 0b1000_0101: [MeshIdx.NS_W,  1],
 0b0111_1000: [MeshIdx.W_NES, 1],
 0b1000_0111: [MeshIdx.NES_W, 1],
 0b0011_1100: [MeshIdx.SW_NE, 1],
 0b0101_1010: [MeshIdx.WE_NS, 1],

 0b0100_0001: [MeshIdx.W_E,   2],
 0b0000_0001: [MeshIdx.W_E,   2],
 0b0100_0000: [MeshIdx.W_E,   2],
 0b0010_0001: [MeshIdx.W_N,   2],
 0b1000_0001: [MeshIdx.W_S,   2],
 0b1100_0001: [MeshIdx.W_ES,  2],
 0b0110_0001: [MeshIdx.W_NE,  2],
 0b1010_0001: [MeshIdx.W_NS,  2],
 0b0001_1100: [MeshIdx.ES_W,  2],
 0b0001_0110: [MeshIdx.NE_W,  2],
 0b0001_1010: [MeshIdx.NS_W,  2],
 0b1110_0001: [MeshIdx.W_NES, 2],
 0b0001_1110: [MeshIdx.NES_W, 2],
 0b0110_1001: [MeshIdx.SW_NE, 2],

 0b1000_0010: [MeshIdx.W_E,   3],
 0b0000_0010: [MeshIdx.W_E,   3],
 0b1000_0000: [MeshIdx.W_E,   3],
 0b0100_0010: [MeshIdx.W_N,   3],
 0b0001_0010: [MeshIdx.W_S,   3],
 0b1001_0010: [MeshIdx.W_ES,  3],
 0b1100_0010: [MeshIdx.W_NE,  3],
 0b0101_0010: [MeshIdx.W_NS,  3],
 0b0010_1001: [MeshIdx.ES_W,  3],
 0b0010_1100: [MeshIdx.NE_W,  3],
 0b0010_0101: [MeshIdx.NS_W,  3],
 0b1101_0010: [MeshIdx.W_NES, 3],
 0b0010_1101: [MeshIdx.NES_W, 3],
 0b1100_0011: [MeshIdx.SW_NE, 3],
}

class PosMap:
    
    var map : Dictionary[Vector2i, int] = {}
    var ary : Array[Array] = []
    var msh : MultiMeshInstance3D
    var hdl
    
    func add(pos : Vector2i, data : Array):

        if map.has(pos):
            ary[map[pos]] = data
            hdl.aryChange(self, map[pos], data)
        else:
            map[pos] = ary.size()
            ary.push_back(data)
            hdl.aryPush(self, data)
        verify()
            
    func del(pos : Vector2i):
        
        if map.has(pos):
            if map[pos] < ary.size()-1: # swap with last
                var ld = ary[ary.size()-1]
                assert(map[ld[0]] == ary.size()-1)
                ary[map[pos]] = ld 
                map[ld[0]] = map[pos] 
                hdl.aryChange(self, map[pos], ary[map[pos]])
            ary.pop_back()
            map.erase(pos)
            hdl.aryPop(self)
        verify()
            
    func clear():
        
        map = {}
        ary = []
        hdl.aryClear(self)
        verify()
        
    func size():
        
        assert(ary.size() == map.size())
        return ary.size()
        
    func verify():
        
        assert(ary.size() == map.size())
        for pos in map:
            assert(map[pos] >= 0)
            assert(map[pos] < ary.size())
        
var posMap  : Array[PosMap] = []
var metaMap : Dictionary[Vector2i, int] = {}

func _ready():
    
    Post.subscribe(self)
    
    enhanceTypeMap()
    
    setBeltColors()
    
    for child in get_children():
        child.multimesh.instance_count = 10000
        child.multimesh.visible_instance_count = 0
        var pm = PosMap.new()
        pm.msh = child
        pm.hdl = self
        posMap.push_back(pm) 
        
func enhanceTypeMap():
    
    for type in typeMap:
        var outRing = []
        var inRing  = []
        for dir in Belt.DIRS:
            if type & Belt.OUTPUT[dir]:
                outRing.push_back(dir)
            if type & Belt.INPUT[dir]:
                inRing.push_back(dir)
        if outRing.is_empty():
            outRing.push_back(Belt.dirForSinkType(type)) 
        typeMap[type].push_back(inRing)
        typeMap[type].push_back(outRing)

func type2pmi(type:int): 
    if typeMap.has(type):
        return typeMap[type][0]
    Log.warn("invalid type", Belt.stringForType(type))
    return 0

func add(pos : Vector2i, type : int, outIndex : int = 0, inQueue : Array = []):
    
    del(pos)
    var pmi = type2pmi(type)
    posMap[pmi].add(pos, [pos, type, outIndex, inQueue])
    metaMap[pos] = pmi
    
func del(pos):
    
    for pm in posMap:
        pm.del(pos)
    metaMap.erase(pos)
    
func clear():
    
    for pm in posMap:
        pm.clear()
    metaMap.clear()
        
func size():
    
    return metaMap.size()
    #var s = 0
    #for pm in posMap:
        #s += pm.size()
    #return s
    
func dataAtPos(pos : Vector2i) -> Array:
    
    if metaMap.has(pos):
        var pm = posMap[metaMap[pos]]
        return pm.ary[pm.map[pos]]
    #for pm in posMap:
        #if pm.map.has(pos): 
            ##assert(pm.map[pos] >= 0)
            ##assert(pm.map[pos] < pm.ary.size())
            #return pm.ary[pm.map[pos]]   
    return []
    
func dataAtIndex(index : int) -> Array:
    
    if index < 0: return []
    for pm in posMap:
        if index < pm.size(): return pm.ary[index]
        index -= pm.size()
        if index < 0:
            Log.warn("invalid index")
            break
    return []
    
func aryChange(pm : PosMap, index : int, data : Array): 
    
    if index < 0: 
        Log.warn("invalid index", index, data, pm.msh.multimesh.instance_count)
    var t = data[1]
    if not typeMap.has(t): 
        Log.warn("invalid belt type", t, Belt.stringForType(t))
        return
    var trans = Transform3D.IDENTITY
    if typeMap[t][1]:
        trans = trans.rotated(Vector3.UP, deg_to_rad(-90*typeMap[t][1]))
    trans = trans.translated(Vector3(data[0].x, Belt.GLOBAL_Y, data[0].y))
    pm.msh.multimesh.set_instance_transform(index, trans)

func aryPush(pm : PosMap, data : Array):          

    pm.msh.multimesh.visible_instance_count += 1
    aryChange(pm, pm.msh.multimesh.visible_instance_count-1, data)
    
func aryPop(pm : PosMap):               

    pm.msh.multimesh.visible_instance_count -= 1

func aryClear(pm : PosMap):             

    for child in get_children():
        child.multimesh.visible_instance_count = 0
        
func setBeltColors():        setColors(Color(0.15, 0.15, 0.15), Color(0.75, 0.75, 3.0))
func setBeltBuilderColors(): setColors(Color(0.368, 0.38, 1.0, 1.0), Color(0.238, 0.238, 0.61, 1.0))
func setRectSelectColors():  setColors(Color(0.829, 0.829, 0.829, 1.0), Color(0.461, 0.461, 0.461, 1.0))
        
func setColors(rimColor, spokeColor):
    
    for child in get_children():
        child.multimesh.mesh.material.set_shader_parameter("RimColor", rimColor)
        child.multimesh.mesh.material.set_shader_parameter("SpokeColor", spokeColor)
        
func gamePaused():
    gameSpeed(0)
    
func gameResume():
    gameSpeed(Utils.fabState().gameSpeed)
        
func gameSpeed(speed):
    
    for child in get_children():
        child.multimesh.mesh.material.set_shader_parameter("Speed", speed)
