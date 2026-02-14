class_name HudClock
extends Control

static var showClock : bool = false

func _process(delta: float):
    
    %ClockPanel.visible = HudClock.showClock
