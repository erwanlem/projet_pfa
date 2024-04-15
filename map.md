# Documentation - Structure des fichiers de niveau

Les fichiers sont constitués d'une suite de lignes qui permettent d'ajouter des éléments sur une map.
Les lignes ont la structure suivante:

**id_bloc** : **pos_x** x **pos_y** | **l**x**L** | **paramètres**



## Les identifiants de bloc

|Identifiant|Bloc|Descriptions|Paramètres|
|:-----------:|:----:|------------|----------|
|0|Plateforme|Une plateforme simple qui permet des déplacements au dessus du sol| - |
|1|Tremplin|Une plateforme qui permet de sauter plus haut| - |
|2|Bloc de mort| Un bloc qui tue le joueur lorsqu'il est en collision avec| - |
|3|Sol| Un bloc utilisé pour le sol| - |
|4|Mur| Un bloc permettant de créer un mur| - |
|5|Element de décor| Crée un élément de décor qui n'a aucun effet sur le joueur| - |
|6|Fall box|La box tombe par gravité lorsque le joueur entre en collision avec| - |
|7|Hidden box|La box apparait seulement lorsque le joueur entre en collision avec| - |
|10|Bloc changement de niveau|Change de niveau lorsque le bloc est en collision avec le joueur|*destination*: le lien de niveau de destination|
|19|Élément textuel|Création d'un bloc de texte| - |
|20|Bloc bouton|Crée un bouton avec un texte et un lien utilisé lorsqu'on clique dessus|*link*: le fichier de destination|
|21|Caméra|Crée une caméra. **Attention**, utiliser seulement s'il n'y a pas de joueur| - |
|22|Background|Fond fixe pour le menu|-|
|23|Audio|Création d'un audio utilisant une liste de musiques prédéfinies|`track` l'identifiant de la track|
|24|Opening|Création d'un opening pour le niveau|`level` le niveau correspondant à l'opening|
|100|Joueur| Crée un joueur ainsi qu'une caméra qui suit le joueur. Les dimensions données sont ignorées car le joueur est de taille fixe| - |
|101|Archer| Permet de créer un ennemi de type archer| - |
|102|Knight| Création d'un chevalier| - |
|103|Alexandre| Création du boss final| - |
|200|Medkit| Création d'un élément de soin | - |
|1000|Définition de paramètres|Définir une configuration personnalisé pour un niveau|`width` la largeur en blocs de la map|


Les différents paramètres utilisables sont:
- *color* : une des couleurs prédéfinies. La liste des couleurs disponibles est red, green, blue, transparent, white, black, pink
- *texture* : le chemin vers un fichier de texture
- *texture_x* : la position x sur le fichier de texture (par bloc de taille 64). Exemples : 0 donne la position 0, 1 donne la position 64, 2 pour 128, etc... 
- *texture_y* : la position y sur le fichier de texture (par bloc de taille 64). Exemples : 0 donne la position 0, 1 donne la position 64, 2 pour 128, etc... 
- *texture_w* : la largeur sur le fichier de texture (par bloc de taille 64). Exemples : 1 donne la largeur 64, 2 pour 128, etc... 
- *texture_h* : la hauteur sur le fichier de texture (par bloc de taille 64). Exemples : 1 donne la hauteur 64, 2 pour 128, etc... 
- *animation* : le nombre de frame à récupérer sur un fichier animation


## Textures

Sources : https://opengameart.org/content/art-from-platforge