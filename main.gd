extends Node

# Déclaration des constantes

# Dictionnaire des noeuds
# Chaque index du dictionnaire est un noeud
# Les array que l'index contient est l'index de son voisin
# Ce n'est pas lier au noeud, mais pour changer la disposition du labyrinthe
# il faut que l'on change la couleur des case dans la scène 2d en cliquant sur
# la case et ensuite sur base couleur pour un mur set la couleur à 
# Color(0.607843, 0.607843, 0.607843, 1)
# la case 9 est la fin du labyrinthe
const graph = {
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

# La couleur que la case change après avoir été visité
const couleurVisite = Color(1, 0.84, 0, 1)

# Déclaration des variables

# Un array des noeuds du labyrinthe
# Va servir à savoir la couleur du noeud
# Aussi c'est avec cette var que le noeud va changer de couleur
var noeud = []

# Sert à savoir le dernier noeud parcouru
var parcours = []

# Sert à savoir si le noeud a été parcouru
var estVisite = []

# Sert à savoir si le noeud a été parcouru dans le chemin le plus court
var distance = {
	0:0,
	1:100000000,
	2:100000000,
	3:100000000,
	4:100000000,
	5:100000000,
	6:100000000,
	7:100000000,
	8:100000000,
	9:100000000,
	10:100000000,
	11:100000000,
	12:100000000,
	13:100000000,
	14:100000000,
	15:100000000,
	16:100000000,
	17:100000000,
	18:100000000,
	19:100000000,
	20:100000000,
	21:100000000,
	22:100000000,
	23:100000000,
	24:100000000
}

# Dictionnaire des chemin pour retenir le chemin
var chemin = {
	0:[0],
	1:[],
	2:[],
	3:[],
	4:[],
	5:[],
	6:[],
	7:[],
	8:[],
	9:[],
	10:[],
	11:[],
	12:[],
	13:[],
	14:[],
	15:[],
	16:[],
	17:[],
	18:[],
	19:[],
	20:[],
	21:[],
	22:[],
	23:[],
	24:[]
}

# Pour l'algo de dijkstra array pour savoir si le noeud a été visiter
var marquer = []

# Retiens la prochaine case qui sera envoyer dans l'algo de dijkstra
var prochain

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

# À la suite de l'action sur le bouton remplie l'array des noeud marquer 
# non-visiter ensuite appelle la fonction récursive pour trouver le chemin
# ensuite marque le meilleur chemin pour se rendre à la case 9(la case rouge)
func _on_dijkstra_pressed():
	for i in graph:
		marquer.append(i)
	
	_dijkstra_visite(0)
	
	for i in chemin[9]:
		estVisite.append(i)
	# Après avoir marqué le chemin faire commencé le timer qui va stopper 1 seconde
	# entre chaque execution de la fonction lier _on_runTime_timeout
	$runTime.start(1.0)

# Fonction récursive pour trouvé le chemin le plus court
# prends en paramètre la case qui présente qui sera enlever de marquer
func _dijkstra_visite(present):
	# Le poid entre les case
	var poid
	
	# La distance de la prochaine case
	var distProchain = 100000000
	
	# Parcours les voisin de la case presente et leur donne un poids selon si
	# c'est un mur ou une case normal
	for voisin in graph[present]:
		if marquer.has(voisin):
			if noeud[voisin].couleur != Color(0.607843, 0.607843, 0.607843, 1):
				poid = 1
			else:
				poid = 500
			
			# calcul si la case doit réduire sa distance
			if distance[voisin] > distance[present] + poid:
				distance[voisin] = distance[present] + poid
				
				# après avoir réduit la distance lui donne son nouveau chemin
				# le plus court en oubliant l'ancien.
				chemin[voisin].clear()
				for i in chemin[present]:
					chemin[voisin].append(i)
				chemin[voisin].append(voisin)
			
			# Vérifie que j'ai toujours la plus petite distance pour mon
			# prochain voisin
			if distProchain > distance[voisin]:
				distProchain = distance[voisin]
				prochain = voisin
	
	# Enlève la case présente des non visité
	marquer.erase(present)
	
	# Parcours les case non visité pour savoir si une case à une moins grande
	# distance que la case prochaine actuel
	for i in graph:
		if marquer.has(i):
			if distance[i] < distProchain:
				prochain = i
	
	# Vérifie qu'il reste des case si oui regarde si la prochaine est déjà
	# vérifier si elle l'est visite la premiere case des cases restantent
	if (!marquer.empty()):
		if (marquer.has(prochain)):
			_dijkstra_visite(prochain)
		else:
			_dijkstra_visite(marquer.front())
