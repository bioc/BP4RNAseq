% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sra2fastq.R
\name{sra2fastq}
\alias{sra2fastq}
\title{Convert SRA format to fastq format and return the sequencing type, i.e., single-end (SE) or paired-end (PE) reads.}
\usage{
sra2fastq(threads = 4)
}
\arguments{
\item{threads}{the number of threads to be used. Default is 4.}
}
\value{
A string indicates single-end (SE) or paired-end (PE) reads.
}
\description{
Convert all SRA files to fastq files and return the sequencing type, i.e., single-end (SE) or paired-end (PE) reads.
}
\examples{

sra_download(accession = 'SRR11427582')
sra2fastq()

}
