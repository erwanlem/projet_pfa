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

### Erwan - 06/02
**Changement du système de rebond**. Les rebonds sont maintenant possible en vérifiant le vecteur sol-joueur et la direction du vecteur vélocité du joueur. L'entité *jump_box* utilise le même procédé pour ajuster le composant *elasticity*. Si la collision a lieu au dessus elasticity = 2 sinon elasticity = 0.
**Changement de niveaux** en utilisant l'entité **exit_box**. Cette entité va (pas encore fait) prendre un nom de niveau et si collision avec le joueur alors change de niveau.
**Préchargement des ressources** via le fichier *resources.ml*. Ce fichier charge toutes les ressources et les stocke dans une table de hachage.
**Gestion des niveaux** via *global.ml*. Le update vérifie si un changement de niveau est demandé et si oui il charge le niveau correspondant. On peut get et set les niveaux via des fonctions dans *global.ml*.
**Création de 02.level** pour tester.

### Erwan - 10/02
**Résolution bug des plateformes rebondissantes** en limitant la vélocité. Création d'une fonction pour restreindre les vecteurs (*clamp*). **Ajout d'un système de vie** pour le joueur (ajouter également les ennemis). **Création d'un fossé** sur *01.level*. Il reste un petit bug lorsque l'on se laisse tomber dans un trou (sans sauter) il est possible de sauter alors qu'on ne touche pas le sol.

### Erwan - 11/02
Création d'un fichier **menu.ml** pour le menu du jeu. Création de *button.ml* pour **créer des boutons** qui redirigent vers un niveau. Le bouton est activé grâce à la touche *return* (voir pour utiliser la souris plus tard). Création d'un fichier *map.md* pour noter les identifiants des blocs.

### Ewen - 12/02
Création d'un systeme **Ennemy.ml** pour gerer les ennemis. Création de arch.ml pour **créer des archers qui tire suivant un patern qui leur est défini**. Création de knight.ml pour **créer des ennemis de types knight**. Il faut encore definir la maniere de faire apparaitre un knight dans le level loader et definir une ia correcte pour chaque mob.

### Erwan - 13/02
Ajout **mouvement du joueur** et ajout des textures pour les maps.

### Erwan - 19/02
Travail sur l'**ajout des textures**. Amélioration du **système de paramètres** avec la création d'un type *settings* qui contient les différents paramètres possibles. On crée une enregistrement de settings à partir de la table de hachage. Les niveaux ont été adapté pour les textures. Amélioration de la hitbox du joueur.

### Erwan - 20/02
Ajout d'une **entité *text*** pour écrire en utilisant le paramètre text (par exemple avec button). Ajout d'une **entité *decor*** pour créer des éléments de décor qui n'intéragissent pas avec le joueur. Ajout **animation tir** avec une boule de feu. 

### Ewen - 3/03
Ajout de **vision.ml**. Ce fichier permet de detecter si le joueur est dans le champ de vision d'un ennemi. Amélioration du patterne de l'archer : il ne se base plus par rapport au temps pour tirer toute les secondes, il ne tire que si le joueur a ete dans son champs de vision récement.

### Erwan - 04/03
**Création de hitbox** pour toutes les entités. Permet de régler précisément la zone de collision des objets.
Cet outil est seulement là pour le débogage. Retirer lorsque plus nécessaire car coûteux en calculs.

### Erwan - 11/03
**Animation de l'épée** du joueur. L'épée est créé via une seconde entité qui accède directement à la position 
du joueur pour le suivre. Création d'un état `State` qui permet de gérer l'attaque du joueur. 

### Erwan - 18/03
Ajout des arrières plans. On utilise des *decor* pour créer les arrières plans. Création d'un système `real_time`
 qui est appelé à intervalle régulier pour les actions nécessitant du temps réel.

### Erwan - 24/03
**Ajout effet parallax** sur l'arrière plan. On réduit la vitesse du décalage des arrières plans par rapport à la 
caméra. Création d'un composant parallax pour chaque objet. Les arrières plans sont découpés en plusieurs parties 
avec des vitesses différentes.

### Erwan - 25/03
La taille des images a été optimisé afin d'optimiser la vitesse de chargement des données notamment en javascript.

### Erwan - 29/03
Trvail sur l'arrêt de la caméra au bout de la map. L'arrêt est calculé en fonction de la largeur de la largeur 
de la map. Par défaut largeur de 60. Attention si changement de taille de la map, il est necéssaire de l'indiquer 
avec la création d'un objet d'identifiant *1000* avec le paramètre width.
La taille des blocs s'adapte maintenant à la largeur de la fenêtre. La fenêtre contient **16 blocs de largeur**.
La hauteur est donc relative à la hauteur des blocs. 
**ATTENTION** : La largeur de la fenêtre doit être un multiple de 16. Si 
cette condition n'est pas respectée les arrondis sur les flottants vont créer des espaces visibles.

#### Note importante
J'ai pu remarquer que `real_time` provoque une réduction non négligeable des performances du jeu (SDL et JavaScript). Cela est notamment dû au nombre d'appels trop élevé. Je vais travailler à l'adaptation de la 
fréquence d'appels en fonction des tâches effectuées. 
**De plus** j'ai pu remarquer que le système `ennemy` fait exactement la même chose que le système `real_time` 
à la différence que les fonctions appelées ne sont pas les mêmes. Il serait préférable de regrouper tout dans le 
système `real_time`.