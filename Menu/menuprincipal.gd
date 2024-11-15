extends Node2D

var systemdatetime_dict = {}

@export_file("*.png") var festivosprites : Array[String]


func festivo():
	systemdatetime_dict = Time.get_datetime_dict_from_system()
	
	print(systemdatetime_dict)
	if systemdatetime_dict.month == 11:
		$MenuprincipalFundo/festivoshadow/festivo.texture = load(festivosprites[0])
		$MenuprincipalFundo/festivoshadow.position.x = 470.224
		$MenuprincipalFundo/festivoshadow.position.y = 920.0
		$MenuprincipalFundo/festivoshadow.scale.x = 1
		$MenuprincipalFundo/festivoshadow.scale.y = 1
		
		$MenuprincipalFundo/festivoshadow.visible = true
		$Menuprincipalcaixa/festivo2.visible = true
		$Menuprincipalcaixa/festivo3.visible = true
	if systemdatetime_dict.month == 10:
		$MenuprincipalFundo/festivoshadow/festivo.texture = load(festivosprites[1])
		$MenuprincipalFundo/festivoshadow.position.x = 3441.031
		$MenuprincipalFundo/festivoshadow.position.y = -851.282
		$MenuprincipalFundo/festivoshadow.scale.x = 0.8
		$MenuprincipalFundo/festivoshadow.scale.y = 0.8
		
		$MenuprincipalFundo/festivoshadow.visible = true
		$Menuprincipalcaixa/festivo2.visible = true
		$Menuprincipalcaixa/festivo3.visible = true
	elif systemdatetime_dict.month != 11 and systemdatetime_dict.month != 10:
		$MenuprincipalFundo/festivoshadow.visible = false
		$Menuprincipalcaixa/festivo2.visible = false
		$Menuprincipalcaixa/festivo3.visible = false
		#$MenuprincipalFundo/festivo.texture = 





func _ready() -> void:
	festivo()

func loadscene():
	pass


func _on_button_carregar_pressed() -> void:
	$AnimationPlayer.play("apertado")


func _on_button_config_pressed() -> void:
	$AnimationPlayer.play("apertado")


func _on_button_sair_pressed() -> void:
	$AnimationPlayer.play("apertado")
