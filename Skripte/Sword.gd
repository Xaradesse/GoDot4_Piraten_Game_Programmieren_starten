extends Node2D


# Wird aufgerufen, wenn der Knoten zum ersten Mal in den Szenenbaum eintritt.
func _ready():
	pass # Durch Funktionskörper ersetzen.


# Jeder Frame wird aufgerufen. „Delta“ ist die seit dem vorherigen Frame verstrichene Zeit.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if(body.is_in_group("Player")):
		body.hasSword = true
		queue_free()
