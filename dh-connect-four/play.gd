extends Resource
class_name Play

var movimento: Vector2
var avaliacao: float

func _init(moviment: Vector2, avaliacao: float) -> void:
	self.movimento = movimento
	self.avaliacao = avaliacao
