FROM ucsb/rstudio-base:latest

LABEL maintainer="LSIT Systems <lsitops@ucsb.edu>"

USER root

RUN apt-get update && \
    apt-get install -y \
    bsdmainutils \
    libbz2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libxt-dev \
    lmodern \
    nano \
    python3-dev \
    texlive-fonts-recommended \
    texlive-full \
    texlive-plain-generic \
    texlive-xetex && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN conda install -y -c conda-forge \
    altair \
    beautifulsoup4 \
    jupyter-cache \
    jupyterlab_rise \
    keras \
    numpy \
    otter-grader \
    pandas \
    pkg-config \
    r-leaflet \
    scikit-learn \
    scipy \
    udunits2

RUN python3 -m pip install --no-cache-dir \
    aiohttp \
    albumentations \
    annoy \
    bokeh \
    cvxpy \
    csvkit \
    faiss-cpu \
    folium \
    gensim \
    geopandas \
    httpx \
    implicit \
    jupyterlab-quarto \
    lxml \
    matplotlib \
    nltk \
    opencv-python-headless \
    pillow \
    playwright \
    plotly \
    polars \
    pyarrow \
    python-dateutil \
    pytz \
    rapidfuzz \
    regex \
    requests \
    scrapy \
    seaborn \
    selenium \
    sentence-transformers \
    spacy \
    statsmodels \
    tabulate \
    textblob \
    timm \
    transformers \
    umap-learn \
    wordcloud \
    yfinance && \
    python3 -m pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu && \
    python3 -m pip install --no-cache-dir tensorflow-cpu

# Install from CRAN to avoid R Downgrades
RUN export PKG_CONFIG_PATH=/opt/conda/lib/pkgconfig:$PKG_CONFIG_PATH && \
    export LD_LIBRARY_PATH=/opt/conda/lib:$LD_LIBRARY_PATH && \
    export PROJ_DATA=/opt/conda/share/proj && \
    export PROJ_LIB=/opt/conda/share/proj && \
    Rscript -e "install.packages('BiocManager', repos='https://cloud.r-project.org/')" && \
    Rscript -e "BiocManager::install('EBImage', update=FALSE, ask=FALSE)" && \
    Rscript -e "install.packages(c('caret', 'coop', 'curl', 'data.table', 'dplyr', 'ggplot2', 'glmnet', 'httr', 'httr2', 'imager', 'janitor', 'jsonlite', 'lubridate', 'keras', 'magick', 'OpenImageR', 'plotly', 'polite', 'purrr', 'quanteda', 'ranger', 'raster', 'readr', 'recommenderlab', 'recosystem', 'robotstxt', 'ROCR', 'RSelenium', 'rvest', 'scales',  'skimr', 'spacyr', 'spotifyr', 'stringr', 'tensorflow', 'reticulate', 'text', 'text2vec', 'textdata', 'tidymodels', 'tidyr', 'tidytext', 'tm', 'tokenizers', 'torch', 'wordcloud', 'xml2', 'xgboost', 'yardstick'), repos = 'https://cloud.r-project.org/', Ncpus = parallel::detectCores())"

ENV TZ America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN /usr/local/bin/fix-permissions "${CONDA_DIR}" || true

USER $NB_USER
