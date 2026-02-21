class_name MachinePrism
extends Machine

var canProduce = false

func _ready():
    
    type  = Mach.Type.Prism
    
    slots = [
        {"pos": Belt.NEIGHBOR[Belt.E], "dir": Belt.E},
        {"pos": Belt.NEIGHBOR[Belt.S], "dir": Belt.S},
        {"pos": Belt.NEIGHBOR[Belt.N], "dir": Belt.N},
        ]
        
    slits = [
        {"pos": Belt.NEIGHBOR[Belt.W], "dir": Belt.W},
    ]
    
    super._ready()
    
func consumeItemAtSlit(item, slit):
    
    if canProduce: return false
    
    for i in range(slots.size()):
        if advanceAtSlotIndex(i) < 0:
            return false
    
    canProduce = true
    return true
    
func produceItemAtSlot(slot):
    
    if not canProduce: return null
    
    
    var item = Item.new()
    match slot.dir:
        Belt.N : item.color = Color.RED; canProduce = false
        Belt.E : item.color = Color.GREEN
        Belt.S : item.color = Color.BLUE
    return item
        
