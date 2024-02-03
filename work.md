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

### Erwan - 30/01
**Mouvement de caméra** : La caméra suit maintenant le joueur. J'ai créé un composant caméra qui contient l'objet que l'on veut suivre (focus). La caméra est stockée dans *Global*. Il y a ensuite un système *vision* qui applique les modifications des positions en fonction de l'emplacement de la caméra. Cette organisation devrait permettre une certaine souplesse par la suite si des modifications sont à faire. On applique le système *vision* juste avant *draw*. On ajoute une **position de caméra** aux objets qui permet de définir la position de l'objet par rapport à la caméra et non plus une coordonnée fixe. C'est maintenant la position caméra qui est utilisée dans *draw*.

### Erwan - 31/01
**Correction bug** collision entre joueur et plateforme. **Ajout d'un composant *jump_box*** qui permet de créer des plateformes tremplin.

### Erwan - 02/02
**Ajout kill_box** (le joueur meurt s'il touche le bloc). J'ai ajouté un composant *health* au composant *player*. La valeur de vie par défaut du joueur est stockée dans *const.ml*. Ajout d'un **composant général *onCollideEvent*** qui permet d'appeler une fonction lors de la collision. Tout objet peut donc effectuer une action lors d'une collision. On lui donne pour paramètre l'identifier le l'objet en collision. **Création de *bullet.ml*** qui va permettre de créer des "projectiles" (à voir ce qu'on tire). Le projectile est détruit lors d'une collision. Il faudra gérer la collision d'un ennemi est d'un projectile tel que si l'ennemi est en collision avec un projectile il perd de la vie (on gère donc ça du côté de l'ennemi pas du projectile).
Légère modification des touches. Tous les identifiants des touches sont maintenant dans le fichier *config.ml*.

### Erwan - 02/02
**Tir des projectiles** possible avec la touche espace. Ajout d'un composant *direction* qui permet de garder la direction du joueur (gauche ou droite) utilisée pour tirer dans la direction vers laquelle on regarde. La vitesse des projectiles peut être modifiée via le fichier *const.ml*.

### Erwan - 03/02
**Limitation rebond *jump_box***. Les rebonds des collisions sont limités pour que le joueur ne saute pas infiniment haut.