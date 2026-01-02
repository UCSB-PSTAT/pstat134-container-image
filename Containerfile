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
    r::r-text \
    r::r-textdata \
    r-torch

ENV TZ America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN /usr/local/bin/fix-permissions "${CONDA_DIR}" || true

USER $NB_USER
