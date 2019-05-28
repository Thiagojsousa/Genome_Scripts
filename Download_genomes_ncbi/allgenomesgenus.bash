#### Para baixar um conjunto de genomas do mesmo gênero no banco de dados do NCBI ####

## Fazer o download do arquivo
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/assembly_summary.txt

## Para selecionar todas Aeromonas com genoma completo e última versão
grep "Aeromonas" assembly_summary.txt | awk -F "\t" '$12=="Complete Genome" && $11=="latest"{print $20}' >ftpdirpaths

## Gerar o arquivo com o caminho final para download dos GBFF (Se quiser baixar outro arquivo é só modificar o sufixo no comando abaixo)
awk 'BEGIN{FS=OFS="/";filesuffix="genomic.gbff.gz"}{ftpdir=$0;asm=$10;file=asm"_"filesuffix;print ftpdir,file}' ftpdirpaths > ftpfilepaths

## Baixar os arquivos
while read -r line; do wget $line; done < ftpfilepaths

## Remover arquivos temporários
rm ftpdirpaths ftpfilepaths








