class_name Ghost
extends Machine

func _ready(): 

    assert(type)
    slits = Mach.slitsForType(type)
    slots = Mach.slotsForType(type)
    
    createBuilding()
    
func _exit_tree():
    
    if building:
        building.queue_free()
      
func setPos(p):
    
    pos = p
    building.global_position = Vector3(pos.x, 0, pos.y)
