FROM ucsb/rstudio-base:latest

LABEL maintainer="LSIT Systems <lsitops@ucsb.edu>"

USER root

RUN apt-get update && \
    apt-get install -y texlive-full lmodern python3-dev libbz2-dev libxt-dev nano texlive-xetex texlive-fonts-recommended texlive-plain-generic bsdmainutils && \
    apt-get clean

RUN pip install otter-grader \
    seaborn \
    scipy \
    scikit-learn \
    matplotlib \
    cvxpy \
    statsmodels \
    umap-learn \
    yfinance \
    pyarrow \
    geopandas \
    folium

RUN conda install -y -c conda-forge jupyterlab_rise altair r-glmnet r-quarto r-reticulate r-rocr

ENV TZ America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN /usr/local/bin/fix-permissions "${CONDA_DIR}" || true

USER $NB_USER

