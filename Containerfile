FROM ucsb/rstudio-base:latest

LABEL maintainer="LSIT Systems <lsitops@ucsb.edu>"

USER root

RUN apt-get update && \
    apt-get install -y texlive-full lmodern python3-dev libbz2-dev libxt-dev nano && \
    apt-get clean

RUN pip install -y otter-grader

RUN mamba install -c conda-forge rise

ENV TZ PST

RUN /usr/local/bin/fix-permissions "${CONDA_DIR}" || true

USER $NB_USER

