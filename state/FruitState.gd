class_name FruitState
extends Node3D

class ItemMap:
    
    var map : Dictionary[Vector2i, int] = {}
    var ary : Array[Item.Inst] = []
    var msh : MultiMeshInstance3D
    var hdl
    
    func add(pos : Vector2i, item : Item.Inst):

        if map.has(pos):
            ary[map[pos]] = item
            hdl.aryChange(self, map[pos], item)
        else:
            map[pos] = ary.size()
            ary.push_back(item)
            hdl.aryPush(self, item)
            
    func del(pos : Vector2i):
        
        if map.has(pos):
            if map[pos] < ary.size()-1: # swap with last
                var lastItem = ary[-1]
                assert(map[lastItem.pos] == ary.size()-1)
                ary[map[pos]] = lastItem
                map[lastItem.pos] = map[pos] 
                hdl.aryChange(self, map[pos], ary[map[pos]])
            ary.pop_back()
            map.erase(pos)
            hdl.aryPop(self)
            
    func clear():
        
        map = {}
        ary = []
        hdl.aryClear(self)
        
    func size():
        
        return ary.size()
        
var itemMap : Array[ItemMap] = []

@onready var fab: FabState = $"../FabState"

func _ready():
    
    for shape in Item.Shape:
        add_child(Item.multiMeshForShape(Item.Shape[shape]))
    
    for child in get_children():
        child.multimesh.instance_count = 10000
        child.multimesh.visible_instance_count = 0
        var pm = ItemMap.new()
        pm.msh = child
        pm.hdl = self
        itemMap.push_back(pm) 
        
func add(pos : Vector2i, item : Item.Inst):
    
    #del(pos)
    itemMap[item.shape].add(pos, item)
    
func del(dpos : Vector2i):
    
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
    
func itemAtIndex(index : int) -> Item.Inst:
    
    if index < 0: return null
    for imap in itemMap:
        if index < imap.size(): return imap.ary[index]
        index -= imap.size()
        if index < 0:
            Log.warn("invalid index")
            break
    return null
    
func itemAtPos(pos : Vector2i) -> Item.Inst:
    
    for pm in itemMap:
        if pm.map.has(pos):
            return pm.ary[pm.map[pos]]
    return null
    
func aryChange(pm : ItemMap, index : int, item : Item.Inst): 
    
    if index < 0: 
        Log.warn("invalid index", index, item, pm.msh.multimesh.instance_count)

    if pm.msh.multimesh.use_colors:
        pm.msh.multimesh.set_instance_color(index, item.color)
    pm.msh.multimesh.set_instance_transform(index, itemTrans(item))
    
func itemTrans(item):
    
    var trans = Transform3D.IDENTITY
    #if item.scale == -1: return trans # hack for positioning icon items
    #if item.type == Item.Type.Molecule:
        #trans = trans.rotated(Vector3.UP, deg_to_rad(45))
    trans = trans.scaled(Vector3(item.scale, item.scale, item.scale))
    #var offset = Belt.offsetForAdvanceAndDir(fab.beltAtPos(item.pos), item.advance, item.dir)
    trans.origin = Vector3(item.pos.x, 1.0, item.pos.y) #+ offset
    return trans
    
func updateItemTrans(pm : ItemMap, index : int, item : Item.Inst):
    
    pm.msh.multimesh.set_instance_transform(index, itemTrans(item))    

func aryPush(pm : ItemMap, item : Item.Inst):          

    pm.msh.multimesh.visible_instance_count += 1
    aryChange(pm, pm.msh.multimesh.visible_instance_count-1, item)
    
func aryPop(pm : ItemMap):               

    pm.msh.multimesh.visible_instance_count -= 1

func aryClear(pm : ItemMap):             

    pm.msh.multimesh.visible_instance_count = 0
        
