FROM ucsb/rstudio-base:latest

LABEL maintainer="LSIT Systems <lsitops@ucsb.edu>"

USER root

RUN apt-get update && \
    apt-get install -y texlive-full lmodern python3-dev libbz2-dev libxt-dev nano texlive-xetex texlive-fonts-recommended texlive-plain-generic bsdmainutils && \
    apt-get clean

RUN pip install \
    cvxpy \
    csvkit \
    geopandas \
    jupyter-cache \
    jupyterlab-quarto \
    matplotlib \
    otter-grader \
    pyarrow \
    rapidfuzz \
    statsmodels \
    seaborn \
    scipy \
    scikit-learn \
    tabulate \
    umap-learn \
    yfinance \
    pyarrow \
    geopandas \
    folium ; \
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu; \
    pip install tensorflow-cpu

RUN conda install -y -c conda-forge \
    jupyterlab_rise \
    altair \
    beautifulsoup4 \
    keras \
    r-glmnet \
    r-keras \
    r-reticulate \
    r-rocr \
    r-spotifyr \
    r-torch

# Install from CRAN to avoid R Downgrades
RUN R -e "install.packages(c('caret', 'coop', 'curl', 'data.table', 'dplyr', 'EBImage', 'ggplot2', 'httr', 'httr2', 'imager', 'janitor', 'jsonlite', 'leaflet', 'lubridate', 'magick', 'OpenImageR', 'plotly', 'polite', 'purrr', 'quanteda', 'ranger', 'readr', 'recommenderlab', 'recosystem', 'robotstxt', 'RSelenium', 'rvest', 'scales', 'skimr', 'spacyr', 'stringr', 'tensorflow', 'text', 'text2vec', 'textdata', 'tidymodels', 'tidyr', 'tidytext', 'tm', 'tokenizers', 'wordcloud', 'xml2', 'xgboost', 'yardstick'), repos = 'https://cloud.r-project.org/', Ncpus = parallel::detectCores())"

ENV TZ America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN /usr/local/bin/fix-permissions "${CONDA_DIR}" || true

USER $NB_USER
