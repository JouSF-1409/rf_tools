#!/bin/zsh
#set -x

eventDir=../dat_gmt/event_filt.gmtdat
c1=107;c2=37;range=120
cat> center.dat <<EOF
${c1} ${c2}
EOF

image_size=12c
# this is for NWES outside the circle
half_size=6.3c
outer=-W0.07p

gmt begin event120_full_nc png,pdf

    # set a basemap
    gmt coast -Rg -JE${c1}/${c2}/$range/${image_size} \
    -A10000 -W1/0.2p\
    -G#9AFF9A -S#A4D3EE -Cgray\
    -Xc -Yc

    # plot station point
    gmt plot -St0.2c -Gred center.dat

    # plot eventlist
    gmt plot -Sc0.2c ${outer} -Gred ${eventDir}

    # plot circle for 30* 60* and outer side
    gmt plot -S-${image_size} center.dat
    gmt plot -Sy${image_size} center.dat
    #30 deg
    gmt plot -Sc3c -W0.7p center.dat
    gmt plot -Sc6c -W0.7p center.dat
    gmt plot -Sc9c -W0.7p center.dat
    gmt plot -Sc12c -W3p center.dat

    # text of degree on map
    echo "${c1}  ${c2}"| awk '{print $1"  "$2"   30\n"}' | gmt text -N -D0.2c/1.3c
    echo "${c1}  ${c2}"| awk '{print $1"  "$2"   60\n"}' | gmt text -N -D0.2c/2.8c
    echo "${c1}  ${c2}"| awk '{print $1"  "$2"   90\n"}' | gmt text -N -D0.2c/4.3c
    echo "${c1}  ${c2}"| awk '{print $1"  "$2"   120\n"}' | gmt text -N -D0.23c/5.8c

    # NSWE in 4 directions
    echo "${c1}  ${c2}"| awk '{print $1"  "$2"   N\n"}' | gmt text -N -D0c/${half_size}
    echo "${c1}  ${c2}"| awk '{print $1"  "$2"   S\n"}' | gmt text -N -D0c/-${half_size}
    echo "${c1}  ${c2}"| awk '{print $1"  "$2"   W\n"}' | gmt text -N -D-${half_size}c/0c
    echo "${c1}  ${c2}"| awk '{print $1"  "$2"   E\n"}' | gmt text -N -D${half_size}c/0c

gmt end

rm center.dat
