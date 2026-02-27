class_name ItemState
extends Node3D

class Item:
    var pos : Vector2i
    var dir = 0
    var type    = 0
    var advance = 0.0
    var color   = Color.RED
    var scale   = 0.0
    var mvd     = false
    var blckd   = 0
    var skip    = 0
    func dpos(): return Vector3i(pos.x, pos.y, dir)

class ItemMap:
    
    var map : Dictionary[Vector3i, int] = {}
    var ary : Array[Item] = []
    var msh : MultiMeshInstance3D
    var hdl
    
    func add(dpos : Vector3i, item : Item):

        if map.has(dpos):
            ary[map[dpos]] = item
            hdl.aryChange(self, map[dpos], item)
        else:
            map[dpos] = ary.size()
            ary.push_back(item)
            hdl.aryPush(self, item)
        verify()
            
    func del(dpos : Vector3i):
        
        if map.has(dpos):
            if map[dpos] < ary.size()-1: # swap with last
                var lastItem = ary[-1]
                assert(map[lastItem.dpos()] == ary.size()-1)
                ary[map[dpos]] = lastItem
                map[lastItem.dpos()] = map[dpos] 
                hdl.aryChange(self, map[dpos], ary[map[dpos]])
            ary.pop_back()
            map.erase(dpos)
            hdl.aryPop(self)
        verify()
            
    func clear():
        
        map = {}
        ary = []
        hdl.aryClear(self)
        verify()
        
    func size():
        
        return ary.size()
        
    func verify(): pass
        
        #assert(ary.size() == map.size())
        #for pos in map:
            #assert(map[pos] >= 0)
            #assert(map[pos] < ary.size())
        
var itemMap : Array[ItemMap] = []

@onready var fab: FabState = $"../FabState"

func _ready():
    
    Post.subscribe(self)
    
    for child in get_children():
        child.multimesh.instance_count = 10000
        child.multimesh.visible_instance_count = 0
        var pm = ItemMap.new()
        pm.msh = child
        pm.hdl = self
        itemMap.push_back(pm) 
        
func add(dpos : Vector3i, item : Item):
    
    del(dpos)
    itemMap[item.type].add(dpos, item)
    
func del(dpos : Vector3i):
    
    for imap in itemMap:
        imap.del(dpos)
    
func clear():
    
    for pm in itemMap:
        pm.clear()
        
func size():
    
    var s = 0
    for pm in itemMap:
        s += pm.size()
    return s
    
func itemAtIndex(index : int) -> Item:
    
    if index < 0: return null
    for imap in itemMap:
        if index < imap.size(): return imap.ary[index]
        index -= imap.size()
        if index < 0:
            Log.warn("invalid index")
            break
    return null
    
func itemsAtPos(pos : Vector2i) -> Array:
    
    var items = []
    for pm in itemMap:
        for d in Belt.DIRS:
            var dpos = Vector3i(pos.x, pos.y, d)
            if pm.map.has(dpos):
                items.push_back(pm.ary[pm.map[dpos]])
    return items
    
func aryChange(pm : ItemMap, index : int, item : Item): 
    
    if index < 0: 
        Log.warn("invalid index", index, item, pm.msh.multimesh.instance_count)

    pm.msh.multimesh.set_instance_color(index, item.color)
    pm.msh.multimesh.set_instance_transform(index, itemTrans(item))
    
func itemTrans(item):
    
    var trans = Transform3D.IDENTITY
    trans = trans.scaled(Vector3(item.scale, item.scale, item.scale))
    var offset = Belt.offsetForAdvanceAndDir(fab.beltAtPos(item.pos), item.advance, item.dir)
    trans.origin = Vector3(item.pos.x, Belt.GLOBAL_Y + Belt.HALFSIZE, item.pos.y) + offset
    return trans
    
func updateItemTrans(pm : ItemMap, index : int, item : Item):
    
    pm.msh.multimesh.set_instance_transform(index, itemTrans(item))    

func aryPush(pm : ItemMap, item : Item):          

    pm.msh.multimesh.visible_instance_count += 1
    aryChange(pm, pm.msh.multimesh.visible_instance_count-1, item)
    
func aryPop(pm : ItemMap):               

    pm.msh.multimesh.visible_instance_count -= 1

func aryClear(pm : ItemMap):             

    for child in get_children():
        child.multimesh.visible_instance_count = 0
        
func advanceItems(delta):
      
    var advance = delta * 0.5
    
    for imap in itemMap:
        for item in imap.ary:
            if item.advance + advance >= 1:
                var outPos = item.pos + Belt.NEIGHBOR[item.dir] 
                var bt = fab.beltAtPos(outPos)
                if bt:
                    var inDir = Belt.OPPOSITE[item.dir]
                    if bt & Belt.INPUT[inDir]:
                        var adv = fab.inSpace(outPos, inDir, (item.advance + advance) - 1)
                        if adv >= 0:
                            del(item.dpos())
                            item.advance = adv
                            item.dir = inDir
                            item.pos = outPos
                            item.mvd = true
                            add(item.dpos(), item)
    
    for imap in itemMap:
        for idx in range(imap.ary.size()):
            var item = imap.ary[idx]
            if item.mvd: 
                item.mvd = false 
                continue
            if item.skip:
                item.skip -= 1
                continue
            var oadv = item.advance
            var type = fab.beltAtPos(item.pos)
            if item.advance < 0.5 and item.advance + advance >= 0.5:
                var space = 0
                var outRing = fab.tst.typeMap[type][3]
                var outNum = outRing.size()
                var bd = fab.tst.dataAtPos(item.pos)
                for index in range(outNum):
                                    
                    var ringIndex = (bd[2] + index) % outNum
                    var dir = outRing[ringIndex]
                    space = fab.outSpace(item.pos, dir, item.advance + advance)
                    
                    if space >= 0.5:
                        var opos = item.dpos()
                        item.advance = space
                        item.dir = dir
                        bd[2] = (ringIndex + 1) % outNum
                        imap.map.erase(opos)
                        imap.map[item.dpos()] = idx
                        break
                if space < 0.5:
                    item.advance = 0.49999
            else:
                item.advance = minf(item.advance + advance, 1.0)

            if item.advance > 0.5 and Belt.isSinkType(type):
                item.scale = 1.0 - 2 * (item.advance-0.5)
            elif item.advance <= 0.5 and Belt.isSourceType(type):
                item.scale = item.advance*2
            else:
                item.scale = 1.0
            if item.advance != oadv:
                if item.blckd:
                    item.skip = 0
                    item.blckd = 0
                    item.scale = 1.0
                updateItemTrans(imap, idx, item)
            else:
                if not item.blckd:
                    item.skip = 0
                    item.blckd = 1
                    item.scale = 1.2
                    updateItemTrans(imap, idx, item)
                else:
                    item.blckd += 1
                    if item.blckd > 20:
                        item.skip = mini(item.blckd / 10, 20)
