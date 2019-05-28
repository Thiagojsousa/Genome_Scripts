#!/bin/bash
#
#
# Written by: Leandro Gomes Alves, Federal University of Minas Gerais (UFMG), 
#   Laboratory of Celular and Molecular Genetics, Brazil
# Adapted by: Thiago de Jesus Sousa, for use in gbk2fasta.pl. Some University and Laboratory. 
#
# Date Written: Oct 02, 2018 - Mar 29, 2019.

i=1
for gbffFile in *.gbff; do
    name="${gbffFile%.*}"
    echo "Processando ${name}..."
	perl gbff2gbk.pl "$gbffFile"
	let i++
done

    mkdir gbk_Files
    mv *.gbk gbk_Files
