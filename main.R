# ---- Data extraction and cleanup for vizgvar ---- #

# Data obtained from: http://www.ensembl.org/biomart/martview/
# NOTICE: to run this code certain packages are required!
# see http://www.ensembl.org/info/data/biomart/biomart_r_package.html

# libraries
library(biomaRt)
library(dplyr)
library(jsonlite)
library(tools)

# querying the data
ensembl = useEnsembl(biomart="ensembl", dataset="hsapiens_gene_ensembl")
all.transcripts <- getBM(attributes=c('ensembl_peptide_id', 'external_transcript_name', 'transcript_length',
                                      'family_description'), mart = ensembl)

# getting only entries with a valid peptide id
all.peptides <- all.transcripts %>% dplyr::filter(ensembl_peptide_id != '')

# changing header names for json creation
colnames(all.peptides) <- c('protein_id', 'protein', 'trans_length', 'family_description')

# Mixed Case styling for description
.simpleCap <- function(x) {
  s <- strsplit(x, " ")[[1]]
  paste(toupper(substring(s, 1, 1)), substring(s, 2),
        sep = "", collapse = " ")
}

all.peptides$family_description <- tolower(all.peptides$family_description)
all.peptides$family_description <- toTitleCase(all.peptides$family_description)


json <- toJSON(all.peptides)
cat(json)
write(json, 'proteins.json')