class_name Buildings
extends Node

var beltPieces: Dictionary[Vector2i, int]
var tempPoints: Dictionary[Vector2i, int]

func updateTemp():
    
    var mm = get_tree().root.get_node("/root/World/Level/MultiMesh")
    mm.clear("temp")
    for pos in tempPoints:
        mm.add("temp", Vector3i(pos.x, pos.y, tempPoints[pos]))
        
func updateBelt():
        
    var mm = get_tree().root.get_node("/root/World/Level/MultiMesh")
    mm.clear("belt")
    for pos in beltPieces:
        mm.add("belt", Vector3i(pos.x, pos.y, beltPieces[pos]))
