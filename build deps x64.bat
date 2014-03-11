call "C:\Program Files (x86)\Microsoft Visual Studio 12.0\Vc\vcvarsall.bat" amd64

cd src

cd zlib
C:\MinGW\msys\1.0\bin\patch.exe -N -p1 < ..\..\patches\zlib_001.patch
C:\MinGW\msys\1.0\bin\patch.exe -N -p1 < ..\..\patches\zlib_002.patch
nmake -f win32/Makefile.msc clean
nmake -f win32/Makefile.msc zlib.lib
copy /Y zlib.lib ..\..\sys-x64\lib\zlib.lib
copy /Y zconf.h ..\..\sys-x64\include
copy /Y zlib.h ..\..\sys-x64\include
cd ..


cd lame
#Edit Makefile.MSVC
# replace /machine:I386 with /machine:X64
# remove /opt:NOWIN98 

#if we use ASM=yes there are linker problems when trying to use the lib (even if we edit nasm options)
nmake -f Makefile.MSVC clean CPU=P3 ASM=no COMP=MS MSVCVER=Win64
nmake -f Makefile.MSVC all CPU=P3 ASM=no COMP=MS MSVCVER=Win64
copy /Y include\lame.h ..\..\sys-x64\include\lame\
copy /Y output\libmp3lame-static.lib ..\..\sys-x64\lib\mp3lame.lib
cd ..

cd ..