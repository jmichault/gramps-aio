'''
 Use with:
 python3 setup.py build_exe --no-compress -O1
'''
import sys
import os
import site
import subprocess
import tempfile
import atexit
import shutil
import zipfile
import cx_Freeze
from gramps.version import VERSION_TUPLE
try:
    from gramps.version import VERSION_QUALIFIER
except:
    VERSION_QUALIFIER = ''
UPX_ALT_PATH = r'UPX'

#import logging
#logging.basicConfig(level=logging.DEBUG)
VQ = {'-alpha1': 10, '-alpha2': 11, '-alpha3': 12,
      '-beta1': 21, '-beta2': 22, '-beta3': 23,
      '-rc1': 22, '': 0}

VERSION = ('.'.join(map(str, VERSION_TUPLE)) + '.' +
           str(VQ.get(VERSION_QUALIFIER, 99)))
COPYRIGHT="Copyright 2020, Gramps developers.  GNU General Public License"
# Prepare a temporay directory
TEMP_DIR = tempfile.TemporaryDirectory()
atexit.register(TEMP_DIR.cleanup)
BASE_DIR = os.path.split(sys.prefix)[1]
SETUP_DIR = os.path.dirname(os.path.realpath(__file__))
SETUP_FILES = ['setup.py', 'gramps.ico', 'grampsc.ico', 'grampsd.ico',
               'grampsaioc.py', 'grampsaiocd.py', 'grampsaiow.py']
if '32' in BASE_DIR:
    SETUP_FILES.append(''.join(('grampsaio', '32', '.nsi')))
else:
    SETUP_FILES.append(''.join(('grampsaio', '64', '.nsi')))

INCLUDE_DLL_PATH = os.path.join(sys.exec_prefix, 'bin')
INCLUDE_FILES = []
INCLUDES = ['gi', 'cgi', 'colorsys', 'site']
PACKAGES = ['gi', 'cairo', 'xml', 'bsddb3', 'lxml', 'PIL', 'json', 'csv',
            'sqlite3', 'cProfile', 'networkx', 'psycopg2', 'requests', 'logging'
            , 'html', 'compileall' ]
EXCLUDES = ['tkinter', 'PyQt5', 'PyQt5.QtCore', 'PyQt5.QtGui', 'pyside'
            'PyQt5.QtWidgets', 'sip', 'lib2to3', 'PIL.ImageQt', 'pip', 'distlib'
            ]

REPLACE_PATHS = [('*', 'AIO/'),
                 ('C:/msys64/mingw32/lib/python3.10/site-packages/'
                  'cx_freeze-5.0-py3.6-mingw.egg/cx_Freeze', 'cx_Freeze/'),
                 ('C:/msys64/mingw64/lib/python3.10/site-packages/'
                  'cx_freeze-5.0-py3.6-mingw.egg/cx_Freeze', 'cx_Freeze/')
                 ]
MISSING_DLL = ['libgtk-3-0.dll', 'libgtkspell3-3-0.dll', 'libgexiv2-2.dll',
               'libgoocanvas-3.0-9.dll', 'libosmgpsmap-1.0-1.dll',
               'gswin32c.exe', 'dot.exe', 'libgvplugin_core-6.dll',
               'libgvplugin_dot_layout-6.dll', 'libgvplugin_gd-6.dll',
               'libgvplugin_pango-6.dll', 'libgvplugin_rsvg-6.dll',
               'glib-compile-schemas.exe',
               'gdk-pixbuf-query-loaders.exe', 'gtk-update-icon-cache-3.0.exe',
               'fc-cache.exe', 'fc-match.exe', 'gspawn-win64-helper-console.exe',
               'gspawn-win64-helper.exe', 'libgeocode-glib-0.dll',
               'zlib-cpython-36m.dll'
               ]
BIN_EXCLUDES = ['Qt5Core.dll', 'gdiplus.dll', 'gdiplus']

from os.path import dirname, basename
import lib2to3
lib23_path = dirname(lib2to3.__file__)
INCLUDE_FILES.append((lib23_path, 'lib/lib2to3'))
import pip
libpip_path = dirname(pip.__file__)
INCLUDE_FILES.append((libpip_path,'lib/pip'))
import distlib
libdistlib_path = dirname(distlib.__file__)
INCLUDE_FILES.append((libdistlib_path,'lib/distlib'))


#import fontconfig
#lib_file = basename(fontconfig.__file__)
#INCLUDE_FILES.append((fontconfig.__file__, lib_file))

os.makedirs(os.path.join(BASE_DIR, 'var/cache/fontconfig'), exist_ok=True)
for file in SETUP_FILES:
    INCLUDE_FILES.append((os.path.join(SETUP_DIR, file),
                         os.path.join('src', file)))
for dll in MISSING_DLL:
    INCLUDE_FILES.append((os.path.join(INCLUDE_DLL_PATH, dll), dll))
MISSING_LIBS = ['lib/enchant-2', 'lib/gdk-pixbuf-2.0', 'lib/girepository-1.0',
                'share/enchant', 'share/glib-2.0/schemas',
                'share/xml/iso-codes', 'etc/gtk-3.0',
                'etc/ssl/certs', 'etc/ssl/cert.pem', 'etc/fonts', 'lib/gio',
                'share/gramps', 'share/doc/gramps', 'share/icons/gnome',
                'share/icons/hicolor', 'share/icons/gramps.png',
                'share/icons/Adwaita/icon-theme.cache',
                'share/icons/Adwaita/index.theme', 'share/hunspell'
                ]
ADWAITA = ['8x8', '16x16', '22x22', '24x24', '32x32', '48x48', '64x64',
           '96x96', 'cursors'
           ]
for adw in ADWAITA:
    INCLUDE_FILES.append((os.path.join(sys.prefix, 'share/icons/Adwaita', adw),
                         os.path.join('share/icons/Adwaita', adw)))
for lib in MISSING_LIBS:
    INCLUDE_FILES.append((os.path.join(sys.prefix, lib), lib))

LANGUAGES = ['ar', 'bg', 'ca', 'cs', 'da', 'de', 'el', 'en_GB', 'eo', 'es',
             'fi', 'fr', 'he', 'hr', 'hu', 'is', 'it', 'ja', 'lt', 'nb', 'nl',
             'nn', 'pl', 'pt_BR', 'pt_PT', 'ru', 'sk', 'sl', 'sq', 'sr', 'sv',
             'tr', 'uk', 'vi', 'zh_CN', 'zh_HK', 'zh_TW']
TRANSLATED = ['gtk30.mo', 'gtk30-properties.mo', 'gtkspell3.mo', 'iso_639.mo',
              'iso_3166.mo', 'gramps.mo', 'glib20.mo', 'glib-networking.mo'
              ]
for lang in LANGUAGES:
    for tran in TRANSLATED:
        inpath = os.path.join(sys.prefix, 'share', 'locale', lang,
                              'LC_MESSAGES', tran)
        if os.path.exists(inpath):
            INCLUDE_FILES.append((inpath, os.path.join('share', 'locale', lang,
                                                       'LC_MESSAGES', tran)))

GRAMPS = os.path.join(site.getsitepackages()[0], 'gramps')
INCLUDE_FILES.append(GRAMPS)
#EXECUTABLES = [cx_Freeze.Executable("grampsaioc.py", base="Console_Opt",
#                                    targetName='gramps.exe',
#                                    icon='grampsc.ico', copyright=COPYRIGHT),
#               cx_Freeze.Executable("grampsaiow.py", base="Win32GUI_Opt",
#                                    targetName='grampsw.exe',
#                                    icon='gramps.ico', copyright=COPYRIGHT),
#               cx_Freeze.Executable("grampsaiocd.py", base="Console",
#                                    targetName='grampsd.exe',
#                                    icon='grampsd.ico', copyright=COPYRIGHT)
#              ]
EXECUTABLES = [cx_Freeze.Executable("grampsaioc.py", base="Console",
                                    targetName='gramps.exe',
                                    icon='gramps.ico', copyright=COPYRIGHT),
               cx_Freeze.Executable("grampsaiow.py", base="Win32GUI",
                                    targetName='grampsw.exe',
                                    icon='gramps.ico', copyright=COPYRIGHT),
               cx_Freeze.Executable("grampsaiocd.py", base="Console",
                                    targetName='grampsd.exe',
                                    icon='grampsd.ico', copyright=COPYRIGHT)
               ]
BUILD_EXE_OPTIONS = {'packages':PACKAGES,
                     'includes':INCLUDES,
                     'excludes':EXCLUDES,
                     'include_files':INCLUDE_FILES,
                     'bin_includes':MISSING_DLL,
                     'zip_include_packages': '*', #ZIP_INCLUDE_PACKAGES,
                     'zip_exclude_packages':EXCLUDES,
                     'bin_excludes':BIN_EXCLUDES,
                     'replace_paths':REPLACE_PATHS,
                     'build_exe':BASE_DIR,
                    }
BDIST_MSI_OPTIONS = { #uuid.uuid5(uuid.NAMESPACE_DNS, 'GrampsAIO64-5-trunk')
    'upgrade_code': '{fbccc04b-7b2e-56d3-8bb7-94d5f68de822}',
    #uuid.uuid5(uuid.NAMESPACE_DNS, 'v5.0.0-alpha1-476-g473d3aa')
    'product_code': '{48304362-2945-5a10-ad60-241f233be4d2}',
    'add_to_path': False,
    #'initial_target_dir': r'[ProgramFilesFolder]\%s\%s' %
    #(company_name, product_name),
    }
cx_Freeze.setup(
    name="GrampsAIO32" if '32' in BASE_DIR else "GrampsAIO64",
    options={"build_exe": BUILD_EXE_OPTIONS, 'bdist_msi': BDIST_MSI_OPTIONS},
    version=VERSION,
    description="Gramps Genealogy software",
    long_description=VERSION_QUALIFIER,
    executables=EXECUTABLES)

ZIN = zipfile.ZipFile(os.path.join(BASE_DIR, 'lib/library.zip'), 'r')
ZOUT = zipfile.ZipFile(os.path.join(BASE_DIR, 'lib/python310x.zip'), 'w')
for item in ZIN.infolist():
    if not os.path.dirname(item.filename).startswith('gramps'):
        #if '/test' in item.filename or 'test/' in item.filename:
        #    print("Zip Excluded:", item.filename)
        #else:
        print("Zip Included:", item.filename)
        buffer = ZIN.read(item.filename)
        ZOUT.writestr(item, buffer)
ZOUT.close()
ZIN.close()
shutil.move(os.path.join(BASE_DIR, 'lib/python310x.zip'),
            os.path.join(BASE_DIR, 'lib/library.zip'))

if os.path.isfile(UPX_ALT_PATH):
    UPX = UPX_ALT_PATH
else:
    WHICH = 'where' if os.name == 'nt' else 'which'
    try:
        subprocess.check_call([WHICH, 'UPX'])
    except subprocess.CalledProcessError:
        UPX = None
    else:
        UPX = 'upx'
if UPX is not None:
    ARGS = [UPX, '-7', '--no-progress']
    ARGS.extend(os.path.join(BASE_DIR, filename) for filename in
                os.listdir(BASE_DIR) if filename == 'name' or
                os.path.splitext(filename)[1].lower() in
                ('.exe', '.dll', '.pyd', '.so') and
                os.path.splitext(filename)[0].lower() not in
                ('libgcc_s_dw2-1', 'gramps', 'grampsw', 'grampsd',
                 'libwinpthread-1'))
    subprocess.call(ARGS)
else:
    print("\nUPX not found")
