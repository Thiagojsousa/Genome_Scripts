#!/bin/bash

set -x

r1=/data/lgcm/ufpa_ufmg/montagens_salmonella/sc/BCW_4233_1.fastq
r2=/data/lgcm/ufpa_ufmg/montagens_salmonella/sc/BCW_4233_2.fastq
input=/data/lgcm/ufpa_ufmg/montagens_salmonella/sc/04-sspace-long-reads/scaffolds.fasta
lib=sc
aligner=bwa
insert=500
std=0.75
orientation=FR
sspace=/home/fmiranda/bin/SSPACE-STANDARD-3.0_linux-x86_64/SSPACE_Standard_v3.0.pl
gapfiller=/home/fmiranda/bin/GapFiller_v1-10_linux-x86_64/GapFiller.pl
threads=12

echo "$lib $aligner $r1 $r2 $insert $std $orientation 1" > library-sspace.txt
echo "$lib $aligner $r1 $r2 $insert $std $orientation" > library-gapfiller.txt

perl $sspace -l library-sspace.txt -s $input -k 5 -a 0.7 -x 1 -m 30 -o 20 -T $threads -b sspace

for i in `seq 1 100`;
do
        echo "Iteration $i"
        perl $gapfiller -l library-gapfiller.txt -s sspace/sspace.final.scaffolds.fasta -T $threads -b gapfiller
        rm -rf sspace
        perl $sspace -l library-sspace.txt -s gapfiller/gapfiller.gapfilled.final.fa -k 5 -a 0.7 -x 1 -m 30 -o 20 -T $threads -b sspace
        rm -rf gapfiller
done
perl $gapfiller -l library-gapfiller.txt -s sspace/sspace.final.scaffolds.fasta -T $threads -b gapfiller
