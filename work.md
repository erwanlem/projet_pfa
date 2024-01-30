# Suivi du travail

### Erwan - 29/01
**Organisation du code** pour la **gestion des mouvements**. Les mouvements sont maintenant géré par un système.
Possibilité de créer différents composants sur lesquels on peut gérer les mouvements.
**Création d'un composant *grounded*** qui indique si le composant touche le sol. Si non initialisé ne fait rien.
Lors de la création d'un composant *controlable* il faut donner une fonction qui va gérer les entrées du joueur.
**Création d'un fichier *config.ml*** pour la configuration des touches. On peut simplement changer les touches en modifiant la correspondance. Permet d'accéder facilement et de partout à la configuration des touches.

### Erwan - 30/01
**Changement du format des fichiers de map**. Afin de pouvoir créer des blocs de taille arbitraire j'ai créé un nouveau format de fichiers qui prend: type du bloc, position x-y et taille w-h. On évite ainsi les problèmes de collision qui peuvent arriver quand on fait des murs à partir de plusieurs blocs. Les tailles sont en **taille de bloc basic** qui est pour l'instant défini à 40. Donc si Width = 2 on a 2*40. La première ligne prend la taille totale de la map (x, y). On peut commenter avec '#'.
Les plateformes ont maintenant deux blocs sur les extrêmitées afin d'éviter de détecter qu'on est sur le sol alors qu'on touche une bordure (sinon on peut voler en suivant les bordures).

### Ewen - 30/01
**Design du jeu**. Premier jet du scénario du jeu. Découpage en niveau avec description détaillée des niveaux(élément de gameplay, lieus, ennemis et histoire).  
