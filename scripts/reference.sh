#!/bin/bash
# reference.sh
# bas.tolhuis@genalice.com
#   prepare GRF and GRI prior to mapping
#------------------------------------------------------------------------------
# reference assemblies
assembly=GRCh37.p13.genome
fasta=references/$assembly.fa
altfile=references/G$assembly.alt

#------------------------------------------------------------------------------
# GRF/GRI files
# create grf
gaReference
        --input=$fasta \
        --output=references/$assembly.grf \
        --alt_file=$altfile \
        --report_file=log/$assembly.gareference.log \
        --error_file=log/$assembly.gareference.err
                
 # create gri
 gaIndex \
        --input=references/$assembly.grf \
        --output=references/$assembly.gri \
        --report_file=log/$assembly.gaindex.log \
        --error_file=log/$assembly.gaindex.err
                
#------------------------------------------------------------------------------
