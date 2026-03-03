class_name ItemStorage
extends Node

var storage : Dictionary[Item.Type, int]

func _ready():
    
    reset()
    
func addItem(type : Item.Type):
    
    storage[type] += 1
    
func reset():
    
    for type in Item.Types:
        storage[type] = 0

    storage[Item.Type.CubeBlack] = 100
