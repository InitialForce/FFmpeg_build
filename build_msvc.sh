#!/bin/sh

arch=x86
archdir=x86
shortarch=x86
clean_build=true
debug=true
dir_suffix="d"
build_suffix="-if"
ffmpeg_dir="src/FFmpeg"
ffmpeg_ver=`head -1 ${ffmpeg_dir}/VERSION`

for opt in "$@"
do
    case "$opt" in
        x86)
            shortarch=x86
            ;;
        x64 | amd64) 
            arch=x86_64
            archdir=x64
            shortarch=x64
            ;;
        quick)
            clean_build=false
            ;;
        debug)
            debug=true
            dir_suffix="d"
            ;;
        release)
            debug=false
            dir_suffix=""
            ;;
        *)
            echo "Unknown Option $opt"
            exit 1
    esac
done

ffmpeg_build_dir=build_FFmpeg_${ffmpeg_ver}_${shortarch}${dir_suffix}
install_dir=install_FFmpeg_${ffmpeg_ver}_${shortarch}${dir_suffix}

sysdir=$(readlink -f sys-${shortarch})

make_build_dir() (
if [ ! -d ${ffmpeg_build_dir} ]; then
    mkdir -p "${ffmpeg_build_dir}"
fi
)

clean() (
make distclean > /dev/null 2>&1
)

configure() (
OPTIONS="
--prefix=../${install_dir}		\
    --toolchain=msvc                \
    --disable-static                \
    --enable-shared                 \
    --enable-version3               \
    --enable-libmp3lame				\
    --enable-zlib					\
    --yasmexe=../tools/yasm-1.3.0-win64.exe \
    --build-suffix=${build_suffix}  \
    --arch=${arch}"

EXTRA_CFLAGS="-D_WIN32_WINNT=0x0502 -DWINVER=0x0502 -MDd -I${sysdir}/include"

EXTRA_LDFLAGS="-NODEFAULTLIB:libcmt \
    ${sysdir}/lib/zlib.lib \
    ${sysdir}/lib/mp3lame.lib \
    -LIBPATH:${sysdir}/lib/"

if $debug ; then
    OPTIONS="$OPTIONS --enable-debug"
else
    OPTIONS="$OPTIONS --disable-debug"
fi 

sh ../${ffmpeg_dir}/configure ${OPTIONS} --extra-cflags="${EXTRA_CFLAGS}" --extra-ldflags="${EXTRA_LDFLAGS}"
)

build() (
echo Building
make 
)

install() (
echo Installing
make install
)

copy_symbols() (
cp lib*/*.pdb ../${install_dir}/bin
)

echo Building ffmpeg using MSVC ...

#make_dirs

make_build_dir

cp misc/makedef ${ffmpeg_build_dir}
cp misc/c99conv.exe ${ffmpeg_build_dir}
cp misc/c99wrap.exe ${ffmpeg_build_dir}

cd ${ffmpeg_build_dir}

if $clean_build ; then
    #clean

    ## run configure, redirect to file because of a msys bug
    configure > config.out 2>&1
    CONFIGRETVAL=$?

    ## show configure output
    cat config.out
fi

## Only if configure succeeded, actually build
if ! $clean_build || [ ${CONFIGRETVAL} -eq 0 ]; then
    build &&
        install && copy_symbols
fi

cd ..
