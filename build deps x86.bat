call "C:\Program Files (x86)\Microsoft Visual Studio 12.0\Vc\vcvarsall.bat" x86

cd src

cd zlib
C:\MinGW\msys\1.0\bin\patch.exe -N -p1 < ..\..\patches\zlib_001.patch
C:\MinGW\msys\1.0\bin\patch.exe -N -p1 < ..\..\patches\zlib_002.patch
nmake -f win32/Makefile.msc clean
nmake -f win32/Makefile.msc zlib.lib
copy /Y zlib.lib ..\..\sys-x86\lib\zlib.lib
copy /Y zconf.h ..\..\sys-x86\include
copy /Y zlib.h ..\..\sys-x86\include
cd ..


cd lame
#Edit Makefile.MSVC
# remove /opt:NOWIN98 

#if we use ASM=yes there are linker problems when trying to use the lib (even if we edit nasm options)
nmake -f Makefile.MSVC clean CPU=P3 ASM=no COMP=MS
nmake -f Makefile.MSVC all CPU=P3 ASM=no COMP=MS 
copy /Y include\lame.h ..\..\sys-x86\include\lame\
copy /Y output\libmp3lame-static.lib ..\..\sys-x86\lib\mp3lame.lib
cd ..

cd ..
