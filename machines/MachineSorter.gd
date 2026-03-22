class_name MachineSorter
extends Machine

var slotItems = [-1, -1, -1]
var typeMap   = {}
var nextIndex = 0

func _init(p, o):
    
    super._init(Mach.Type.Sorter, p, o)

func saveData(): return super.saveData() + [slotItems, typeMap, nextIndex]
func loadData(d): 
    slotItems = d[4]
    typeMap   = d[5]
    nextIndex = d[6]
    updateBuilding()
    
func slotIndexForItem(item):
    
    if not typeMap.has(item.type):
        typeMap[item.type] = nextIndex
        nextIndex = (nextIndex + 1) % 3
        updateBuilding()
    return typeMap[item.type]
    
func newBuilding():
    
    var b = super.newBuilding()
    var indexHeight = [0.5, 0.5, 0.5]
    for t in typeMap:
        var index    = typeMap[t]
        var module   = Module.Inst.new(pos)
        module.pos   = Mach.posOfSlotAtIndex(Mach.Def[type].mods, index) + Vector3(0,indexHeight[index],0)
        indexHeight[index] += 0.5
        module.kind  = Module.Kind.DECO
        module.type  = Module.typeForItemType(t)
        module.basis = Mach.scaleForItemType(t)
        module.color = Item.colorForType(t)
        b.modules.push_back(module)
    b.update()
    return b
    
func updateBuilding():
    
    if not bdg: return
    createBuilding()

func consumeItemAtSlit(item, slit):
    
    var index = slotIndexForItem(item)
    if slotItems[index] < 0:
        slotItems[index] = item.type
        return true
    return false
    
func produceItemAtSlot(slot):
    
    var index = slots.find(slot)
    if slotItems[index] >= 0:
        var item = Item.Inst.new(slotItems[index])
        slotItems[index] = -1
        return item
    return null
