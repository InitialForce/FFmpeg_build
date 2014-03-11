call "C:\Program Files (x86)\Microsoft Visual Studio 12.0\Vc\vcvarsall.bat" x86

cd src

cd zlib
#Edit win32/Makefile.msc so that it uses -MT instead of -MD, since this is how FFmpeg is built as well.
#Edit zconf.h and remove its inclusion of unistd.h. This gets erroneously included when building FFmpeg.
nmake -f win32/Makefile.msc zlib.lib
copy /Y zlib.lib ..\..\sys-x86\bin
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
