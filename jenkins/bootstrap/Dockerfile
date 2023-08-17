FROM jenkins/jenkins:2.401.3

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml

# add plugins
COPY $CODESPACE_VSCODE_FOLDER/jenkins/bootstrap/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /bin/jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

# add security perms
COPY $CODESPACE_VSCODE_FOLDER/jenkins/bootstrap/casc.yaml /var/jenkins_home/casc.yaml

# seed with jobs
COPY $CODESPACE_VSCODE_FOLDER/jenkins/bootstrap/pipelines /usr/share/jenkins/ref/jobs
