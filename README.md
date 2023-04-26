# gramps-aio

quelques notes sur la création d'une installation gramps-AIO 64 bits pour windows
Attention : notes prises a posteriori, pas testées. Il y a surement des erreurs.   

## installation de msys2
source : <https://www.gramps-project.org/wiki/index.php/Gramps_for_Windows_with_MSYS2>  
Note 1 : il ne faut pas installer msys/gcc !!!  
Note 2 : l'installation de fontconfig ne marche plus. On s'en passe.  

En bref :
* charger msys2 depuis le site <https://www.msys2.org/> . J'ai pris msys2-x86_64-20230318.exe
* installer msys2. 
* lancer "MSYS2 MINGW64"
* mettre à jour : ` pacman -Syuu `
* installer les paquets nécessaires :

```
pacman -Sy mingw-w64-x86_64-python-pip mingw-w64-x86_64-python3-bsddb3 mingw-w64-x86_64-gexiv2 mingw-w64-x86_64-ghostscript mingw-w64-x86_64-python3-cairo mingw-w64-x86_64-python3-gobject mingw-w64-x86_64-python3-icu mingw-w64-x86_64-iso-codes mingw-w64-x86_64-hunspell mingw-w64-x86_64-hunspell-en mingw-w64-x86_64-enchant perl-XML-Parser intltool mingw-w64-x86_64-python3-lxml mingw-w64-x86_64-python3-jsonschema mingw-w64-x86_64-gtkspell3 mingw-w64-x86_64-geocode-glib mingw-w64-x86_64-python3-pillow git mingw-w64-x86_64-graphviz mingw-w64-x86_64-goocanvas mingw-w64-x86_64-osm-gps-map base-devel mingw-w64-x86_64-toolchain subversion mingw-w64-x86_64-db mingw-w64-x86_64-python-bsddb3 mingw-w64-x86_64-graphviz mingw-w64-x86_64-python-graphviz mingw-w64-x86_64-osm-gps-map mingw-w64-i686-nsis mingw-w64-x86_64-python-cx-freeze
pip3 install --upgrade pydotplus pip requests asyncio gedcomx-v1
```

* mettre à jour Berkeley db (facultatif)

```
mkdir  ~/build
cd ~/build
wget https://github.com/bpisoj/MINGW-packages/releases/download/v5.0/mingw-w64-x86_64-db-6.0.30-1-any.pkg.tar.xz
pacman -U mingw-w64-x86_64-db-6.0.30-1-any.pkg.tar.xz
pacman -S --noconfirm mingw-w64-x86_64-python3-bsddb3
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

## génération du paquet AIO
source : <https://www.gramps-project.org/wiki/index.php/Building_Gramps_AIO_cx_freeze-based>
# créer le dossier de travail
```
mkdir ~/aio
```
# y déposer les fichiers source
Ceux-ci peuvent etre récupérés depuis une installation AIO, ou depuis le dossier src de ce site.

# récupérer certains fichiers depuis une installation AIO
Liste non exhaustive ...

```
cp -p /c/GrampsAIO64-5.1.5/zlib-cpython-36m.dll C:/msys64/mingw64/bin/
cp -Rp /c/GrampsAIO64-5.1.5/share/enchant/myspell C:/msys64/mingw64/share/enchant/
cp -Rp /c/GrampsAIO64-5.1.5/share/icons/Adwaita C:/msys64/mingw64/share/icons/
cp -p /c/GrampsAIO64-5.1.5/share/icons/gramps.png C:/msys64/mingw64/share/icons/
```

# construire

```
 python3 setup.py build_exe --no-compress
 makensis ~/aio/mingw64/src/grampsaio64.nsi
 ```
 
 Le résultat se trouve dans mingw64/src
