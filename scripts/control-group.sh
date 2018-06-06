#!/bin/bash
# bas.tolhuis@genalice.com
#   script to create GCO file for every target sample
#------------------------------------------------------------------------------
# list all control sample lists
list=`ls controls/*.list`

# loop over list
for gco_list in ${list[@]}
do
        # sample name
        name=`basename $gco_list .list`
        
        # gco filename
        gco_file=controls/$assembly/$name.gco

        # create gco
        gaStructure create \
                $gco_list \
                $gco_file
        

done

#------------------------------------------------------------------------------
