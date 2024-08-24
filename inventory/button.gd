extends Button
@onready var Selos = $"../TabContainer/Selos"
@onready var tab = $"../TabContainer"
func tabbar():
	if :
		Selos.visible = true
		TabContainer.current_tab = 1
