# ---- Data extraction and cleanup for vizgvar ---- #

# Data obtained from: http://www.ensembl.org/biomart/martview/
# NOTICE: to run this code certain packages are required!
# see http://www.ensembl.org/info/data/biomart/biomart_r_package.html

# libraries
library(biomaRt)
library(dplyr)
library(jsonlite)

# querying the data
ensembl = useEnsembl(biomart="ensembl", dataset="hsapiens_gene_ensembl")
all.transcripts <- getBM(attributes=c('ensembl_gene_id','ensembl_peptide_id','external_transcript_name',
                                      'description'), mart = ensembl)

# getting only entries with a valid peptide id
all.peptides <- all.transcripts %>% dplyr::select(-ensembl_gene_id) %>% dplyr::filter(ensembl_peptide_id != '')

# changing header names for json creation
colnames(all.peptides) <- c('protein_id', 'protein', 'description')

json <- toJSON(all.peptides)
cat(json)
write(json, 'proteins.json')