extends Node

## Autoload responsavel em gerenciar as configuracoes do jogo e salvar em disco. [br] [br]
## Ele possui varios nodes do tipo ConfigManager, e cada um gerencia as configuracoes como
## recursos em uma lista.

## Nome do arquivo onde sera salvo as configuracoes
@export var file_name : String = "user://game_config.cfg"
## Marque essa caixa se voce quer que quando o projeto for iniciado, as configuracoes seram
## aplicadas logo apos serem carregadas do disco.
@export var config_at_startup : bool = true
@export_category("Encryption")
## Marque essa caixa se voce quer que o arquivo de configuracao seja salvo com criptografia
@export var encrypt_file : bool = false
## Se o arquivo for criptografado, aqui voce colocara a chave criptografica
@export var encryption_key : String = ""

func _ready() -> void:
	
	load_configs()
	
	if config_at_startup:
		apply_configs()

func _get_config_node(config_manager: String) -> ConfigManager:
	
	var node = get_node_or_null(config_manager)
	
	if not node:
		printerr("Erro! Config Manager \"%s\" nao existe!")
	
	return node

## Retorne as informacoes de uma configuracao especifica [br] [br]
## O [config_manager] eh o nome do node que esta na cena do GameConfig, ja o [config] 
## eh o identificador da configuracao especifica dentro do [config_manager]. [br] [br]
## O retorno dessa funcao são as informacoes da configuracao dentro de um dicionario
func get_config(config_manager: String, 
				config: String) -> Dictionary:
	
	var node = _get_config_node(config_manager)
	if node == null:
		return {}
	
	return node.get_config_by_id(config) 
	
## Acessar todas as informações de todas as configurações de um bloco do 
## [config_manager] [br] [br]
## A lista [configs] se nao for vazia, significa que a funcao
## ira filtrar para resgatar apenas as configuracoes especificadas
func get_configs(config_manager: String, configs: PackedStringArray = []) -> Dictionary:
	
	var config_dictionary : Dictionary = {}
	
	for config_node in get_children():
		
		if not config_node is ConfigManager or config_node.name != config_manager:
			continue
		
		if configs.is_empty() or configs.has(config_node.name):
			config_dictionary[config_node.name] = config_node.get_configs()
			
		break
		
	return config_dictionary

## Modifique o valor de uma configuração especifica. [br] [br]
## O [config_manager] refere-se a qual grupo de configuracoes sera acessado
## e o [config] eh o identificador da configuracao desejada. [value] eh o novo valor
## da configuracao. [br] [br]
## Obs.: Se a sua configuração precisa ser aplicada logo após a atribuição, coloque
## o valor de [apply_after_set] para verdadeiro.
func set_config(config_manager: String, 
				config: String, 
				value: Variant,
				apply_after_set: bool = false) -> bool:
	
	var node = _get_config_node(config_manager)
	if node == null:
		return false
	
	return node.set_config(config, value, apply_after_set) 

## Salvar todas as configuracoes para o disco. [br] [br]
## Se [apply_all] for verdadeiro, entao as configuracoes alem de serem salvas
## no disco, tambem serao aplicadas para dentro do jogo.
func save_configs(apply_all: bool = false) -> void:

	var config_nodes = get_tree().get_nodes_in_group(ConfigManager.GROUP_NAME)
	
	var config_file = ConfigFile.new()
	
	for config in config_nodes:
		
		var config_to_save : Dictionary = config.get_configs()
		
		for key in config_to_save.keys():
			var config_json = config_to_save[key]
			
			config_file.set_value(config.name, key, var_to_str(config_json.value))
		
		if apply_all:
			config.apply_configs()
	
	if encrypt_file and not encryption_key.is_empty():
		config_file.save_encrypted_pass(file_name, encryption_key)
	else:
		if encrypt_file and encryption_key.is_empty():
			printerr("Erro! a chave criptografica esta vazia, salvando o arquivo sem criptografia...")
		config_file.save(file_name)

## Aplicar as configuracoes existentes [br] [br]
## Se [save] for verdadeiro, então as configuracoes tambem serao salvas
## no disco
func apply_configs(save: bool = false) -> void:
	var config_nodes = get_tree().get_nodes_in_group(ConfigManager.GROUP_NAME)
	
	for config in config_nodes:
		config.apply_configs()
		
	if save:
		save_configs()
	
## Carregar as configuracoes do disco para dentro do jogo.
func load_configs() -> void:
	var config_file = ConfigFile.new()
	var error = OK
	if encrypt_file and not encryption_key.is_empty():
		error = config_file.load_encrypted_pass(file_name, encryption_key)
	else:
		if encrypt_file and encryption_key.is_empty():
			printerr("Erro! a chave criptografica esta vazia, carregando o arquivo sem criptografia...")
		error = config_file.load(file_name)
		
	if error != OK:
		if error != ERR_FILE_NOT_FOUND:
			printerr("Não foi possível abrir o arquivo: %d" % [error])
		return
	
	var config_nodes = get_tree().get_nodes_in_group(ConfigManager.GROUP_NAME)
	
	for config in config_nodes:
		if not config_file.has_section(config.name):
			continue
		
		var config_to_load = {}
		for key in config_file.get_section_keys(config.name):
			config_to_load[key] = config_file.get_value(config.name, key)
		
		config.set_configs(config_to_load)

## Conectar o sinal `applied` para um callable especifico [br] [br]
## Alem de especificar o grupo da configuracao [config_manager] e a
## configuracao especifica a ser afetada [config], eh necessario a
## funcao que sera conectada [callable] e as flags dessa conexao [flags]
func connect_to_applied_signal(config_manager: String, 
							   config: String, 
							   callable: Callable,
							   flags: int = 0) -> bool:
										
	var node = _get_config_node(config_manager)
	if node == null:
		return false
	
	return node.connect_config_applied_to_callable(config,callable,flags) 
