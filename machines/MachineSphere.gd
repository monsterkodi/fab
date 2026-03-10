class_name MachineSphere
extends Machine

var consumedEnergy = 0
var consumedItem = -1

var roundeningEnergy = {
    Item.Type.CylinderBlack: Item.sphereCost(Item.Type.CylinderBlack ),
    Item.Type.CylinderRed:   Item.sphereCost(Item.Type.CylinderRed   ),
    Item.Type.CylinderGreen: Item.sphereCost(Item.Type.CylinderGreen ),
    Item.Type.CylinderBlue:  Item.sphereCost(Item.Type.CylinderBlue  ),
    Item.Type.CylinderWhite: Item.sphereCost(Item.Type.CylinderWhite ),
}

func _init(p, o):
    
    super._init(Mach.Type.Sphere, p, o)
    
func consumeItemAtSlit(item, slit): 
    
    if slit.has("shape") and slit.shape == Item.Shape.Cylinder:
        if consumedItem >= 0: return false
        if item.shape != slit.shape: return false
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
        Item.Type.CylinderBlack: t = Item.Type.SphereBlack
        Item.Type.CylinderRed:   t = Item.Type.SphereRed
        Item.Type.CylinderGreen: t = Item.Type.SphereGreen
        Item.Type.CylinderBlue:  t = Item.Type.SphereBlue
        Item.Type.CylinderWhite: t = Item.Type.SphereWhite
    consumedItem = -1
    return Item.Inst.new(t)
