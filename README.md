# gramps-aio

quelques notes sur la création d'une installation gramps-AIO 64 bits pour windows.  
test avec succès le 26/04/2023.   

source 1 : <https://www.gramps-project.org/wiki/index.php/Gramps_for_Windows_with_MSYS2>  
Note 1 : il ne faut pas installer msys/gcc !!!  
Note 2 : l'installation de fontconfig ne marche plus. On s'en passe, les symboles généalogiques ne seront pas disponibles.  
  
source 2 : <https://www.gramps-project.org/wiki/index.php/Building_Gramps_AIO_cx_freeze-based>  
Note 1 : J'ai utilisé le cx_freeze fourni par msys2, non patché (la plupart des modifications du patch sont intégrées dans le cx_freeze actuel). ça simplifie grandement le processus. J'ai modifié les sources en conséquence.  
Note 2 : J'ai aussi modifié les sources pour inclure les modules requests, asyncio et pip.  

## installation de msys2

En bref :
* charger msys2 depuis le site <https://www.msys2.org/> . J'ai pris msys2-x86_64-20230318.exe
* installer msys2. 
* lancer "MSYS2 MINGW64"
* mettre à jour : ` pacman -Syuu `  (à faire deux fois).
* installer les paquets désirés :

```
pacman -Sy mingw-w64-x86_64-python-pip mingw-w64-x86_64-python3-bsddb3 mingw-w64-x86_64-gexiv2 mingw-w64-x86_64-ghostscript mingw-w64-x86_64-python3-cairo mingw-w64-x86_64-python3-gobject mingw-w64-x86_64-python3-icu mingw-w64-x86_64-iso-codes mingw-w64-x86_64-hunspell mingw-w64-x86_64-hunspell-en mingw-w64-x86_64-enchant perl-XML-Parser intltool mingw-w64-x86_64-python3-lxml mingw-w64-x86_64-python3-jsonschema mingw-w64-x86_64-gtkspell3 mingw-w64-x86_64-geocode-glib mingw-w64-x86_64-python3-pillow git mingw-w64-x86_64-graphviz mingw-w64-x86_64-goocanvas mingw-w64-x86_64-osm-gps-map base-devel mingw-w64-x86_64-toolchain subversion mingw-w64-x86_64-db mingw-w64-x86_64-python-bsddb3 mingw-w64-x86_64-graphviz mingw-w64-x86_64-python-graphviz mingw-w64-x86_64-osm-gps-map mingw-w64-x86_64-nsis mingw-w64-x86_64-python-cx-freeze  mingw-w64-x86_64-python3-requests mingw-w64-x86_64-enchant mingw-w64-x86_64-adwaita-icon-theme mingw-w64-x86_64-python-networkx mingw-w64-x86_64-python-psycopg2 upx mingw-w64-x86_64-python-packaging unzip mingw-w64-x86_64-python3-nose
python3  -m pip install --upgrade pip
pip3 install --upgrade pydotplus requests asyncio gedcomx-v1
```

* mettre à jour Berkeley db (facultatif)

```
mkdir  ~/build
cd ~/build
wget https://github.com/bpisoj/MINGW-packages/releases/download/v5.0/mingw-w64-x86_64-db-6.0.30-1-any.pkg.tar.xz
pacman -U mingw-w64-x86_64-db-6.0.30-1-any.pkg.tar.xz
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
pacman -U mingw-w64-x86_64-python3-pygraphviz-1.4rc1-0.0-any.pkg.tar.zst
```


## installation de gramps depuis les sources

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

## génération du paquet AIO
### créer le dossier de travail
```
mkdir ~/aio
```
### y déposer les fichiers source
Ceux-ci peuvent etre récupérés depuis une installation AIO, ou depuis le dossier src de ce site.

### récupérer certains fichiers depuis une installation AIO

```
cp -Rp /c/GrampsAIO64-5.1.5/share/enchant/myspell C:/msys64/mingw64/share/enchant/
cp -Rp /c/GrampsAIO64-5.1.5/share/icons/gnome C:/msys64/mingw64/share/icons/
cp -Rp /c/GrampsAIO64-5.1.5/share/icons/Adwaita C:/msys64/mingw64/share/icons/
cp -p /c/GrampsAIO64-5.1.5/share/icons/gramps.png C:/msys64/mingw64/share/icons/
```

### construire

```
cd ~/aio
python3 setup.py build_exe --no-compress
makensis ~/aio/mingw64/src/grampsaio64.nsi
```
 
Et voilà ! Le résultat se trouve dans mingw64/src .
