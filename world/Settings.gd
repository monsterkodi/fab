class_name Settings
extends Node

static var defaults = {
    "brightness":    1.0,
    "hires":         false,
    "volumeMaster":  1.0,
    "volumeMusic":   1.0,
    "volumeGame":    1.0,
    "volumeMenu":    1.0,
    "fullscreen":    false,
}

static var settings = {}
        
static func applySetting(key, value):
    
    settings[key] = value
    
    match key:
        
        "brightness":    node("Camera/Light").light_energy = value
        "hires":         setHires(value)
        "volumeMaster":  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
        "volumeGame":    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Game"),   linear_to_db(value))
        "volumeMenu":    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Menu"),   linear_to_db(value))
        "volumeMusic":   
                         AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),       linear_to_db(value))
                         AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Menu Music"),  linear_to_db(value))
        "fullscreen":    setFullscreen(value)
    
static func setHires(value):

    if value:
        world().get_window().content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
    else:
        world().get_window().content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
        
static func setFullscreen(value):
    
    if value:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
    else:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
        DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
        DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_RESIZE_DISABLED, false)
        
static func apply(dict):
    
    for key in dict:
        applySetting(key, dict[key])
        
static func world():
    
    return Engine.get_main_loop().root.get_node("World")
        
static func node(path): 
    
    return world().get_node(path)
        
