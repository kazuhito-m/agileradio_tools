#!/bin/bash

# agileradio* directory archiveing.
for i in  $(find ./ite* -type d -name 'agileradio_ite0*'| grep -v 'interchange') ; do 7za a $i.7z $i ; done

# fixed directory archiveing.
for i in $( find ./ite* -name 'fixed') ; do 7za a $i.7z $i ; done
