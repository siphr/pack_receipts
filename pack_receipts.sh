#!/bin/sh

# Requirements:
# * ImageMagick
# * bash
#
# pack_receipts.sh <front_img> <back_img> <convert_valid_crop> <convert_valid_scale> <output_file_with_extension>
# ~/work/pack_receipts/pack_receipts.sh 201808-0040.png 201808-0041.png 800x1150+8 800x640 test.png


in0=$1
in1=$2
crop_prm=$3
scale_prm=$4
out=$5

#echo $crop_prm
#echo $scale_prm

# zero-padding indices
echo "Processing: $in0 $in1"

# crop the image scans to the give resolution
convert "${in0}" -crop $crop_prm "/tmp/crop1"
convert "${in1}" -crop $crop_prm "/tmp/crop2"

# merge and down scale
convert /tmp/crop1 /tmp/crop2 +append /tmp/crop
convert /tmp/crop -scale $scale_prm $out
