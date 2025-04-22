@tool
extends Node
class_name FieldSyncSignal

signal config_updated(value)

## Sincronize uma configuracao especifica do projeto, com a propriedade de um node.

## Identificador do [ConfigManager] dentro das configuracoes
@export var config_manager_id : String = "" : set = _set_config_manager_id
## Identificador da configuração a ser resgatada
@export var config_id : String = "" : set = _set_config_id

var parent

func _ready() -> void:
	
	# Ignorar esse codigo se for rodado no Script
	if Engine.is_editor_hint():
		return
	
	var config_information : Dictionary = \
	 GameConfig.get_config(config_manager_id, config_id)
	
	if config_information.is_empty():
		printerr("[FieldSyncSignal]: ERRO! ConfigManagerId or ConfigID is incorrect!")
		printerr("ConfigManagerID: ", config_manager_id)
		printerr("ConfigID: ", config_id)
		return 
	
	GameConfig.connect_to_applied_signal(config_manager_id, 
										 config_id, 
										 update_call)
	
	# O node pai chama a funcao _ready, depois deste, logo, conectar a chamada da
	# funcao ready, para que o valor seja apenas atualizado, quando o pai estiver
	# pronto
	parent = get_parent()
	parent.ready.connect(_parent_ready.bind(config_information.value))

## Quando o node pai esta pronto, essa funcao sera chamada para atualizar o valor
func _parent_ready(value: Variant) -> void:
	
	if not parent is Control:
		return
		
	update_call(value)

## Invoca a chamada de um sinal para avisar que o valor de configuracao foi avisado. [br] [br]
## Obs.: Se a atualizacao do node pai for mais complexa, crie uma classe
## que sobrescreva essa funcao e crie um comportamento personalizado.
func update_call(value: Variant) -> void:
	config_updated.emit(value)

func _set_config_id(value: String) -> void:
	config_id = value
	update_configuration_warnings()
	
func _set_config_manager_id(value: String) -> void:
	config_manager_id = value
	update_configuration_warnings()
	
func _get_configuration_warnings() -> PackedStringArray:
	
	var errors := []
	
	if config_manager_id.is_empty():
		errors.append("Please configure the \"config_manager_id\" property")
		
	if config_id.is_empty():
		errors.append("Please configure the \"config_id\" property")
		
	return errors
