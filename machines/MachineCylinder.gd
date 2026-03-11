class_name MachineCylinder
extends Machine

var consumedEnergy = 0
var consumedItem = -1

var roundeningEnergy = {
    Item.Type.CubeBlack: Item.cylinderCost(Item.Type.CubeBlack ),
    Item.Type.CubeRed:   Item.cylinderCost(Item.Type.CubeRed   ),
    Item.Type.CubeGreen: Item.cylinderCost(Item.Type.CubeGreen ),
    Item.Type.CubeBlue:  Item.cylinderCost(Item.Type.CubeBlue  ),
    Item.Type.CubeWhite: Item.cylinderCost(Item.Type.CubeWhite ),
}

func _init(p, o):
    
    super._init(Mach.Type.Cylinder, p, o)
    
func consumeItemAtSlit(item, slit): 
    
    if slit.has("shape") and slit.shape == Item.Shape.Cube:
        if consumedItem >= 0: return false
        if item.shape != Item.Shape.Cube: return false
        consumedItem = item.type
        return true
    else:
        if consumedEnergy >= 4.0: return false
        if item.type != Item.Type.Energy: return false
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
