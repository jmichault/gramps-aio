# gramps-aio

quelques notes sur la création d'une installation gramps-AIO 64 bits pour windows.  
script testé avec succès le 5 juin 2023.

Je me suis basé sur les deux documents suivants :  

source 1 : <https://www.gramps-project.org/wiki/index.php/Gramps_for_Windows_with_MSYS2>  
Note 1 : il ne faut pas installer msys/gcc !!!  
Note 2 : l'installation de fontconfig ne marche plus. On s'en passe, les symboles généalogiques ne seront pas disponibles.  
  
source 2 : <https://www.gramps-project.org/wiki/index.php/Building_Gramps_AIO_cx_freeze-based>  
Note 1 : J'ai utilisé le cx_freeze fourni par msys2, non patché (la plupart des modifications du patch sont intégrées dans le cx_freeze actuel). ça simplifie grandement le processus. J'ai modifié les sources en conséquence.  
Note 2 : J'ai aussi modifié les sources pour inclure les modules requests, asyncio et pip.  
Note 3 : J'ai déplacé les DLLs et EXEs secondaires dans le dossier lib, et modifié les sources en conséquence.

## installation de msys2 (durée : environ 5 minutes)

* charger msys2 depuis le site <https://www.msys2.org/> .
* installer avec les options par défaut. 
* lancer "MSYS2 MINGW64"
* mettre à jour : ` pacman -Syuu --noconfirm `  (à faire deux fois).

## construction du paquet AIO 5.1.5 par script (durée : environ 15 minutes)

```
wget https://raw.githubusercontent.com/jmichault/gramps-aio/main/src/build515.sh -O build515.sh
./build515.sh
```

Et voilà ! Le résultat se trouve dans ~/gramps-aio/src/mingw64/src .

