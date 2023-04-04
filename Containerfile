FROM ucsb/rstudio-base:latest

LABEL maintainer="LSIT Systems <lsitops@ucsb.edu>"

USER root

RUN apt-get update && \
    apt-get install -y texlive-full lmodern python3-dev libbz2-dev libxt-dev nano && \
    apt-get clean

RUN pip install otter-grader \
    Theano \
    xgboost \
    otter-grader \
    seaborn \
    keras \
    tensorflow \
    scipy \
    scikit-learn \
    matplotlib \
    torch \
    torchvision \
    torchaudio \
    Scrapy

RUN mamba install -c conda-forge rise

ENV TZ America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN /usr/local/bin/fix-permissions "${CONDA_DIR}" || true

USER $NB_USER

