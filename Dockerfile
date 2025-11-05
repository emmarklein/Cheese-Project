FROM rocker/verse
RUN R -e "install.packages(c('dplyr', 'patchwork', 'stringr', 'tidyr', 'tidyverse', 'ggplot2', 'forcats', 'purrr', 'ggpubr', 'shiny'), repos='https://cloud.r-project.org')"