FROM ucsb/rstudio-base:latest

LABEL maintainer="LSIT Systems <lsitops@ucsb.edu>"

USER root

RUN apt-get update && \
    apt-get install -y texlive-full lmodern python3-dev libbz2-dev libxt-dev nano texlive-xetex texlive-fonts-recommended texlive-plain-generic bsdmainutils && \
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
    Scrapy \
    cvxpy \
    statsmodels


RUN mamba install -c conda-forge jupyterlab_rise altair

RUN R -e "install.packages(c('ROCR', 'glmnet', 'quarto'), repos = 'https://cloud.r-project.org/', Ncpus = parallel::detectCores())"

ENV TZ America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN /usr/local/bin/fix-permissions "${CONDA_DIR}" || true

USER $NB_USER

