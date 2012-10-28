#!/bin/sh

OS_TYPE=$(uname)
CTAGS_BIN=$(which ctags)
QT4_INCLUDES=/usr/include

if [ ! -x $CTAGS_BIN ]; then
    CTAGS_BIN=ctags
fi
if [ "$OS_TYPE" == "Darwin" ]; then
    CTAGS_BIN=/usr/local/bin/ctags
    QT4_INCLUDES=/Users/alex/tools/qt/4.8.3/include
fi

if [ ! -d tags ]; then
    mkdir tags
fi

pushd tags
if [ ! -d cpp_src ]; then
    curl http://www.vim.org/scripts/download_script.php?src_id=9178 > cpp_src.tar.bz2
    tar xfv cpp_src.tar.bz2
fi

$CTAGS_BIN -R --sort=1 --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++ -f cpp cpp_src
$CTAGS_BIN -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++ -f qt4 $QT4_INCLUDES
popd
