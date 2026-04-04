FROM ucsb/rstudio-base:latest

LABEL maintainer="LSIT Systems <lsitops@ucsb.edu>"

USER root

RUN apt-get update && \
    apt-get install -y texlive-full lmodern python3-dev libbz2-dev libxt-dev nano texlive-xetex texlive-fonts-recommended texlive-plain-generic bsdmainutils \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip install \
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
    lightfm \
    lxml \
    matplotlib \
    nltk \
    numpy \
    opencv-python-headless \
    pandas \
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
    scikit-learn \
    scipy \
    scrapy \
    seaborn \
    selenium \
    sentence-transformers \
    spacy \
    statsmodels \
    surprise \
    tabulate \
    textblob \
    timm \
    transformers \
    umap-learn \
    wordcloud \
    yfinance ; \
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu; \
    pip install tensorflow-cpu

RUN conda install -y -c conda-forge \
    abseil-cpp \
    altair \
    beautifulsoup4 \
    gdal \
    geos \
    jupyter-cache \
    jupyterlab_rise \
    keras \
    otter-grader \
    pkg-config \
    proj \
    udunits2

# Install from CRAN to avoid R Downgrades
# Added BiocManager to handle EBImage

RUN Rscript -e "install.packages('BiocManager', repos='https://cloud.r-project.org/')" && \
    Rscript -e "BiocManager::install('EBImage', update=FALSE, ask=FALSE)" && \
    Rscript -e "install.packages(c('caret', 'coop', 'curl', 'data.table', 'dplyr', 'ggplot2', 'glmnet', 'httr', 'httr2', 'imager', 'janitor', 'jsonlite', 'leaflet', 'lubridate', 'keras', 'magick', 'OpenImageR', 'plotly', 'polite', 'purrr', 'quanteda', 'ranger', 'raster', 'readr', 'recommenderlab', 'recosystem', 'robotstxt', 'ROCR', 'RSelenium', 'rvest', 's2', 'scales', 'sf', 'skimr', 'spacyr', 'spotifyr', 'stringr', 'terra', 'tensorflow', 'reticulate', 'text', 'text2vec', 'textdata', 'tidymodels', 'tidyr', 'tidytext', 'tm', 'tokenizers', 'torch', 'wordcloud', 'xml2', 'xgboost', 'yardstick'), repos = 'https://cloud.r-project.org/', Ncpus = parallel::detectCores())"

ENV TZ America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN /usr/local/bin/fix-permissions "${CONDA_DIR}" || true

USER $NB_USER
