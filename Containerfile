FROM ucsb/rstudio-base:latest

LABEL maintainer="LSIT Systems <lsitops@ucsb.edu>"

USER root

RUN apt-get update && \
    apt-get install -y texlive-full lmodern python3-dev libbz2-dev libxt-dev nano texlive-xetex texlive-fonts-recommended texlive-plain-generic bsdmainutils && \
    apt-get clean

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
    jupyter-cache
    jupyterlab_rise \
    abseil-cpp \
    altair \
    beautifulsoup4 \
    keras \
    r-s2 \
    r-sf \
    r-terra \
    r-raster \
    r-leaflet \
    r-glmnet \
    r-keras \
    r-reticulate \
    r-rocr \
    r-spotifyr \
    r-torch

# Install from CRAN to avoid R Downgrades
# Added BiocManager to handle EBImage

RUN R -e "install.packages('BiocManager', repos='https://cloud.r-project.org/')" && \
    R -e "BiocManager::install('EBImage', update=FALSE, ask=FALSE)" && \
    R -e "install.packages(c('caret', 'coop', 'curl', 'data.table', 'dplyr', 'ggplot2', 'httr', 'httr2', 'imager', 'janitor', 'jsonlite', 'lubridate', 'magick', 'OpenImageR', 'plotly', 'polite', 'purrr', 'quanteda', 'ranger', 'readr', 'recommenderlab', 'recosystem', 'robotstxt', 'RSelenium', 'rvest', 'scales', 'skimr', 'spacyr', 'stringr', 'tensorflow', 'text', 'text2vec', 'textdata', 'tidymodels', 'tidyr', 'tidytext', 'tm', 'tokenizers', 'wordcloud', 'xml2', 'xgboost', 'yardstick'), repos = 'https://cloud.r-project.org/', Ncpus = parallel::detectCores())"

ENV TZ America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN /usr/local/bin/fix-permissions "${CONDA_DIR}" || true

USER $NB_USER
