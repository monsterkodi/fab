class_name ItemMultiMesh
extends Node3D

var dict = {"item": []}

func _ready():
    
    #Post.subscribe(self)
    pass
        
func add(typ:String, node):

    dict[typ].append(node)
    
func del(typ:String, node):
    
    dict[typ].erase(node)
    
func clear(typ:String):
    
    dict[typ].clear()

func _process(delta:float):
    
    drawItems()
    
func drawItems():
    
    var items = dict.item
    $Item.multimesh.instance_count = items.size()  
    for i in range(items.size()):
        var trans = Transform3D.IDENTITY
        trans = trans.scaled(Vector3(items[i][2],items[i][2],items[i][2]))
        trans.origin = items[i][0]
        trans.origin.y += Belt.HALFSIZE + Belt.GLOBAL_Y
        
        $Item.multimesh.set_instance_color(i, items[i][1])
        $Item.multimesh.set_instance_transform(i, trans)
    
        
