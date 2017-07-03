#!/usr/bin/Rscript

# Instructions coming from https://irkernel.github.io/installation/
install.packages(c('repr', 'IRdisplay', 'evaluate', 'crayon', 'pbdZMQ', 'devtools', 'uuid', 'digest'), repos = c(CRAN = "http://cran-mirror.cs.uu.nl"))
devtools::install_github('IRkernel/IRkernel')

IRkernel::installspec(user = FALSE)
