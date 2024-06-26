# Game

Ce répertoire contient le code du jeu `Arthur la quête de la Cuillère`.

> Pour une meilleure expérience de jeu activer le son !

## Les commandes de jeu

- `q` : déplacement droite
- `d` : déplacement gauche
- `s` : coup d'épée
- `z` : saut
- `espace` : boule de feu (à partir du niveau 3)
- `shift` : Téléportation (à partir du niveau 2)

### Commandes débogage
- Sélection de niveau avec `0 1 2 3 4`
- Changer focus caméra joueur/libre avec `p`
- Déplacement caméra mode libre : `o` (haut), `k` (gauche), `l` (bas), `m` (droite)
- Modifier la vitesse du joueur : + avec `u`, - avec `j`

## Structure des répertoires 

* `doc` : Le répertoire contenant le rapport du projet.
* `resources` : répertoire dans lequel déposer les ressources (images, polices, fichiers textes, …)
* `lib`: répertoire contenant deux bibliothèques :
	- `ecs`: La bibliothèque ECS
	- `gfx` : La bibliothèque Graphique avec un backend JavaScript et un backend [SDL2](https://www.libsdl.org/).

* `src` : le répertoire devant contenir les sources du jeu :

* `prog`: un répertoire contenant deux programmes principaux. Ils sont uniquement là pour servir de cible de compilation différente : `game_js.ml` produit le fichier `game_js.bc.js` qui est inclus depuis le fichier `index.html`. C'est le « programme principal » compilé en Javascript, le seul que l'on demande de supporter pour le projet. `game_sdl.ml` produit le fichier `game_sdl.exe` qui utilise la bibliothèque SDL pour faire un rendu graphique et produit un exécutable natif.

## Construction du jeu 

Il suffit de faire `dune build` à la racine. La cible construite par défaut est `prog/game_js.bc.js` qui est incluse dans le fichier HTML `index.html`. Pour construire le programme natif SDL, il faut exécuter la commande `dune build @sdl`.

Pour effacer les fichiers générés, utiliser la commande `dune clean`.

##  Dépendences
Le projet de base requiert `ocaml`, `js_of_ocaml`, `js_of_ocaml-ppx`, `dune`. La production de code natif (testé uniquement sous Linux pour l'instant) requiert `tsdl`, `tsdl-image`, `tsdl-mixer` et `tsdl-ttf` (ainsi que la bibliothèque SDL native).




## Références
### ECS
https://en.wikipedia.org/wiki/Entity_component_system
https://austinmorlan.com/posts/entity_component_system/
https://tsprojectsblog.wordpress.com/portfolio/entity-component-system/
https://savas.ca/nomad
https://github.com/skypjack/entt
https://ajmmertens.medium.com/building-an-ecs-2-archetypes-and-vectorization-fe21690805f9
https://github.com/SanderMertens/flecs

### Physique/Collision
https://medium.com/@brazmogu/physics-for-game-dev-a-platformer-physics-cheatsheet-f34b09064558
https://www.gamedeveloper.com/design/platformer-controls-how-to-avoid-limpness-and-rigidity-feelings
https://blog.hamaluik.ca/posts/simple-aabb-collision-using-minkowski-difference/
https://www.toptal.com/game/video-game-physics-part-i-an-introduction-to-rigid-body-dynamics
https://www.toptal.com/game/video-game-physics-part-ii-collision-detection-for-solid-objects
https://www.toptal.com/game/video-game-physics-part-iii-constrained-rigid-body-simulation
https://gdcvault.com/play/1021921/Designing-with-Physics-Bend-the