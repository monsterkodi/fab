class_name MachineRounder
extends Machine

var consumedEnergy = 0
var consumedItem = -1

var roundeningEnergy = {
    Item.Type.CubeBlack: 1.0,
    Item.Type.CubeRed:   2.0,
    Item.Type.CubeGreen: 2.0,
    Item.Type.CubeBlue:  2.0,
    Item.Type.CubeWhite: 4.0,
}

func _init(p, o):
    
    super._init(Mach.Type.Rounder, p, o)
    
func consumeItemAtSlit(item, slit): 
    
    if slit.has("shape") and slit.shape == Item.Shape.Cube:
        if consumedItem >= 0: return false
        if item.shape != Item.Shape.Cube: return false
        consumedItem = item.type
        return true
    else:
        if consumedEnergy >= 4.0: return false
        if item.type != Item.Type.TorusYellow: return false
        consumedEnergy += 1
        return true
    
func produceItemAtSlot(slot):
    
    if consumedItem < 0: return false
    if consumedEnergy < roundeningEnergy[consumedItem]: return false
    consumedEnergy -= roundeningEnergy[consumedItem]
    var t
    match consumedItem:
        Item.Type.CubeBlack: t = Item.Type.CylinderBlack
        Item.Type.CubeRed:   t = Item.Type.CylinderRed
        Item.Type.CubeGreen: t = Item.Type.CylinderGreen
        Item.Type.CubeBlue:  t = Item.Type.CylinderBlue
        Item.Type.CubeWhite: t = Item.Type.CylinderWhite
    consumedItem = -1
    return Item.Inst.new(t)
