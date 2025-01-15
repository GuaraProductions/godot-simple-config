extends Resource
class_name AbstractConfig

## Classe abstrata de onde todas as configuracoes sao derivadas [br] [br]
## Todas as configuracoes sao baseadas em classes, dessa forma permitindo  
## comportamento customizado a partir do script

## toda vez que o valor for modificado, esse sinal sera emitido, junto ao novo valor da configuracao
signal applied(value)

## O identificador da configuracao, usando para encontrar ela quando carregado do arquivo de configuracoes
@export var id : String = "" 
## O nome da configuracao
@export var name : String = "" : get = _get_name
## Descricao da configuracao
@export_multiline var description : String = "" : get = _get_description

## Valor da configuracao. Como cada configuracao pode ter um valor diferente, entao ela eh um Variant
var value : Variant = null : get = _get_value, set = _set_value

func _init(p_id: String = "",
		   p_name: String = "", 
		   p_description : String = "") -> void:
	
	id = p_id
	name = p_name
	description = p_description

func _get_name() -> String:
	return tr(name)
	
func _get_description() -> String:
	return tr(description)

func _set_value(new_value: Variant) -> void:
	if is_valid(new_value):
		value = new_value

func _get_value() -> Variant:
	return value if value != null else _default_value()
	
func _default_value() -> Variant:
	return null
	
## Validar se o novo valor que esta entrando na configuracao eh valido [br] [br]
## Eh possivel que um novo valor esteja entrando na configuracao, mas o mesmo nao eh
## valido para o contexto da mesma. Se esse for o caso, entao a funcao retornara falso,
## se o valor for verdadeiro, entao o valor eh valido [br][br]
## Observacao: Na construcao de configuracoes personalizadas, essa funcao precisa ser
## sobrescrita, para adaptar ao seu caso especifico
func is_valid(new_value: Variant) -> bool:
	printerr("Config \"is_valid\" function not implemented!")
	printerr("Config id: ", id)
	printerr("Config name: ", name)
	return false

## Tentar aplicar a configuracao para dentro do jogo
func try_to_apply() -> bool:
	
	var value_applied : bool = apply()
	
	if value_applied:
		applied.emit(value)
		
	return value_applied

## Aplicacao de fato da nova configuracao [br] [br]
## Observacao: Em configuracoes personalizadas, sobrescreva essa funcao na nova classe
## para criar comportamento customizado
func apply() -> bool:
	printerr("Config \"apply\" function not implemented!")
	printerr("Config id: ", id)
	printerr("Config name: ", name)
	return false
	
## Converta o conteudo dessa configuracao para JSON
func to_json() -> Dictionary:
	return {
		"id" : id,
		"name" : name,
		"description" : description,
		"value" : value
	}
