extends Node

# Déclaration des constantes

# type=0 -> plancher
# type=1 -> mur
# type=2 -> petit méchant
# type=3 -> gros méchant
# type=4 -> nourriture
# type=5 -> arme
# type=6 -> fin
# type=7 -> joueur
# Dictionnaire des poids des différents types
const poids = {
	0:4,
	1:500,
	2:25,
	3:50,
	4:3,
	5:2,
	6:1,
	7:4
}

# Dictionnaire des noeuds
# Chaque index du dictionnaire est un noeud
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

# Déclaration des variables

# Un array des noeuds du labyrinthe
# Va servir à savoir la couleur du noeud
# Aussi c'est avec cette var que le noeud va changer de couleur
var noeud = []

# Sert à savoir si le noeud a été parcouru
var estVisite = []

# Sert à savoir si le noeud a été parcouru dans le chemin le plus court
var distance = {
	0:100000000,
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
	0:[],
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

# Pour savoir l'index de la première case
var debut

# Pour savoir l'index de la dernière case
var fin

# Pour l'algo de dijkstra array pour savoir si le noeud a été visiter
var marquer = []

# Retiens la prochaine case qui sera envoyer dans l'algo de dijkstra
var prochain

# Retiens la case visité en dernier par le joeur
var lastCase

# Random
var rng = RandomNumberGenerator.new()

onready var tmap = $VBoxContainer/tmap

# Remplie l'array de noeud
func _ready():
	for i in graph:
		noeud.append(get_node("noeud" + str(i)))
	
	randomMap()

# Vérifie si l'array de visite est vide et set couleur
func _on_runTime_timeout():
	if estVisite.empty():
		$runTime.stop()
	else:
		var i = estVisite.pop_front()
		noeud[i].setMouvement()
		if lastCase != null:
			noeud[lastCase].setBack()
		lastCase = i;

# Redonne la couleur de base à chacun des noeuds.
func _on_recommencer_pressed():
	distance = {
		0:100000000,
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
	
	marquer = []
	
	chemin = {
		0:[],
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
	
	estVisite = []
	
	lastCase = null
	randomMap()



# À la suite de l'action sur le bouton remplie l'array des noeud marquer 
# non-visiter ensuite appelle la fonction récursive pour trouver le chemin
# ensuite marque le meilleur chemin pour se rendre à la de type 7
func _on_parcourir_pressed():
	for i in graph:
		marquer.append(i)
	
	_dijkstra_visite(debut)
	
	for i in chemin[fin]:
		estVisite.append(i)
	# Après avoir marqué le chemin faire commencé le timer qui va stopper 1 seconde
	# entre chaque execution de la fonction lier _on_runTime_timeout
	$runTime.start(1.0)

# Fonction récursive pour trouvé le chemin le plus court
# prends en paramètre la case qui présente qui sera enlever de marquer
func _dijkstra_visite(present):
	# La distance de la prochaine case
	var distProchain = 100000000
	
	# Parcours les voisin de la case presente et leur donne un poids selon si
	# c'est un mur ou une case normal
	for voisin in graph[present]:
		if marquer.has(voisin):
			# calcul si la case doit réduire sa distance
			if distance[voisin] > distance[present] + poids[noeud[voisin].type]:
				distance[voisin] = distance[present] + poids[noeud[voisin].type]
				
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

func randomMap():
	rng.randomize()
	debut = rng.randi_range(0,9)
	
	rng.randomize()
	fin = rng.randi_range(15,24)
	
	chemin[debut].append(debut)
	
	distance[debut] = 0
	
	rng.randomize()
	var map = rng.randi_range(0,4)
	
	tmap.set_text(str('Le labyrinthe utilisé est produit avec la map ', map+1))
	
	if map == 0:
		noeud[0].setNoeud(0)
		noeud[1].setNoeud(0)
		noeud[2].setNoeud(1)
		noeud[3].setNoeud(0)
		noeud[4].setNoeud(0)
		noeud[5].setNoeud(1)
		noeud[6].setNoeud(0)
		noeud[7].setNoeud(1)
		noeud[8].setNoeud(1)
		noeud[9].setNoeud(0)
		noeud[10].setNoeud(0)
		noeud[11].setNoeud(0)
		noeud[12].setNoeud(1)
		noeud[13].setNoeud(1)
		noeud[14].setNoeud(0)
		noeud[15].setNoeud(0)
		noeud[16].setNoeud(1)
		noeud[17].setNoeud(0)
		noeud[18].setNoeud(0)
		noeud[19].setNoeud(0)
		noeud[20].setNoeud(0)
		noeud[21].setNoeud(0)
		noeud[22].setNoeud(0)
		noeud[23].setNoeud(0)
		noeud[24].setNoeud(1)
	elif map == 1:
		noeud[0].setNoeud(1)
		noeud[1].setNoeud(0)
		noeud[2].setNoeud(1)
		noeud[3].setNoeud(0)
		noeud[4].setNoeud(1)
		noeud[5].setNoeud(0)
		noeud[6].setNoeud(0)
		noeud[7].setNoeud(1)
		noeud[8].setNoeud(0)
		noeud[9].setNoeud(0)
		noeud[10].setNoeud(1)
		noeud[11].setNoeud(0)
		noeud[12].setNoeud(1)
		noeud[13].setNoeud(0)
		noeud[14].setNoeud(0)
		noeud[15].setNoeud(0)
		noeud[16].setNoeud(0)
		noeud[17].setNoeud(0)
		noeud[18].setNoeud(0)
		noeud[19].setNoeud(1)
		noeud[20].setNoeud(1)
		noeud[21].setNoeud(0)
		noeud[22].setNoeud(1)
		noeud[23].setNoeud(0)
		noeud[24].setNoeud(0)
	elif map == 2:
		noeud[0].setNoeud(0)
		noeud[1].setNoeud(1)
		noeud[2].setNoeud(0)
		noeud[3].setNoeud(0)
		noeud[4].setNoeud(0)
		noeud[5].setNoeud(0)
		noeud[6].setNoeud(1)
		noeud[7].setNoeud(1)
		noeud[8].setNoeud(1)
		noeud[9].setNoeud(0)
		noeud[10].setNoeud(0)
		noeud[11].setNoeud(0)
		noeud[12].setNoeud(0)
		noeud[13].setNoeud(1)
		noeud[14].setNoeud(0)
		noeud[15].setNoeud(0)
		noeud[16].setNoeud(1)
		noeud[17].setNoeud(1)
		noeud[18].setNoeud(1)
		noeud[19].setNoeud(0)
		noeud[20].setNoeud(0)
		noeud[21].setNoeud(0)
		noeud[22].setNoeud(0)
		noeud[23].setNoeud(0)
		noeud[24].setNoeud(0)
	elif map == 3:
		noeud[0].setNoeud(0)
		noeud[1].setNoeud(0)
		noeud[2].setNoeud(0)
		noeud[3].setNoeud(1)
		noeud[4].setNoeud(0)
		noeud[5].setNoeud(0)
		noeud[6].setNoeud(1)
		noeud[7].setNoeud(1)
		noeud[8].setNoeud(1)
		noeud[9].setNoeud(0)
		noeud[10].setNoeud(0)
		noeud[11].setNoeud(0)
		noeud[12].setNoeud(0)
		noeud[13].setNoeud(1)
		noeud[14].setNoeud(0)
		noeud[15].setNoeud(0)
		noeud[16].setNoeud(1)
		noeud[17].setNoeud(1)
		noeud[18].setNoeud(1)
		noeud[19].setNoeud(0)
		noeud[20].setNoeud(0)
		noeud[21].setNoeud(0)
		noeud[22].setNoeud(0)
		noeud[23].setNoeud(0)
		noeud[24].setNoeud(0)
	elif map == 4:
		noeud[0].setNoeud(0)
		noeud[1].setNoeud(0)
		noeud[2].setNoeud(0)
		noeud[3].setNoeud(1)
		noeud[4].setNoeud(0)
		noeud[5].setNoeud(0)
		noeud[6].setNoeud(1)
		noeud[7].setNoeud(1)
		noeud[8].setNoeud(1)
		noeud[9].setNoeud(0)
		noeud[10].setNoeud(0)
		noeud[11].setNoeud(1)
		noeud[12].setNoeud(0)
		noeud[13].setNoeud(0)
		noeud[14].setNoeud(0)
		noeud[15].setNoeud(0)
		noeud[16].setNoeud(1)
		noeud[17].setNoeud(1)
		noeud[18].setNoeud(1)
		noeud[19].setNoeud(0)
		noeud[20].setNoeud(0)
		noeud[21].setNoeud(0)
		noeud[22].setNoeud(0)
		noeud[23].setNoeud(0)
		noeud[24].setNoeud(0)
	else:
		noeud[0].setNoeud(0)
		noeud[1].setNoeud(1)
		noeud[2].setNoeud(0)
		noeud[3].setNoeud(0)
		noeud[4].setNoeud(0)
		noeud[5].setNoeud(0)
		noeud[6].setNoeud(1)
		noeud[7].setNoeud(1)
		noeud[8].setNoeud(1)
		noeud[9].setNoeud(0)
		noeud[10].setNoeud(0)
		noeud[11].setNoeud(1)
		noeud[12].setNoeud(0)
		noeud[13].setNoeud(0)
		noeud[14].setNoeud(0)
		noeud[15].setNoeud(0)
		noeud[16].setNoeud(1)
		noeud[17].setNoeud(1)
		noeud[18].setNoeud(1)
		noeud[19].setNoeud(0)
		noeud[20].setNoeud(0)
		noeud[21].setNoeud(0)
		noeud[22].setNoeud(0)
		noeud[23].setNoeud(0)
		noeud[24].setNoeud(0)
	
	for i in graph:
		rng.randomize()
		var type = rng.randi_range(0,5)
		
		if i == debut:
			noeud[i].setNoeud(7)
		elif i == fin:
			noeud[i].setNoeud(6)
		else:
			if noeud[i].type == 0:
				if type != 1:
					noeud[i].setNoeud(type)
