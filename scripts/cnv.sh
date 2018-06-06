#!/bin/bash
# cnvs.sh
# bas.tolhuis@genalice.com
#   script to call cnvs with gaStructure
#------------------------------------------------------------------------------
# bed file describing captured regions of TruSight Cancer panel
bed_file=bed/capture.bed

# all gco files
list=`ls controls/*.gco`

# loop over every gco file (one per target sample)
for gco_file in ${list[@]}
do
        # target name
        target=`basename $gco_list .list`

        # output files
        gar_file=gar_files/$target.gar
        cnv_file=cnv_files/$target-filter_z${zscore}.cnv
        cap_file=cnv_files/$target-filter_z${zscore}.captured.cnv

        # run gastructure cnv
        gaStructure cnv \
                $gco_file \
                $gar_file \
                --output=$cnv_file \
                --base_include=0.01-2.2 \
                --cnv_exclude=0.75-1.25 \
                --min_gain_zscore=4.7 \
                --min_loss_zscore=4.7 \
                --zscore_handling=FILTER \
                --tab_separator

        # transform cnv output to temporary bed file
        grep '^chr' $flt_file > temp.bed

        # intersect temp bed with captured regions to get capture only cnvs
        bedtools intersect -wb -a $bed_file -b temp.bed \
                > $cap_file

        rm temp.bed

done

#------------------------------------------------------------------------------
