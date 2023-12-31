#!/usr/bin/env bash
platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='darwin'
fi

if [[ $platform == 'linux' ]]; then
   wget -O - https://www.anaconda.com/distribution/ 2>/dev/null | sed -ne 's@.*\(https:\/\/repo\.anaconda\.com\/archive\/Anaconda3-.*-Linux-x86_64\.sh\)\">64-Bit (x86) Installer.*@\1@p' | xargs wget
#   wget -O datasets https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/LATEST/linux-amd64/datasets
elif [[ $platform == 'darwin' ]]; then
   wget -O - https://www.anaconda.com/distribution/ 2>/dev/null | sed -ne 's@.*\(https:\/\/repo\.anaconda\.com\/archive\/Anaconda3-.*-MacOSX-x86_64\.sh\)\">64-Bit Command Line Installer.*@\1@p' | xargs wget
#   wget -O datasets https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/LATEST/mac/datasets
fi
chmod +x datasets

find . -name "Anacond*" -exec bash {} \;
find . -name "Anacond*" | xargs rm



echo "conda update -y -n root conda
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --set channel_priority flexible
conda install -y -c bioconda sra-tools
conda install -y -c bioconda entrez-direct
conda install -y -c bioconda fastqc
conda install -y -c bioconda cutadapt
conda install -y -c bioconda samtools
conda install -y -c bioconda hisat2
conda install -y -c bioconda stringtie
conda install -y -c bioconda salmon
# conda config --set channel_priority strict
conda install -y -c conda-forge r-base
conda install -y -c conda-forge r-tidyr
conda install -y -c conda-forge r-stringr
conda install -y -c conda-forge r-dplyr
conda install -y -c conda-forge r-fastqcr
conda install -y -c conda-forge r-devtools
conda update -y --all
# conda config --show-sources
rm use_conda.sh
" > use_conda.sh

chmod +x use_conda.sh

if [[ $platform == 'linux' ]]; then
   source ~/.bashrc
   exec sudo --login --user $USER sh -c 'cd '"$PWD"'; bash'
elif [[ $platform == 'darwin' ]]; then
   exec $(echo $0)
fi
