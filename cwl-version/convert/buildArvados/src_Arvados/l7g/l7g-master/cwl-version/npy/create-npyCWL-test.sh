#!/bin/bash
#
# Make numpy vectors on a tile path basis
# for the pgp set (


#export cgb="/data-sdd/cwl_tiling/npy/cgb"
#export indir="/data-sdd/data/cgf-test"
#export band2matrix="/data-sdd/cwl_tiling/npy/band-to-matrix-npy"
#export makelist="/data-sdd/cwl_tiling/npy/create-list"

export cgb=$1
export indir=$2
export band2matrix=$3
export makelist=$4

export cpnylib="/data-sdd/cwl_tiling/npy/lib/cnpy"
export odir="./testnpy"
export SHELL=/bin/bash

mkdir -p tmp
mkdir -p $odir

find $indir/*.cgf > cgf_list

function process_tile {
  tilepath=$1

  h=`printf '%03x' $tilepath`

  rm -f tmp/$h.tmp

  for ifn in `cat cgf_list` ; do

    #echo $ifn
    $cgb -i $ifn -k -p $tilepath -s 0 -L >> tmp/$h.tmp

  done

  #cat tmp/$h.tmp | LD_LIBRARY_PATH=`pwd`/lib/cnpy $band2matrix $h $odir/$h
  echo "cat tmp/$h.tmp | LD_LIBRARY_PATH=$cpnylib $band2matrix $h $odir/$h"
  cat tmp/$h.tmp | LD_LIBRARY_PATH=$cpnylib $band2matrix $h $odir/$h

  exit

}
export -f process_tile

## DEBUG
for tp in {0..862} ; do
  echo $tp
done | head -n1 | parallel --no-notice --max-procs 10 process_tile {}
exit

for tp in {0..862} ; do
  echo $tp
done | parallel --no-notice --max-procs 10 process_tile {}

$makelist cgf_list $odir/names.npy
mv $odir/names.npy $odir/names

