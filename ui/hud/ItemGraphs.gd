class_name ItemGraphs
extends Panel

const LINEW := 5
const STEPS := 4
var itemTypes = []

func _ready():
    
    Post.subscribe(self)
    
func itemStats():
    
    if visible:
        queue_redraw()
        
func itemGraphAdd(itemType):
    
    if itemTypes.find(itemType) < 0:
        itemTypes.push_back(itemType)
    if not visible: 
        show()
    else:
        queue_redraw()

func itemGraphDel(itemType):
    
    if itemTypes.find(itemType) >= 0:
        itemTypes.erase(itemType)
    if itemTypes.is_empty():
        hide()
    else:
        queue_redraw()

func drawGraph():

    var graphs = Utils.fabState().stats.graphs
    if graphs.is_empty(): return
    
    var lines := PackedVector2Array()
    lines.resize(STEPS*2)
    for s in STEPS:
        lines[s*2]   = Vector2(0,      size.y - (s+1)*size.y/STEPS)
        lines[s*2+1] = Vector2(size.x, size.y - (s+1)*size.y/STEPS)
    draw_multiline(lines, Color.BLACK, 1.0)
    
    for item in itemTypes:
        var graph = graphs[item]
        lines.resize(graph.size()*4)
        for index in graph.size()-1:
            lines[index*4]   = Vector2(index*LINEW, size.y - graph[index]*size.y/STEPS)
            lines[index*4+1] = Vector2(index*LINEW, size.y - graph[index+1]*size.y/STEPS)
            lines[index*4+2] = Vector2(index*LINEW, size.y - graph[index+1]*size.y/STEPS)
            lines[index*4+3] = Vector2((index+1)*LINEW, size.y - graph[index+1]*size.y/STEPS)
        draw_multiline(lines, Item.colorForType(item), 1.0, true)
    
