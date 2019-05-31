#!/bin/sh


# Program: manage_contigs.sh
# Description: A simple script for help on close gap genome process. 
# Written by: Thiago de Jesus Sousa. Laboratory of Cellular and Molecular Genetics, UFMG, Brazil.
# Version: 2.2
# Date: 05/31/2019.

# Requirements:
# I: Install programs and scripts ContiguatorF v.2.7.3, movednaa.py v.2, GenomeFinisher v.1.4, RNAmmer and Blast+ 2.9 installed in usr/local/bin path.
# II: In addition to standard requirements such as: Linux Terminal and BioPython v.1.73.

# Pipeline usage: You only need to change the paths of files and folders on the variable box.
# key1 - Workspace full path.
# key2 - Name of the folder that will be created to organize the files.
# key3 - The file path of contig or scaffold (Inside Workspace path).
# key4 - The reference genome path, format ".fna" (Inside Workspace path).
# key5 - The reference genome path, format ".gbk" (Inside Workspace path).
# key6 - The first word of the reference genome file header, ".fna".

set -v

#Variable box:
key1=/home/thiagojs/montagem/B64
key2=AH_B64
key3=B64_Scaffold_SSPACE_GapFIller/B64_gapfiller.gapfilled.final.fa
key4=B64_Scaffold_SSPACE_GapFIller/MX16A_GCF_001895965.fna
key5=B64_Scaffold_SSPACE_GapFIller/NZ_CP018201.gbk
key6=Aeromonas

#1-Managing folders and files generated.
echo "------------------------------------------------------------"
echo "Creating Folders"
cd $key1 
mkdir $key2 && cp $key1/$key3 $key2
cd $key2 && mkdir ContiguatorF GapBlaster GenomeFinisher RNAmmer Final_files
cd $key1/$key2/ContiguatorF && mkdir movednaa && cd movednaa && mkdir ContiguatorF_2

#2-Sorting with the ContiguatorF.
echo "------------------------------------------------------------"
echo "Running the ContiguatorF"
cd $key1/$key2/ContiguatorF
CONTIGuatorF.py \
-c $key1/$key3 \
-r $key1/$key4 \
-g $key1/$key5

evince $key1/$key2/ContiguatorF/Map_$key6/*.pdf &

#3-Fixing the start of the genome from the dnaA gene, script movednaa.py v.2.
echo "------------------------------------------------------------"
echo "Running the movednaa"
cd $key1/$key2/ContiguatorF/movednaa
python /usr/local/bin/movednaa.py \
$key1/$key2/ContiguatorF/Map_$key6/PseudoContig.fsa \
$key1/$key4

#4-Sorting with the ContiguatorF, after movednaa.py.
echo "------------------------------------------------------------"
echo "Running ContiguatorF after movednaa.py"
cd $key1/$key2/ContiguatorF/movednaa/ContiguatorF_2
CONTIGuatorF.py \
-c $key1/$key2/ContiguatorF/movednaa/f2.fasta \
-r $key1/$key4 \
-g $key1/$key5

evince $key1/$key2/ContiguatorF/movednaa/ContiguatorF_2/Map_$key6/*.pdf &

cp $key1/$key2/ContiguatorF/movednaa/ContiguatorF_2/Map_$key6/*.fsa \
$key1/$key2/GapBlaster

#5-Gap closing with GapBlaster.
echo "------------------------------------------------------------"
echo "Running GapBlaster"
cd $key1/$key2/GapBlaster
java -jar /usr/local/bin/GapBlaster_v1.1.2.jar

#6-Gap closing with GenomeFinisher v.1.4, after GapBlaster.
echo "------------------------------------------------------------"
echo "Running GenomeFinisher"
cd $key1/$key2/GenomeFinisher
java -jar /usr/local/bin/GenomeFinisher.jar

cp $key1/$key2/GenomeFinisher/out/*.fasta \
$key1/$key2/Final_files
 
cd $key1/$key2/Final_files
mv *.fasta GenomeFinisher_final.fasta

#7-Confirmation of the presence of rRNA clusters by RNAmmer-1.2.
echo "------------------------------------------------------------"
echo "Running RNAmmer"
cd $key1/$key2/RNAmmer

rnammer -S bac -m lsu,ssu,tsu -xml $key2.xml -gff $key2.gff -h $key2.hmmreport \
< $key1/$key2/Final_files/GenomeFinisher_final.fasta

#8-Sorting with the ContiguatorF with the final file.
echo "------------------------------------------------------------"
echo "Running ContiguatorF"
cd $key1/$key2/Final_files
python /usr/local/bin/CONTIGuatorF.py \
-c $key1/$key2/Final_files/GenomeFinisher_final.fasta \
-r $key1/$key4 \
-g $key1/$key5

#9- Merge of all generated synteny representation.
cd $key1/$key2/Final_files
pdfunite \
$key1/$key2/ContiguatorF/Map_$key6/*.pdf \
$key1/$key2/ContiguatorF/movednaa/ContiguatorF_2/Map_$key6/*.pdf \
$key1/$key2/Final_files/Map_$key6/*.pdf \
Todas_sintenias.pdf

evince $key1/$key2/Final_files/*.pdf &

echo "------------------------------------------------------------"
echo "If the pipeline was useful, give a star on GitHub - https://github.com/Thiagojsousa/Genome_Scripts"
echo "Thanks a lot and Be Happy!"
