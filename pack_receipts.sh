#!/bin/sh

# Requirements:
# * ImageMagick
# * bash
# * duplex scan in pairs e.g: rec0000.jpg rec0001.png
#   * paired indices are essential
#
# pack_receipts.sh <directory_containing_scans> <image_format> <prefix> <convert_valid_crop> <convert_valid_scale>

source_dir=$1
source_ext=$2
source_pfx=$3
crop_prm=$4
scale_prm=$5
output_dir="${source_dir}/output"

count=`ls $source_dir/$source_pfx*.$source_ext | wc -l`

#echo $crop_prm
#echo $scale_prm

index=1
for (( i=0; i<$count; i+=2 )) ; do
    # zero-padding indices
    printf -v k "%04d" $((i))
    printf -v j "%04d" $((i+1))
    printf -v sindex "%04d" $((index))
    echo "Processing: $k $j"

    # crop the image scans to the give resolution
    convert "${source_dir}/$source_pfx-*${k}.$source_ext" -crop $crop_prm "/tmp/crop1.$source_ext"
    convert "${source_dir}/$source_pfx-*${j}.$source_ext" -crop $crop_prm "/tmp/crop2.$source_ext"

    mkdir -p "${output_dir}"
    # merge and down scale
    convert /tmp/crop1.$source_ext /tmp/crop2.$source_ext +append /tmp/$source_pfx-$index.$source_ext
    convert /tmp/$source_pfx-$index.$source_ext -scale $scale_prm $output_dir/$source_pfx-scaled-$sindex.$source_ext
    ((index+=1))
done
