FROM rocker/r-ver:4.2.2

LABEL maintainer="Adamatics <info@adamatics.com>"

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    && rm -rf /var/lib/apt/lists/*

RUN R -e "install.packages(c('shiny', 'tidyverse', 'gridExtra'))"

RUN echo "local(options(shiny.port = 3838, shiny.host = '0.0.0.0'))" > /usr/local/lib/R/etc/Rprofile.site

RUN addgroup --system app \
    && adduser --system --ingroup app app

WORKDIR /home

COPY app.R .

USER app

EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('/home/app.R')"]