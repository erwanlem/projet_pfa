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
|10|Bloc changement de niveau|Change de niveau lorsque le bloc est en collision avec le joueur|*destination*: le lien de niveau de destination|
|20|Bloc bouton|Crée un bouton avec un texte et un lien utilisé lorsqu'on clique dessus|*link*: le fichier de destination|
|21|Caméra|Crée une caméra. **Attention**, utiliser seulement s'il n'y a pas de joueur| - |
|100|Joueur| Crée un joueur ainsi qu'une caméra qui suit le joueur. Les dimensions données sont ignorées car le joueur est de taille fixe| - |
|101|Archer| Permet de créer un ennemi de type archer |-|-|



## Textures

Sources : https://opengameart.org/content/art-from-platforge