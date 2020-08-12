FROM rocker/r-ver:3.6.3
RUN apt-get update && apt-get install -y  git-core imagemagick libjpeg-dev libcurl4-openssl-dev libgit2-dev libpng-dev libssh2-1-dev libssl-dev libxml2-dev libudunits2-dev libpq-dev make pandoc pandoc-citeproc zlib1g-dev && rm -rf /var/lib/apt/lists/*
RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl')" >> /usr/local/lib/R/etc/Rprofile.site
RUN R -e 'install.packages("remotes")'
RUN R -e 'remotes::install_github("r-lib/remotes", ref = "97bbf81")'
RUN Rscript -e 'remotes::install_version("pkgload",upgrade="never", version = "1.1.0")'
RUN Rscript -e 'remotes::install_version("shiny",upgrade="never", version = "1.5.0")'
RUN Rscript -e 'remotes::install_version("xts",upgrade="never", version = "0.12-0")'
RUN Rscript -e 'remotes::install_version("config",upgrade="never", version = "0.3")'
RUN Rscript -e 'remotes::install_version("shinyBS",upgrade="never", version = "0.61")'
RUN Rscript -e 'remotes::install_version("reshape",upgrade="never", version = "0.8.8")'
RUN Rscript -e 'remotes::install_version("dygraphs",upgrade="never", version = "1.1.1.6")'
RUN Rscript -e 'remotes::install_version("wesanderson",upgrade="never", version = "0.3.6")'
RUN Rscript -e 'remotes::install_version("data.table",upgrade="never", version = "1.13.0")'
RUN Rscript -e 'remotes::install_version("DT",upgrade="never", version = "0.14")'
RUN Rscript -e 'remotes::install_version("shinydashboard",upgrade="never", version = "0.7.1")'
RUN Rscript -e 'remotes::install_version("golem",upgrade="never", version = "0.2.1")'
RUN Rscript -e 'remotes::install_github("Rosalien/toolboxMeteosol@90d4c16ec3193286b09ccc3c7023b46a8b930d50")'
RUN mkdir /build_zone
ADD . /build_zone
WORKDIR /build_zone
RUN R -e 'remotes::install_local(upgrade="never")'
EXPOSE 80
CMD R -e "options('shiny.port'=80,shiny.host='0.0.0.0');meteosolApp::run_app()"
