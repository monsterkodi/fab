class_name MachState
extends Node3D

class Module:
    
    enum Type { BOX, ARROW }
    
    var pos   : Vector3
    var basis : Basis = Basis.IDENTITY
    var color : Color
    var type  : int
    var index : int = -1
    
class Building:
    
    var modules : Array[Module]
    
    func _init(type : Mach.Type, pos : Vector2i, basis : Basis):
        
        for slit in Mach.slitsForType(type):
            var module = Module.new()
            var p = pos + slit.pos
            module.pos   = Vector3(p.x, 0.5, p.y)
            module.basis = basis
            module.color = Color.WHITE
            module.type  = Module.Type.BOX
            modules.push_back(module)
            
            module = Module.new()
            module.pos   = Vector3(p.x, 1.0, p.y)
            module.basis = basis
            module.color = Color.RED
            module.type  = Module.Type.ARROW
            modules.push_back(module)

        for slot in Mach.slotsForType(type):
            var module = Module.new()
            var p = pos + slot.pos
            module.pos   = Vector3(p.x, 0.5, p.y)
            module.basis = basis
            module.color = Color.WHITE
            module.type  = Module.Type.BOX
            modules.push_back(module)

            module = Module.new()
            module.pos   = Vector3(p.x, 1.0, p.y)
            module.basis = basis
            module.color = Color.BLUE
            module.type  = Module.Type.ARROW
            modules.push_back(module)

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
                module.pos = lastModule.pos
                module.basis = lastModule.basis
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
    mm.msh.multimesh.set_instance_transform(module.index, Transform3D(module.basis, module.pos))
