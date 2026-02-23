class_name MachinePrism
extends Machine

var canProduce = false

func _init():
    
    type  = Mach.Type.Prism
    
    slots = [
        {"pos": Belt.NEIGHBOR[Belt.E]+Belt.NEIGHBOR[Belt.N], "dir": Belt.E, "color": Color.RED},
        {"pos": Belt.NEIGHBOR[Belt.E],                       "dir": Belt.E, "color": Color.GREEN},
        {"pos": Belt.NEIGHBOR[Belt.E]+Belt.NEIGHBOR[Belt.S], "dir": Belt.E, "color": Color.BLUE},
        ]
        
    slits = [
        {"pos": Vector2.ZERO, "dir": Belt.W},
    ]
    
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
    item.color = slot.color
    if slot == slots[-1]: canProduce = false
    return item
        
func getOccupied() -> Array[Vector2i]:
    
    var posl = super.getOccupied()
    
    posl.append(pos + slots[0].pos + slits[0].pos)
    posl.append(pos + slots[2].pos + slits[0].pos)
    
    return posl
