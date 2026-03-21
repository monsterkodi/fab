class_name World
extends Node

var currentLevel : Level
const LEVEL = preload("uid://b1g34431itmpg")
                    
func _ready():
    
    %MenuHandler.hideAllMenus()
    
    Post.subscribe(self)
    
    var settings = Settings.defaults
    var sd = Saver.getSettings()
    if sd: settings = sd
    Settings.apply(settings)
    
    %MusicHandler.playMenuMusic()
    get_tree().paused = true
    
    if not $IconHandler.visible:
    
        if Saver.getSaveGame(): # bypass main menu when savegame exists
            Post.continueGame.emit()
            return
    
    if $IconHandler.visible:
        newGame()
        get_tree().paused = true
    else:
        %MenuHandler.appear(%MainMenu)
    
func mainMenu():
    
    get_tree().paused = true
    #Saver.saveGame() # done in pause menu for now
    %MenuHandler.appear(%MainMenu)

func _process(delta: float):
    
    var orphan = Node.get_orphan_node_ids()
    if not orphan.is_empty():
        Log.log(orphan.size(), "orphans")
        Node.print_orphan_nodes()
        #quitGame()
        pass
        
func _unhandled_input(event: InputEvent):
    
    if Input.is_action_just_pressed("pause"): pauseMenu();   return
    if Input.is_action_just_pressed("quit"):  quitGame();    return
                
func continueGame():

    loadLevel(LEVEL)
                
func newGame():
    
    loadLevel(LEVEL, false)
        
func pauseMenu():
    
    if not get_tree().paused:
        pauseGame()
        %MenuHandler.appear(%PauseMenu)
        
func pauseGame():
    
    %Hud.slideOut()
    
    get_tree().paused = true
    Post.gamePaused.emit()
           
func resumeGame():
    
    %MenuHandler.vanishActive()
    
    %Hud.slideIn()
    
    get_tree().paused = false
    Post.gameResume.emit()
        
func quitGame():
    
    get_tree().quit()
        
func settingsMenu(backMenu:Menu):
    
    %SettingsMenu.backMenu = backMenu
    %MenuHandler.appear(%SettingsMenu)
    
func clearLevel():

    if currentLevel:
        currentLevel.free()

func loadLevel(levelRes, load = true):
    
    clearLevel()

    currentLevel = levelRes.instantiate()
    add_child(currentLevel)
    
    currentLevel.start()
    
    if load:
        Saver.loadGame()
    else:
        currentLevel.initGame()

    Post.levelStart.emit()
    resumeGame()
