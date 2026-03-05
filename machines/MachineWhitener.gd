class_name MachineWhitener
extends Machine

var consumedEnergy = 0
var consumedItem = -1

var whiteningEnergy = {
    Item.Type.CubeBlack: 0.4,
    Item.Type.CubeRed:   0.2,
    Item.Type.CubeGreen: 0.2,
    Item.Type.CubeBlue:  0.2,
    Item.Type.CubeWhite: 0.0,
}

func _init(p, o):
    
    type  = Mach.Type.Whitener
    slits = Mach.slitsForType(type)
    slots = Mach.slotsForType(type)
     
    super._init(p, o) 
    
func consumeItemAtSlit(item, slit): 
    
    if slit.has("shape") and slit.shape == Item.Shape.Cube:
        if consumedItem >= 0: return false
        if item.shape != Item.Shape.Cube: return false
        consumedItem = item.type
        return true
    else:
        if consumedEnergy >= 1.0: return false
        if item.type != Item.Type.TorusYellow: return false
        consumedEnergy += 1 # Item.energyForType(item.type)
        return true
    
func produceItemAtSlot(slot):
    
    if consumedItem < 0: return false
    if consumedEnergy < whiteningEnergy[consumedItem]: return false
    consumedEnergy -= whiteningEnergy[consumedItem]
    consumedItem = -1
    return Item.Inst.new(slot.item)
