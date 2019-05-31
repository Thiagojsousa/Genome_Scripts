#!/bin/sh

# Program: manage_contigs.sh
# Description: A straightforward script for help on close gap genome process. 
# Written by: Thiago de Jesus Sousa. Laboratory of Cellular and Molecular Genetics, Brazil.
# Version: 2.0
# Date: 05/31/2019.

# Requirements:
# I: Install programs and scripts ContiguatorF v.2.7.3, movednaa.py v.2, GenomeFinisher v.1.4, RNAmmer and Blast+ 2.9 or higher installed in usr/local/bin path.
# II: In addition to standard requirements such as: Linux Terminal and BioPython.

# Pipeline usage: You only need to change the paths of files and folders. Ex: Ctrl+H > (*key2) by (CpB1)
# key1 - Workspace path (Ex: /home/tsousa/Cpseudo).
# key2 - Name of the folder that will be created to organize the files (Ex: CpB1).
# key3 - The file path of contig or scaffold (Ex: /home/tsousa/Cpseudo/montagens/spades_k121_B1).
# key4 - The reference genome file with full path, format ".fna" (Ex: /home/tsousa/Cpseudo/referencias/genomas_fna/CP026374.1.fna).
# key5 - The reference genome file with full path, format ".gbk" (Ex: /home/tsousa/Cpseudo/referencias/genomas_gbk/CP026374.1.gbk).
# key6 - The first word of the reference genome file header ".fna" (Ex:Corynebacterium).

#1-Managing Folders and Files Generated.
echo "------------------------------------------------------------"
echo "Creating Folders"
cd *key1 
mkdir *key2 && cp *key1/*key3 *key2
cd *key2 && mkdir ContiguatorF GapBlaster GenomeFinisher RNAmmer Final_files
cd *key1/*key2/ContiguatorF && mkdir movednaa && cd movednaa && mkdir ContiguatorF_2

#2-Sorting with the ContiguatorF (ContiguatorF v.2.7.3).
echo "------------------------------------------------------------"
echo "Running the ContiguatorF"
cd *key1/*key2/ContiguatorF
CONTIGuatorF.py \
-c *key1/*key3 \
-r *key1/*key4 \
-g *key1/*key5

#evince *key1/*key2/ContiguatorF/Map_*key6/*.pdf &

#3-Fixing the start of the genome from the dnaA gene, script movednaa.py v.2.
echo "------------------------------------------------------------"
echo "Running the movednaa"
cd *key1/*key2/ContiguatorF/movednaa
python /usr/local/bin/movednaa.py \
*key1/*key2/ContiguatorF/Map_*key6/PseudoContig.fsa \
*key1/*key4

#4-Sorting with the ContiguatorF (ContiguatorF v2.7.3), after movednaa.py.
echo "------------------------------------------------------------"
echo "Running ContiguatorF after movednaa.py"
cd *key1/*key2/ContiguatorF/movednaa/ContiguatorF_2
CONTIGuatorF.py \
-c *key1/*key2/ContiguatorF/movednaa/f2.fasta \
-r *key1/*key4 \
-g *key1/*key5

#evince *key1/*key2/ContiguatorF/movednaa/ContiguatorF_2/Map_*key6/*.pdf &
cp *key1/*key2/ContiguatorF/movednaa/ContiguatorF_2/Map_*key6/*.fsa \
*key1/*key2/GapBlaster

#5-Gap closing with GapBlaster v.1.1.2.
echo "------------------------------------------------------------"
echo "Running GapBlaster"
cd *key1/*key2/GapBlaster
java -jar /usr/local/bin/GapBlaster_v1.1.2.jar

#6-Gap closing with GenomeFinisher v.1.4, after GapBlaster.
echo "------------------------------------------------------------"
echo "Running GenomeFinisher"
cd *key1/*key2/GenomeFinisher
java -jar /usr/local/bin/GenomeFinisher.jar

cp *key1/*key2/GenomeFinisher/out/*.fasta \
*key1/*key2/Final_files
 
cd *key1/*key2/Final_files
mv *.fasta GenomeFinisher_final.fasta

#7-Confirmation of the presence of rRNA clusters by RNAmmer-1.2.
echo "------------------------------------------------------------"
echo "Running o RNAmmer"
cd *key1/*key2/RNAmmer

rnammer -S bac -m lsu,ssu,tsu -xml *key2.xml -gff *key2.gff -h *key2.hmmreport \
< *key1/*key2/Final_files/GenomeFinisher_final.fasta

#8-Sorting with the ContiguatorF with the final file (ContiguatorF v.2.7.3).
echo "------------------------------------------------------------"
echo "Running ContiguatorF"
cd *key1/*key2/Final_files
python /usr/local/bin/CONTIGuatorF.py \
-c *key1/*key2/Final_files/GenomeFinisher_final.fasta \
-r *key1/*key4 \
-g *key1/*key5

#9- Merge of all generated synteny representation.
cd *key1/*key2/Final_files
pdfunite \
*key1/*key2/ContiguatorF/Map_*key6/*.pdf \
*key1/*key2/ContiguatorF/movednaa/ContiguatorF_2/Map_*key6/*.pdf \
*key1/*key2/Final_files/Map_*key6/*.pdf \
Todas_sintenias.pdf

evince *key1/*key2/Final_files/*.pdf &

echo "------------------------------------------------------------"
echo "If the pipeline was useful, give a star on GitHub - https://github.com/Thiagojsousa/Genome_Scripts"
echo "Thanks a lot and Be Happy!"
