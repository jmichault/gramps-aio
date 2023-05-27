# gramps-aio

quelques notes sur la création d'une installation gramps-AIO 64 bits pour windows.  
à tester car en partie composé de notes prises a posteriori.   

Je me suis basé sur les deux documents suivants :  

source 1 : <https://www.gramps-project.org/wiki/index.php/Gramps_for_Windows_with_MSYS2>  
Note 1 : il ne faut pas installer msys/gcc !!!  
Note 2 : l'installation de fontconfig ne marche plus. On s'en passe, les symboles généalogiques ne seront pas disponibles.  
  
source 2 : <https://www.gramps-project.org/wiki/index.php/Building_Gramps_AIO_cx_freeze-based>  
Note 1 : J'ai utilisé le cx_freeze fourni par msys2, non patché (la plupart des modifications du patch sont intégrées dans le cx_freeze actuel). ça simplifie grandement le processus. J'ai modifié les sources en conséquence.  
Note 2 : J'ai aussi modifié les sources pour inclure les modules requests, asyncio et pip.  
Note 3 : J'ai déplacé les DLLs et EXEs secondaires dans le dossier lib, et modifié les sources en conséquence.

## installation de msys2 (durée : environ 15 minutes)

En bref :
* charger msys2 depuis le site <https://www.msys2.org/> .
* installer avec les options par défaut. 
* lancer "MSYS2 MINGW64"
* mettre à jour : ` pacman -Syuu `  (à faire deux fois par précaution).
* installer les paquets désirés :

```
pacman -Sy --noconfirm mingw-w64-x86_64-python-pip mingw-w64-x86_64-python3-bsddb3 mingw-w64-x86_64-gexiv2 mingw-w64-x86_64-ghostscript mingw-w64-x86_64-python3-cairo mingw-w64-x86_64-python3-gobject mingw-w64-x86_64-python3-icu mingw-w64-x86_64-iso-codes mingw-w64-x86_64-hunspell mingw-w64-x86_64-hunspell-en mingw-w64-x86_64-enchant perl-XML-Parser intltool mingw-w64-x86_64-python3-lxml mingw-w64-x86_64-python3-jsonschema mingw-w64-x86_64-gtkspell3 mingw-w64-x86_64-geocode-glib mingw-w64-x86_64-python3-pillow git mingw-w64-x86_64-graphviz mingw-w64-x86_64-goocanvas mingw-w64-x86_64-osm-gps-map base-devel mingw-w64-x86_64-toolchain subversion mingw-w64-x86_64-db mingw-w64-x86_64-python-bsddb3 mingw-w64-x86_64-graphviz mingw-w64-x86_64-python-graphviz mingw-w64-x86_64-osm-gps-map mingw-w64-x86_64-nsis mingw-w64-x86_64-python-cx-freeze  mingw-w64-x86_64-python3-requests mingw-w64-x86_64-enchant mingw-w64-x86_64-adwaita-icon-theme mingw-w64-x86_64-python-networkx mingw-w64-x86_64-python-psycopg2 upx mingw-w64-x86_64-python-packaging unzip mingw-w64-x86_64-python3-nose
python3  -m pip install --upgrade pip
pip3 install --upgrade pydot pydotplus requests asyncio
```

* mettre à jour Berkeley db (facultatif)

```
mkdir  ~/build
cd ~/build
wget https://github.com/bpisoj/MINGW-packages/releases/download/v5.0/mingw-w64-x86_64-db-6.0.30-1-any.pkg.tar.xz
pacman -U --noconfirm mingw-w64-x86_64-db-6.0.30-1-any.pkg.tar.xz
pacman -S --noconfirm mingw-w64-x86_64-python3-bsddb3
```
* installer pygraphviz

```
mkdir  ~/build
cd ~/build
wget  https://gramps-project.org/wiki/images/2/2b/Pygraphviz-1.4rc1.zip
mkdir pygraphviz-1.4rc1
cd pygraphviz-1.4rc1
unzip ../Pygraphviz-1.4rc1.zip
MINGW_INSTALLS=mingw64 makepkg-mingw -sLf
pacman -U --noconfirm mingw-w64-x86_64-python3-pygraphviz-1.4rc1-0.0-any.pkg.tar.zst
```

* récupérer certains fichiers manquants (icônes et dictionnaires)

```
wget https://github.com/jmichault/gramps-aio/raw/main/src/share.tgz
tar --directory /c/msys64/mingw64/share/ -zxf share.tgz
```


## installation de gramps depuis les sources (durée : environ 3 minutes)

```
mkdir ~/grampsdev
cd ~/grampsdev
git init
git remote add -t master -f origin https://github.com/gramps-project/gramps.git
git checkout v5.1.5
python3 setup.py build
python3 setup.py install
```

tester : ` python3 Gramps.py `  
  
vous pouvez aussi créer un raccourci pour lancer gramps dans cette installation :
* commande à éxécuter : `C:\msys64\mingw64.exe bash -c "cd ~/grampsdev;python Gramps.py"`


## génération du paquet AIO (durée : environ 15 minutes)
### créer le dossier de travail
```
mkdir ~/aio
```
### y déposer les fichiers source
Copier tous les fichiers du dossier src.


### construire le paquet

```
cd ~/aio
python3 setup.py build_exe --no-compress
makensis ~/aio/mingw64/src/grampsaio64.nsi
```
 
Et voilà ! Le résultat se trouve dans mingw64/src .
