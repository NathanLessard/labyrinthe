extends Node

# Déclaration des constantes
# La couleur que la case change après avoir été visité
const couleurVisite = Color(1, 0.84, 0, 1)

# Déclaration des variables

# Dictionnaire des noeuds
# Chaque index du dictionnaire est un noeud
# Les array que l'index contient est l'index de son voisin
var graph = {
	0:[1,5],
	1:[0,2,6],
	2:[1,3,7],
	3:[2,4,8],
	4:[3,9],
	5:[0,6,10],
	6:[1,5,7,11],
	7:[2,6,8,12],
	8:[3,7,9,13],
	9:[4,8,14],
	10:[5,11,15],
	11:[6,10,12,16],
	12:[7,11,13,17],
	13:[8,12,14,18],
	14:[9,13,19],
	15:[10,16,20],
	16:[11,15,17,21],
	17:[12,16,18,22],
	18:[13,17,19,23],
	19:[14,18,24],
	20:[15,21],
	21:[16,20,22],
	22:[17,21,23],
	23:[18,22,24],
	24:[19,23]
}

# Un array des noeuds du labyrinthe
# Va servir à savoir la couleur du noeud
# Aussi c'est avec cette var que le noeud va changer de couleur
var noeud = []

# Sert à savoir le dernier noeud parcouru
var parcours = []

# Sert à savoir si le noeud a été parcouru
var estVisite = []

# Remplie l'array de noeud
func _ready():
	for i in graph:
		noeud.append(get_node("noeud" + str(i)))

# Vérifie si l'array de visite est vide 
# Sinon enlève le premier noeud de l'array visite
# et lui assigne la couleurVisite
func _on_runTime_timeout():
	if estVisite.empty():
		$runTime.stop()
	else:
		var i = estVisite.pop_front()
		noeud[i]._setCouleur(couleurVisite)

# Redonne la couleur de base à chacun des noeuds.
func _on_recommencer_pressed():
	get_tree().call_group("noeuds", "_setCouleurBase")

# Parcours en largeur le labyrinthe
func _on_largeur_pressed():
	parcours.push_front(graph[0])
	estVisite.append(0)
	
	while !parcours.empty():
		var noeudPresent = parcours.pop_back()
		for voisin in noeudPresent:
			if !estVisite.has(voisin):
				if noeud[voisin].couleur != Color(0.607843, 0.607843, 0.607843, 1):
					estVisite.append(voisin)
					parcours.push_front(graph[voisin])
	# Après avoir marqué tous les voisin faire commencé le timer qui va stopper 1 seconde
	# entre chaque execution de la fonction lier _on_runTime_timeout
	$runTime.start(1.0)

# Appelle la fonction récursive pour parcourir le labyrinthe en profondeur
# Commence en appelant le premier noeud (La case bleu du début)
func _on_profondeur_pressed():
	# Appeler la fonction récursive pour la première case.
	_profondeur_visite(0)
	# Après avoir marqué tous les voisin faire commencé le timer qui va stopper 1 seconde
	# entre chaque execution de la fonction lier _on_runTime_timeout
	$runTime.start(1.0)

# Parcours récursif du labyrinthe
func _profondeur_visite(present):
	estVisite.append(present)
	
	# Parcours chaque case voisine
	# Si la case est déjà visité essaye la prochaine sinon vérifie que ce n'est
	# pas un mur selon la couleur de la case.
	for voisin in graph[present]:
		if !estVisite.has(voisin):
			if noeud[voisin].couleur != Color(0.607843, 0.607843, 0.607843, 1):
				_profondeur_visite(voisin)
