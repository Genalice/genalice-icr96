#!/bin/bash
# map.sh
# bas.tolhuis@genalice.com
#   read mapping for 96 samples of ICR96 dataset
#------------------------------------------------------------------------------
# reference assembly
assembly=GRCh37.p13.genome

# input fastq file list
list=`ls json/*.json`

#------------------------------------------------------------------------------
# select reference and idex files
grf=references/$assembly.grf
gri=references/$assembly.gri
        
# bed file describing captured regions of TruSight Cancer panel
bed_file=bed/$assembly/capture.bed

# start named server
gaServer \
        --server_name=$assembly \
        --index=$gri \
        --reference=$grf \
        --report_file=log/$assembly.gaserver.log \
        --error_file=log/$assembly.gaserver.err
        
# loop over input file list
for myJson in ${list[@]}
do
        # sample name
        sample=`basename $myJson .json`
                
        # client: alignment job per sample
        gaMap \
                --server_name=$assembly \
                --input=json/$myJson \
                --output=gar_files/$assembly/$sample.gar \
                --cmd_file=configs/human.map.exome.conf \
                --alt_score_bias=0.9 \
                --capture_bed_file=$bed \
                --report_file=log/$sample.mapping.trc \
                --error_file=log/$sample.mapping.err
                        
done
        
# stop named server
gaMap --server_name=$assembly --stop_server

#------------------------------------------------------------------------------
