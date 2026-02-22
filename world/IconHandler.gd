class_name IconHandler
extends Control

const BUILDING_ROOT    = preload("uid://h62wu6f77eaq")
const BUILDING_STORAGE = preload("uid://cnxiw8djnknk6")
const BUILDING_PRISM   = preload("uid://d4i4sjdrnt324")

func _ready():

    if not DirAccess.dir_exists_absolute("res://icons/buildings/"):
        DirAccess.make_dir_recursive_absolute("res://icons/buildings/")
    
    %Viewport.get_node("Camera").look_at(Vector3.ZERO)
    
    for res in Utils.resourcesInDir("res://buildings/"):    
        generateIcon(res, "res://icons/buildings/")

func generateIcon(itemRes, path: String):

    var container = %Container.duplicate()
    var viewport = container.get_node("Viewport")
    var itemNode = itemRes.instantiate()

    viewport.add_child(itemNode)
    %Grid.add_child(container)
    
    await RenderingServer.frame_post_draw # wait for the frame to render
    
    var iconPath = path + itemNode.name + ".png"
    var error = viewport.get_texture().get_image().save_png(iconPath)
    if error != OK:
        push_error("Failed to save icon: ", error, iconPath)
    else:
        print("icon: ", iconPath)
