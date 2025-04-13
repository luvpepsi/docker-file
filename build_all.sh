#!/bin/bash
set -e
AAA=/tmp/convert_src
cd /tmp
tar xvf convert_src.tar.gz
cd ./convert_src
###############
yum install -y --setopt=tsflags=nodocs gcc make zlib-devel glibc-devel fontconfig
tar xf freetype-2.4.10.tar.gz
cd freetype-2.4.10
./configure
make && make install
cd "${AAA}"

###############
tar xf jpegsrc.v8c.tar.gz
cd jpeg-8c
./configure
make && make install
cd "${AAA}"

##############
yum install -y  --setopt=tsflags=nodocs gcc-c++ automake libjpeg-devel giflib-devel
# 临时刷新动态库,找到安装的freetype
ldconfig  /usr/local/lib
# 永久生效
echo "/usr/local/lib" > /etc/ld.so.conf.d/local-lib.conf
ldconfig
# 修改lib/types.h
tar xf swftools-0.9.2.tar.gz
cd swftools-0.9.2
mv -f /tmp/convert_src/types.h ./lib/types.h
./configure
make && make install || true
rm -f /usr/local/share/swftools/swfs/default_viewer.swf
ln -s /usr/local/share/swftools/swfs/simple_viewer.swf /usr/local/share/swftools/swfs/default_viewer.swf
cd "${AAA}"

#############
mkdir /usr/xpdf && tar xf xpdf-chinese-simplified.tar.gz -C /usr/xpdf
mv /usr/xpdf/xpdf-chinese-simplified /usr/xpdf/chinese-simplified
cp gbsn00lp.ttf.gz gkai00mp.ttf.gz /usr/xpdf/chinese-simplified/CMap/
gunzip /usr/xpdf/chinese-simplified/CMap/gbsn00lp.ttf.gz
gunzip /usr/xpdf/chinese-simplified/CMap/gkai00mp.ttf.gz
sed -i '/^toUnicodeDir/a \
displayCIDFontTT\tAdobe-GB1\t/usr/xpdf/chinese-simplified/CMap/gbsn00lp.ttf\
displayCIDFontTT\tAdobe-GB1\t/usr/xpdf/chinese-simplified/CMap/gkai00mp.ttf' /usr/xpdf/chinese-simplified/add-to-xpdfrc
cd "${AAA}"

############
yum install -y --setopt=tsflags=nodocs libtool
tar xf  yasm-1.3.0.tar.gz
cd yasm-1.3.0
./configure --enable-shared --prefix=/usr
make && make install
cd "${AAA}"
###
tar xf lame-3.99.5.tar.gz
cd lame-3.99.5
./configure --enable-shared --prefix=/usr
make && make install
cd "${AAA}"
###
tar xf libogg-1.3.2.tar.gz
cd libogg-1.3.2
./configure --prefix=/usr
make && make install
cd "${AAA}"
###
yum install libogg-devel -y --setopt=tsflags=nodocs
tar xf libvorbis-1.3.5.tar.gz
cd libvorbis-1.3.5
./configure --prefix=/usr
make && make install
cd "${AAA}"
###
tar xf xvidcore_1.3.3.orig.tar.gz
cd ./xvidcore/build/generic/
./configure --prefix=/usr
make && make install
cd "${AAA}"
###
yum install -y bzip2 --setopt=tsflags=nodocs
tar xf x264-snapshot-20141218-2245-stable.tar.bz2
cd x264-snapshot-20141218-2245-stable
./configure --prefix=/usr --enable-shared --enable-pic
make && make install
cd "${AAA}"
###
tar xf libdca-0.0.5.tar.bz2 
cd libdca-0.0.5
./configure --prefix=/usr
make && make install
cd "${AAA}"
###
tar xf fdk-aac_0.1.3+20140816.orig.tar.gz 
cd fdk-aac-0.1.3/
./configure --enable-shared --prefix=/usr
make && make install
cd "${AAA}"
###
echo "/usr/lib" >> /etc/ld.so.conf
echo "/usr/lib64" >> /etc/ld.so.conf
/sbin/ldconfig

###
tar xf ffmpeg-2.6.3.tar.bz2
cd ffmpeg-2.6.3
cd ..
mv ffmpeg-2.6.3 ffmpeg
yum install -y --setopt=tsflags=nodocs SDL SDL-devel
mkdir -p /usr/local/ffmpeg
cd ffmpeg
./configure \
--prefix=/usr/local/ffmpeg \
--enable-gpl --enable-shared \
--enable-libmp3lame --enable-libfdk-aac \
--enable-nonfree --enable-libvorbis \
--enable-libxvid --enable-libx264 \
--enable-pthreads --disable-ffserver --disable-ffplay
make && make install

cp -r /usr/local/ffmpeg/include/* /usr/include/
cp -r /usr/local/ffmpeg/lib/*.* /usr/lib/
echo "/usr/local/ffmpeg/lib" > /etc/ld.so.conf.d/ffmpeg.conf
/sbin/ldconfig
cd "${AAA}"
###
tar xf freetype-2.6.tar.gz
cd freetype-2.6
./configure --prefix=/usr
make && make install
cd "${AAA}"

###
tar xf MPlayer-1.0rc4.tar.bz2
cd MPlayer-1.0rc4
./configure \
--prefix=/usr/local/mplayer/ \
--enable-freetype --codecsdir=/usr/lib/codes/ \
--libdir=/usr/lib/wincodes/ \
--language=zh_CN
make && make install
###
mkdir -p /usr/share/fonts/chinese
cp /tmp/chinese/*.ttf /usr/share/fonts/chinese
cp /tmp/chinese/*.ttc /usr/share/fonts/chinese
fc-cache -f
