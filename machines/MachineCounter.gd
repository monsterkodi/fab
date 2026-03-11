class_name MachineCounter
extends Machine

var gauge : MeshInstance3D
var deltaSum = 0.0
var itemCount = 0
var history = []
var lastAdvance = 0
var factor = 0.0

func _init(p, o):
    
    super._init(Mach.Type.Counter, p, o)

func _ready():
    
    gauge = MeshInstance3D.new()
    gauge.mesh = PlaneMesh.new()
    gauge.mesh.size = Vector2(0.7, 0.7)
    gauge.position = Vector3(pos.x, 1.01, pos.y)
    var mat := ShaderMaterial.new()
    mat.shader = preload("uid://dsrnsm8kv3jeg")
    mat.set_shader_parameter("EndAngle", 0.0)
    mat.set_shader_parameter("Color", COLOR.GAUGE)
    gauge.material_override = mat
    Utils.level(self).add_child(gauge)
    gauge.rotate_object_local(Vector3.UP, deg_to_rad(-90 * orientation))
    super._ready()
    
func _exit_tree():
    
    gauge.free()
    super._exit_tree()
    
func consume(delta):
    
    deltaSum += delta
    
    if deltaSum > 1.0:
        
        history.push_back(itemCount)
        if history.size() > 2:
            if history.size() > 60:
                history.pop_front()
            
            var itemSum = 0
            for h in history:
                itemSum += h
                
            factor = 1.05 * itemSum / history.size()
            factor = clampf(factor, 0.0, 1.0)
            
            gauge.material_override.set_shader_parameter("StartAngle", 90-360.0*factor*0.5)
            gauge.material_override.set_shader_parameter("EndAngle", 90+360.0*factor*0.5)
            
        #deltaSum -= 1
        deltaSum  = 0
        itemCount = 0
    
    var items = fab.itemsAtPos(pos)
    var maxAdv = 0
    for item in items:
        maxAdv = maxf(item.advance, maxAdv)
    if maxAdv < lastAdvance:
        itemCount += 1
    lastAdvance = maxAdv
    
    return false
    
