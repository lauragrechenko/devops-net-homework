FROM alpine:3.18

RUN apk update && \
    apk add --no-cache curl bash git unzip python3 py3-pip

RUN curl -sSL https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

RUN pip3 install checkov

RUN tflint --version && checkov --version

RUN curl -sLo terraform.zip https://releases.hashicorp.com/terraform/1.10.5/terraform_1.10.5_linux_amd64.zip
RUN unzip terraform.zip -d /usr/local/bin/ && rm terraform.zip

RUN terraform --version

RUN curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
ENV PATH="/root/yandex-cloud/bin:${PATH}"

RUN yc --version

WORKDIR /workspace

CMD [ "bash" ]