pipeline {
    agent none
    triggers{
        upstream(upstreamProjects: 'UCSB-PSTAT GitHub/base-rstudio/main', threshold: hudson.model.Result.SUCCESS)
    }
    environment {
        IMAGE_NAME = 'pstat134'
    }
    stages {
        stage('Build Test Deploy') {
            agent {
                label 'jupyter'
            }
            stages{
                stage('Build') {
                    steps {
                        script {
                            if (currentBuild.getBuildCauses('com.cloudbees.jenkins.GitHubPushCause').size() || currentBuild.getBuildCauses('jenkins.branch.BranchIndexingCause').size()) {
                               scmSkip(deleteBuild: true, skipPattern:'.*\\[ci skip\\].*')
                            }
                        }
                        echo "NODE_NAME = ${env.NODE_NAME}"
                        sh 'podman build -t localhost/$IMAGE_NAME --pull --force-rm --no-cache .'
                    }
                    post {
                        unsuccessful {
                            sh 'podman rmi -i localhost/$IMAGE_NAME || true'
                        }
                    }
                }
                stage('Test') {
                    steps {
                        sh 'podman run -it --rm localhost/$IMAGE_NAME which rstudio'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME which xelatex'
			sh 'podman run -it --rm localhost/$IMAGE_NAME otter --version'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME R -q -e "getRversion() >= \\"4.1.3\\"" | tee /dev/stderr | grep -q "TRUE"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import altair"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "from bs4 import BeautifulSoup"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import cvxpy"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import geopandas"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import folium"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import matplotlib"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import numpy"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import pandas"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import pyarrow"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import requests"'  
                        sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import sklearn; sklearn.show_versions()"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import scipy"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import seaborn"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import statsmodels"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import tensorflow"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import torch"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import torchvision"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"dplyr\")"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"ggplot2\")"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"glmnet\")"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"httr\")"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"keras\")"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"lubridate\")"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"readr\")"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"reticulate\")"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"ROCR\")"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"rvest\")"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"spotifyr\")"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"stringr\")"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"text\")"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"textdata\")"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"tidymodels\")"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"tidyr\")"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"tidyverse\")"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"torch\")"'
                        sh 'podman run -d --name=$IMAGE_NAME --rm -p 8888:8888 localhost/$IMAGE_NAME start-notebook.sh --NotebookApp.token="jenkinstest"'
                        sh 'sleep 10 && curl -v http://localhost:8888/rstudio?token=jenkinstest 2>&1 | grep -P "HTTP\\S+\\s[1-3][0-9][0-9]\\s+[\\w\\s]+\\s*$"'
                        sh 'curl -v http://localhost:8888/lab?token=jenkinstest 2>&1 | grep -P "HTTP\\S+\\s200\\s+[\\w\\s]+\\s*$"'
                        sh 'curl -v http://localhost:8888/tree?token=jenkinstest 2>&1 | grep -P "HTTP\\S+\\s200\\s+[\\w\\s]+\\s*$"'
                    }
                    post {
                        always {
                            sh 'podman rm -ifv $IMAGE_NAME'
                        }
                        unsuccessful {
                            sh 'podman rmi -i localhost/$IMAGE_NAME || true'
                        }
                    }
                }
                stage('Deploy') {
                    when { branch 'main' }
                    environment {
                        DOCKER_HUB_CREDS = credentials('DockerHubToken')
                    }
                    steps {
                        sh 'skopeo copy containers-storage:localhost/$IMAGE_NAME docker://docker.io/ucsb/$IMAGE_NAME:latest --dest-username $DOCKER_HUB_CREDS_USR --dest-password $DOCKER_HUB_CREDS_PSW'
                        sh 'skopeo copy containers-storage:localhost/$IMAGE_NAME docker://docker.io/ucsb/$IMAGE_NAME:v$(date "+%Y%m%d") --dest-username $DOCKER_HUB_CREDS_USR --dest-password $DOCKER_HUB_CREDS_PSW'
                    }
                    post {
                        always {
                            sh 'podman rmi -i localhost/$IMAGE_NAME || true'
                        }
                    }
                }                
            }
            post {
                always {
                    sh 'podman rmi -i localhost/$IMAGE_NAME || true'
                }
            }
        }
    }
    post {
        success {
            slackSend(channel: '#infrastructure-build', username: 'jenkins', color: 'good', message: "Build ${env.JOB_NAME} ${env.BUILD_NUMBER} just finished successfull! (<${env.BUILD_URL}|Details>)")
        }
        failure {
            slackSend(channel: '#infrastructure-build', username: 'jenkins', color: 'danger', message: "Uh Oh! Build ${env.JOB_NAME} ${env.BUILD_NUMBER} had a failure! (<${env.BUILD_URL}|Find out why>).")
        }
    }
}
