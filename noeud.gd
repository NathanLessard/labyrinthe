extends Node2D

# Déclaration des variables
var couleur
export(Color) var baseCouleur
onready var noeudUtilise = $Polygon2D

# Called when the node enters the scene tree for the first time.
func _ready():
	couleur = baseCouleur
	noeudUtilise.color = couleur

func _setCouleur(c):
	couleur = c
	noeudUtilise.color = couleur

func _setCouleurBase():
	couleur = baseCouleur
	noeudUtilise.color = couleur
