extends Control

func _ready() -> void:
	Signals.connect("score_updated", self, '_on_score_updated')

func _on_score_updated(score: Array) -> void:
	$scoreLeft.text = String(score[0])
	$scoreRight.text = String(score[1])
