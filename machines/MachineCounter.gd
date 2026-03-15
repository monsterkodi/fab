class_name MachineCounter
extends Machine

var gauge : Gauge
var lastAdvance = 0

func _init(p, o):
    
    super._init(Mach.Type.Counter, p, o)

func _ready():
    
    gauge = Gauge.new()
    gauge.color = COLOR.COUNTER
    Utils.level(self).add_child(gauge)
    gauge.radius = 0.3
    gauge.basis = Basis.from_euler(Vector3(0, -deg_to_rad(orientation*90), 0))
    gauge.global_position = Vector3(pos.x, 1.01, pos.y)
    
    super._ready()
    
func _exit_tree():
    
    gauge.queue_free()
    super._exit_tree()
    
func consume(delta):
    
    gauge.update(delta)
    
    var items = fab.itemsAtPos(pos)
    var maxAdv = 0
    for item in items:
        maxAdv = maxf(item.advance, maxAdv)
    if maxAdv < lastAdvance:
        gauge.increment()
    lastAdvance = maxAdv
    
    return false
    
