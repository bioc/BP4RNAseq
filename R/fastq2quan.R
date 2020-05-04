#' Produce the quantifications of gene expression based on the fastq files.
#'
#' Produce the quantifications of gene expression based on the fastq files with alignment-based and alignment-free workflows.
#'
#'@param threads the number of threads to be used. Default is 4.
#'@param dir the working directory. Default is the current working directory.
#'@param pair "single" for single-end (SE) or "paired" for paired-end (PE) reads.
#'@param taxa the scientific or common name of the organism.
#'@param novel_transcript logic, whether identifying novel transcripts is expected or not. Default is FALSE.
#'@export fastq2quan
#'@return None
#'@examples
#'\dontrun{
#'
#'down2quan(threads = 4, dir = getwd(), "sesame", novel_transcript = FALSE)
#'}

fastq2quan <- function(threads = 4, dir = getwd(), pair, taxa, novel_transcript = FALSE) {
  setwd(dir)

  quality <- qc_test(threads)

  if(length(quality[[1]]$sample)) cat("Adapter exists!\n")
  if(length(quality[[2]]$sample)) cat("Per base sequence quality failed!\n")
  if(length(quality[[3]]$sample)) cat("Per sequence quality scores failed!\n")

  ### quality trimming
  if(length(quality[[2]]$sample)|length(quality[[3]]$sample)) {
    print("Trim low quality bases.")
    quality_trim(quality[[2]]$sample, quality[[3]]$sample, pair)### consider if add directory parameter.
    if(length(quality[[1]]$sample)) {
      print("Trim the adapter.")
      adapter_trim(quality[[1]]$sample, pair)
    }
  }

  if(length(quality[[1]]$sample)) {
    print("Trim the adapter.")
    quality_trim(quality[[1]]$sample, quality[[1]]$sample, pair)### consider if add directory parameter.
    adapter_trim(quality[[1]]$sample, pair)
  }
  files <- list.files(dir, pattern = "fastqc", full.names = F)
  unlink(files)

  down_Ref(taxa)
  reference <- extract_genome(taxa)
  align_ge(pair, taxa, reference[1], reference[2])
  trans_ass(novel_transcript = FALSE) ### remove FALSE later.
  trans_quan()
  align_free_quan(pair, reference[1], reference[3], reference[2])
}