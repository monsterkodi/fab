class_name Gauge
extends MeshInstance3D

var deltaSum = 0.0
var itemCount = 0
var history = []
var lastAdvance = 0
var factor = 0.0
var radius = 0.35
var color = COLOR.GAUGE

func _ready():
    
    mesh = PlaneMesh.new()
    mesh.size = Vector2(radius*2, radius*2)
    var mat := ShaderMaterial.new()
    mat.shader = preload("uid://dsrnsm8kv3jeg")
    mat.set_shader_parameter("EndAngle", 0.0)
    mat.set_shader_parameter("Color", color)
    material_override = mat
    #Utils.level(self).add_child(self)
    #rotate_object_local(Vector3.UP, deg_to_rad(-90 * orientation))

func setFactor(f):
    
    factor = clampf(f, 0.0, 1.0)
    if material_override:
        material_override.set_shader_parameter("StartAngle", 90-360.0*factor*0.5)
        material_override.set_shader_parameter("EndAngle", 90+360.0*factor*0.5)

func update(delta : float):
    
    deltaSum += delta
    
    if deltaSum > 1.0:
        
        history.push_back(itemCount)
        if history.size() > 2:
            if history.size() > 60:
                history.pop_front()
            
            var itemSum = 0
            for h in history:
                itemSum += h
                
            setFactor(1.05 * itemSum / history.size())
            
        deltaSum  = 0
        itemCount = 0

func increment():
    
    itemCount += 1
