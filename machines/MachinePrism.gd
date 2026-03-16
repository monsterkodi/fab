class_name MachinePrism
extends Machine

var canProduce = false

func _init(p, o):
    
    super._init(Mach.Type.Prism, p, o)
    
func saveData(): return super.saveData() + [canProduce]
func loadData(d): 
    canProduce = d[4]
    
func consumeItemAtSlit(item, slit):
    
    if canProduce: return false
    
    for i in range(slots.size()):
        if advanceAtSlotIndex(i) < 0:
            return false
    
    canProduce = true
    return true
    
func produceItemAtSlot(slot):
    
    if not canProduce: return null
    
    var item = Item.Inst.new(slot.item)
    if slot == slots[-1]: canProduce = false
    return item
        
