FROM ubuntu:xenial

# set up for installation of R
RUN set -x \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0x51716619e084dab9 \
    && echo 'deb http://cran.rstudio.com/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list \
    && apt-get update

# install R itself
RUN apt-get install -y r-base

RUN apt-get update

# install other packages needed
RUN apt-get install -y --fix-missing \
    cmake \
    libcurl4-openssl-dev \
    libssh2-1-dev \
    libssl-dev \
    libxml2-dev \
    locales \
    wget

# install pandoc manually to a known good version
RUN cd /tmp \
    && wget https://github.com/jgm/pandoc/releases/download/2.5/pandoc-2.5-1-amd64.deb \
    && dpkg -i pandoc-2.5-1-amd64.deb

# install devtools and RMarkdown
RUN R -e 'options(download.file.method = "wget"); install.packages("devtools", repos = "https://cran.rstudio.com"); install.packages("rmarkdown", repos = "https://cran.rstudio.com")'

# install quarto manually to a known good version
ARG QUARTO_VERSION=0.2.94

RUN cd /tmp \
	&& wget -q https://github.com/quarto-dev/quarto-cli/releases/download/v$QUARTO_VERSION/quarto-$QUARTO_VERSION-amd64.deb \
	&& dpkg -i quarto-$QUARTO_VERSION-amd64.deb

# Ensure that quarto installs the latex packages it needs
RUN quarto tools install tinytex

# Add root directory to path so that Quarto can see it at render time
ENV PATH="${PATH}:/root/bin" 

# set up LANG for building books; otherwise pandoc writes "C" as the language,
# which confuses kindlegen
RUN locale-gen en_US.utf8
ENV LANG=en_US.utf8

# Add Jenkins user
ARG JENKINS_GID=999
ARG JENKINS_UID=999
RUN groupadd -g $JENKINS_GID jenkins && \
    useradd -m -d /var/lib/jenkins -u $JENKINS_UID -g jenkins jenkins && \
    echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
