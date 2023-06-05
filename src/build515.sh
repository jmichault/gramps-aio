# install prerequisites :
## prerequisites in msys packages :
pacman -Sy --noconfirm mingw-w64-x86_64-python-pip mingw-w64-x86_64-python3-bsddb3 mingw-w64-x86_64-gexiv2 mingw-w64-x86_64-ghostscript mingw-w64-x86_64-python3-cairo mingw-w64-x86_64-python3-gobject mingw-w64-x86_64-python3-icu mingw-w64-x86_64-iso-codes mingw-w64-x86_64-hunspell mingw-w64-x86_64-hunspell-en mingw-w64-x86_64-enchant perl-XML-Parser intltool mingw-w64-x86_64-python3-lxml mingw-w64-x86_64-python3-jsonschema mingw-w64-x86_64-gtkspell3 mingw-w64-x86_64-geocode-glib mingw-w64-x86_64-python3-pillow git mingw-w64-x86_64-graphviz mingw-w64-x86_64-goocanvas mingw-w64-x86_64-osm-gps-map base-devel mingw-w64-x86_64-toolchain subversion mingw-w64-x86_64-db mingw-w64-x86_64-python-bsddb3 mingw-w64-x86_64-graphviz mingw-w64-x86_64-python-graphviz mingw-w64-x86_64-osm-gps-map mingw-w64-x86_64-nsis mingw-w64-x86_64-python-cx-freeze  mingw-w64-x86_64-python3-requests mingw-w64-x86_64-enchant mingw-w64-x86_64-adwaita-icon-theme mingw-w64-x86_64-python-networkx mingw-w64-x86_64-python-psycopg2 upx mingw-w64-x86_64-python-packaging unzip mingw-w64-x86_64-python3-nose
python3  -m pip install --upgrade pip
## prerequisites in pip packages
pip3 install --upgrade pydot pydotplus requests asyncio
## berkeley db, from sources
mkdir  ~/build
cd ~/build
wget https://github.com/bpisoj/MINGW-packages/releases/download/v5.0/mingw-w64-x86_64-db-6.0.30-1-any.pkg.tar.xz
pacman -U --noconfirm mingw-w64-x86_64-db-6.0.30-1-any.pkg.tar.xz
pacman -S --noconfirm mingw-w64-x86_64-python3-bsddb3
## pygraphviz, from sources
wget  https://gramps-project.org/wiki/images/2/2b/Pygraphviz-1.4rc1.zip
mkdir pygraphviz-1.4rc1
cd pygraphviz-1.4rc1
unzip ../Pygraphviz-1.4rc1.zip
MINGW_INSTALLS=mingw64 makepkg-mingw -sLf
pacman -U --noconfirm mingw-w64-x86_64-python3-pygraphviz-1.4rc1-0.0-any.pkg.tar.zst
## 
cd ~
git clone https://github.com/jmichault/gramps-aio.git
tar --directory /c/msys64/mingw64/share/ -zxf ~/gramps-aio/src/share.tgz

# install gramps 5.1.5 from sources
mkdir ~/grampsdev
cd ~/grampsdev
git init
git remote add -t master -f origin https://github.com/gramps-project/gramps.git
git checkout v5.1.5
python3 setup.py build
python3 setup.py install

# build aio
cd ~/gramps-aio/src
python3 setup.py build_exe --no-compress
makensis mingw64/src/grampsaio64.515.nsi

# result is in mingw64/src
