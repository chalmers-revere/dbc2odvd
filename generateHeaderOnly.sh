#!/bin/sh

WD=$PWD
cd /tmp && rm -fr gen && mkdir gen && cd gen && \
cantools generate_c_source $WD/$1 && \
HEADER_FILE=$(ls *.h)
SOURCE_FILE=$(ls *.c)
cat $HEADER_FILE | sed -e 's/\(^[^\ \}\#\/\\].*_encode.*\)/inline\ \1/g;s/\(^[^\ \}\#\/\\].*_decode.*\)/inline\ \1/g;s/\(^[^\ \}\#\/\\].*_is_in_range.*\)/inline\ \1/g;s/\(^[^\ \}\#\/\\].*_pack.*\)/inline\ \1/g;s/\(^[^\ \}\#\/\\].*_unpack.*\)/inline\ \1/g' > $HEADER_FILE.mod && cat $SOURCE_FILE >> $HEADER_FILE.mod && cat $HEADER_FILE.mod > $WD/${HEADER_FILE}pp && \
cluon-msc --cpp $WD/$2 >> $WD/${HEADER_FILE}pp
