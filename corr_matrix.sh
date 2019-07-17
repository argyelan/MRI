#!/bin/bash

low=$3 #Range of intensities
high=$4
for ((i = $low ; i <= $high; i++))
do
    3dmaskave -q -mrange ${i} ${i} -mask $1 $2> image$i.csv 
    #Create correlation matrix for each intensity
done
