class_name MachineStorage
extends Machine

var gauge : Gauge

func _init(p, o):
    
    super._init(Mach.Type.Storage, p, o) 
    
func _ready():
    
    gauge = Gauge.new()
    Utils.level(self).add_child(gauge)
    gauge.radius = 0.3
    gauge.basis = Basis.from_euler(Vector3(0, -deg_to_rad(orientation*90), 0))
    gauge.global_position = Vector3(pos.x, 2.01, pos.y)
    super._ready()
    
func _exit_tree():
    
    gauge.free()
    super._exit_tree()
    
func consume(delta:float):
    
    gauge.update(delta)
    super.consume(delta)    
    
func consumeItemAtSlit(item, slit): 
    
    gauge.increment()
    fab.storage.addItem(item.type)
    return true
    
