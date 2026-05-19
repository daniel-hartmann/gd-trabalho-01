extends Resource
class_name Play

var movimento: Vector2
var avaliacao: float

func _init(movimento: Vector2, avaliacao: float):
	self.movimento = movimento
	self.avaliacao = avaliacao
