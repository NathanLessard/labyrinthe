extends Node2D

# Déclaration des constante
# type=0 -> plancher
# type=1 -> mur
# type=2 -> petit méchant
# type=3 -> gros méchant
# type=4 -> nourriture
# type=5 -> arme
# type=6 -> fin
# type=7 -> joueur
# Dictionnaire des couleurs des différents types
const couleurs = {
	0:Color(1,1,1,1),
	1:Color(0,0,0,1),
	2:Color(1,1,1,1),
	3:Color(1,1,1,1),
	4:Color(1,1,1,1),
	5:Color(1,1,1,1),
	6:Color(0,1,1,1),
	7:Color(0,0.55,0.55,1)
}

# Déclaration des variables
var imgArme = Image.new()
var itexArme = ImageTexture.new()
var imgNour = Image.new()
var itexNour = ImageTexture.new()
var imgPetit = Image.new()
var itexPetit = ImageTexture.new()
var imgGros = Image.new()
var itexGros = ImageTexture.new()
var imgJoueur = Image.new()
var itexJoueur = ImageTexture.new()
var itex
var type
onready var noeudUtilise = $Polygon2D

func _ready():
	itex = {
		0:null,
		1:null,
		2:load("res://petit-monstre.png"),
		3:load("res://gros-monstre.png"),
		4:load("res://soupe.png"),
		5:load("res://arme.png"),
		6:null,
		7:load("res://joueur.png")
	}


func setMouvement():
	noeudUtilise.texture = itex[7]

func setBack():
	noeudUtilise.texture = itex[0]

func setNoeud(t):
	type = t
	noeudUtilise.color = couleurs[type]
	noeudUtilise.texture = itex[type]
