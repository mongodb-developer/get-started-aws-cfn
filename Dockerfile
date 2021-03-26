# syntax=docker/dockerfile:1.0.0-experimental
FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ARG AWS_DEFAULT_REGION
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_SESSION_TOKEN
RUN apt-get update && apt-get install -y \
    make \
    git \
    wget \
    curl \
    zip \
    jq \
    golang \
    python3 python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && ./aws/install

RUN pip3 install cloudformation-cli-go-plugin

# Install mongocli
RUN MCLI_TAG=$(curl -sL --header "Accept: application/json" https://github.com/mongodb/mongocli/releases/latest | jq -r '.["tag_name"]') && \
    MCLI_VERSION=$(echo $MCLI_TAG | cut -dv -f2) && \
    MCLI_DEB="mongocli_${MCLI_VERSION}_linux_x86_64.deb" && \
    curl -OL https://github.com/mongodb/mongocli/releases/download/${MCLI_TAG}/${MCLI_DEB} && \
    echo "About to install mongocli from: ${MCLI_DEB}" && \
    dpkg -i ${MCLI_DEB}


ENV WORKSPACE /workspace
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

RUN --mount=type=ssh,id=github git clone --single-branch --branch develop git@github.com:aws-quickstart/quickstart-mongodb-atlas.git
RUN --mount=type=ssh,id=github git clone git@github.com:aws-quickstart/quickstart-mongodb-atlas-resources.git


# Pre build everything
RUN cd /quickstart-mongodb-atlas-resources/cfn-resources/ && BUILD_ONLY=true ./cfn-submit-helper.sh
# copy the build logs over to different name to help troubleshoot deployment logs
RUN cd /quickstart-mongodb-atlas-resources/cfn-resources/ && ls **/rpdk.log | xargs -I {} mv {} {}.build

COPY get-setup-aws-cfn.sh /

ENTRYPOINT ["/bin/bash", "-c"]  
