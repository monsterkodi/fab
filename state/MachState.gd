class_name MachState
extends Node3D

class Module:
    
    enum Type { BOX, ARROW, CUBE, TORUS, SPHERE, CYLINDER, CYLINDER_CHAMFER }
    
    var trans : Transform3D
    var color : Color
    var type  : int
    var index : int = -1
    
class Building:
    
    var modules : Array[Module]
    var basis   : Basis
    var type    : Mach.Type
    var pos     : Vector2i
    
    func _init(t : Mach.Type, p : Vector2i, b : Basis):
        
        basis = b
        type = t
        pos = p
        
        var module
        
        for slit in Mach.slitsForType(type):
            module = Module.new()
            module.color = Color.WHITE
            module.type  = Module.Type.BOX
            modules.push_back(module)
            
            module = Module.new()

            module.color = Color(8.0, 0.0, 0.0)
            module.type  = Module.Type.ARROW
            modules.push_back(module)
            
        for slot in Mach.slotsForType(type):
            module = Module.new()
            module.color = Color.WHITE
            module.type  = Module.Type.BOX
            modules.push_back(module)

            module = Module.new()

            module.color = Color(0.485, 0.485, 1.825)
            module.type  = Module.Type.ARROW
            modules.push_back(module)
            
        for deco in Mach.decosForType(type):
            if deco.has("type"):
                module = Module.new()
                module.color = deco.color
                module.type  = deco.type
                if deco.has("basis"):
                    module.trans = Transform3D(deco.basis, Vector3.ZERO)
                modules.push_back(module)
            
        update()
        
    func update():
        
        var i = 0
        for slit in Mach.slitsForType(type):
            var p = basis * Vector3(slit.pos.x, 0, slit.pos.y)
            modules[i].trans = Mach.boxTrans(slit, p + Vector3(pos.x, 0.5, pos.y), basis)
            i += 1
            modules[i].trans = Mach.slitArrowTrans(slit, p + Vector3(pos.x, 0.0, pos.y), basis)
            i += 1

        for slot in Mach.slotsForType(type):
            var p = basis * Vector3(slot.pos.x, 0, slot.pos.y)
            modules[i].trans = Mach.boxTrans(slot, p + Vector3(pos.x, 0.5, pos.y), basis)
            i += 1
            modules[i].trans = Mach.slotArrowTrans(slot, p + Vector3(pos.x, 0.0, pos.y), basis)
            i += 1
            
        for deco in Mach.decosForType(type):
            if deco.has("type"):
                var b = basis
                if deco.has("basis"):
                    b = basis * deco.basis
                modules[i].trans = Transform3D(b, basis * deco.pos + Vector3(pos.x, 0.0, pos.y))
                i += 1
        
    func setPos(p : Vector2i):
        
        pos = p
        update()
                
    func rotate():
        
        basis = basis.rotated(Vector3.UP, deg_to_rad(-90))
        update()
            
class ModMap:
    
    var ary : Array[Module] = []
    var msh : MultiMeshInstance3D
    var hdl
    
    func add(module : Module):

        if module.index >= 0:
            hdl.aryChange(self, module)
        else:
            module.index = ary.size()
            ary.push_back(module)
            assert(msh.multimesh.visible_instance_count == module.index)
            msh.multimesh.visible_instance_count += 1
            hdl.aryChange(self, module)
            
    func del(module : Module):
        
        if module.index >= 0:
            if module.index < ary.size()-1: # swap with last
                var lastModule = ary[-1]
                module.trans = lastModule.trans
                assert(module.type == lastModule.type)
                hdl.aryChange(self, module)
            ary.pop_back()
            msh.multimesh.visible_instance_count -= 1
            
    func clear():
        
        ary = []
        msh.multimesh.visible_instance_count = 0
        
    func size(): return ary.size()
        
var modMap : Array[ModMap] = []

@onready var fab: FabState = $"../FabState"

func _ready():
    
    get_child(0).multimesh.mesh = MachMeshes.regal(1.0, 1.0, 1.0, 0.2, 0.5)
    get_child(1).multimesh.mesh = MachMeshes.arrow(0.6, 0.2, 0.33)
    
    for child in get_children():
        child.multimesh.instance_count = 1000
        child.multimesh.visible_instance_count = 0
        var mm = ModMap.new()
        mm.msh = child
        mm.hdl = self
        modMap.push_back(mm) 
        
func add(building : Building):
    
    for module in building.modules:
        modMap[module.type].add(module)
    
func del(building : Building):
    
    for module in building.modules:
        modMap[module.type].del(module)
    
func clear():
    
    for mm in modMap:
        mm.clear()
            
func aryChange(mm : ModMap, module : Module): 
    
    mm.msh.multimesh.set_instance_color(module.index, module.color)
    mm.msh.multimesh.set_instance_transform(module.index, module.trans)
    
func setBuildingPos(building, pos):
    
    building.setPos(pos)
    add(building)
    
func rotateBuilding(building):
    
    building.rotate()
    add(building)
