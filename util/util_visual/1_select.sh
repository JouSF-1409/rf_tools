#!/bin/bash
# 202305 by xyf
# visually check wave form using SAC

dir=`pwd`
wkdir=${dir}/1_rot/
tempdir=${dir}/1_waste/
mkdir -p $tempdir
cd ${wkdir}
#rm state.lst
#echo "working in ${wkdir}"

all=`ls -d 20*`
list=`cut -f1 ./state.lst`
#list=`cat ./state.lst|awk '{print $1}'>temp.dat`
#for dir in `echo -e "${all} ${list}"|sort|uniq -u`
for dir in `echo "${all}\n${list}"|sort|uniq -u`
do
    echo "working in ${dir}"
    cd ${wkdir}/${dir}/
    event_num=`ls *z|wc -l`
    echo "this dir has ${event_num} traces"
    #awk '{print "r *.z\nqdp off\nppk p 6"}END{print "q"}'|sac
#sachd t4 -12345 f *z >& /dev/null
    #sachd t1 60 f *[zrt] >&/dev/null
sac<<EOF>&/dev/null
rh *.z;ch t1 60;wh;
r *z
qdp off
rglitches;
rtrend;rmean;taper;
bp n 4 c 0.05 2
ppk p 6
wh
q
EOF

    read -p "keep?" state
    if [ ${state} == no ]
    then
        cd ${wkdir}
        mv -f ${wkdir}/${dir} ${tempdir}
    else
        echo "${dir}    ${state}">>${wkdir}/state.lst
        mkdir -p ${tempdir}/${dir}
        for files in `saclst t1 t4 f *z| awk '{if($3<300 && $3-$2>0){print $1}}'`
        do
            filename=`echo ${files}|awk -F. '{print $1"."$2"."$3}'`
            echo ${filename}
            mv ${filename}* ${tempdir}/${dir}
        done
    fi
    cd ${wkdir}
    all=`ls -d 20*|wc -l`
    done=`cat state.lst|wc -l`
    rest=`echo "${all}-${done}"|bc`
    echo "${rest} ahead, keep working!!"
done
