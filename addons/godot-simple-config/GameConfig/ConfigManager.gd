extends Node
class_name ConfigManager

## Gerencia um grupo seleto de configuracoes dentro de uma lista

## Nome do grupo de cena a ser adicionado
const GROUP_NAME : String = "Config"

func _ready() -> void:
	
	## Ignorar execucao dessa funcao se tiver dentro do Editor
	if Engine.is_editor_hint():
		return
	
	if not is_in_group(GROUP_NAME):
		add_to_group(GROUP_NAME)

## Acessar as informacoes internas de uma configuracao, a partir de seu id [config]
func get_config_by_id(config: String) -> Dictionary:
	
	var config_node = get_node_or_null(config)
	if config_node == null or not config_node is AbstractConfig:
		return {}
	
	return get_node(config).to_json()
	
## Retornar todas as configuracoes em formato JSON 
func get_configs() -> Dictionary:
	var result : Dictionary = {}
	for curr in get_children():
		result[curr.name] = curr.to_json()
	return result
	
## Aplicar todas as configuracoes, se existir
func apply_configs(first_time: bool = false) -> void:
	for curr in get_children():
		if curr == null:
			continue
			
		if curr is AbstractConfig:
			curr.try_to_apply(first_time)
		else:
			printerr("O node \"%s\" não é do tipo \"AbstractConfig\"" % curr.name)

## Conectar a chamada do sinal `applied` a uma configuracao
func connect_config_applied_to_callable(config: String, 
										callable: Callable,
										flags: int) -> bool:
	var connected : bool = false
	
	var config_node = get_node_or_null(config)
	if config_node == null or not config_node is AbstractConfig:
		return false
		
	connected = true
		
	if not config_node.applied.is_connected(callable):
		config_node.applied.connect(callable, flags)
		
	return connected

## Atribuir um novo valor a uma configuracao
func set_config(config: String, 
				value: Variant,
				apply_after_set: bool) -> bool:
	
	var found : bool = false
	
	var config_node = get_node_or_null(config) as AbstractConfig
	if config_node == null or not config_node is AbstractConfig:
		return false
			
	config_node.value = value
	found = config_node.value == value
	
	if found and apply_after_set:
		config_node.try_to_apply()
		
	return found

## Configuracao em massa de todas as configuracoes
func set_configs(dict: Dictionary) -> bool:
	for curr in get_children():
		if not dict.has(curr.name):
			continue
		
		var value = str_to_var(dict[curr.name])
		curr.value = value
		
	return true
