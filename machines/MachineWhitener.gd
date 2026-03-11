class_name MachineWhitener
extends Machine

var consumedEnergy = 0
var consumedItem = -1

var whiteningEnergy = {
    Item.Type.CubeBlack: Item.whiteningCost(Item.Type.CubeBlack ),
    Item.Type.CubeRed:   Item.whiteningCost(Item.Type.CubeRed   ),
    Item.Type.CubeGreen: Item.whiteningCost(Item.Type.CubeGreen ),
    Item.Type.CubeBlue:  Item.whiteningCost(Item.Type.CubeBlue  ),
    Item.Type.CubeWhite: Item.whiteningCost(Item.Type.CubeWhite ),
}

func _init(p, o):
    
    super._init(Mach.Type.Whitener, p, o) 
    
func consumeItemAtSlit(item, slit): 
    
    if slit.has("shape") and slit.shape == Item.Shape.Cube:
        if consumedItem >= 0: return false
        if item.shape != Item.Shape.Cube: return false
        consumedItem = item.type
        return true
    else:
        if consumedEnergy >= 1.0: return false
        if item.type != Item.Type.Energy: return false
        consumedEnergy += 1 # Item.energyForType(item.type)
        return true
    
func produceItemAtSlot(slot):
    
    if consumedItem < 0: return false
    if consumedEnergy < whiteningEnergy[consumedItem]: return false
    consumedEnergy -= whiteningEnergy[consumedItem]
    consumedItem = -1
    return Item.Inst.new(slot.item)
