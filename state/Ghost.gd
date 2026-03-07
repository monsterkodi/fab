class_name Ghost
extends Machine

var proxy : Machine

func _ready():

    assert(type)
    slits = Mach.slitsForType(type)
    slots = Mach.slotsForType(type)
    
    if proxy:
        building = proxy.building
    else:
        fab = Utils.fabState()
        createBuilding()
    
func _exit_tree():
    
    if proxy:
        Utils.clearOverrideMaterial(building)
    else:
        if building:
            building.queue_free()
      
