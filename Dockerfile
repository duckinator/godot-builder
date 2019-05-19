FROM debian:9-slim

ENV GODOT_VERSION 3.1.1
ENV GODOT_TEMPLATE_DIR 3.1.1.stable
ENV HOME /home/builder
ENV GODOT_TEMPLATE_PATH $HOME/.local/share/godot/templates/
ENV GODOT /usr/local/bin/godot

# FIXME: Deal with the boto3 thing properly.
RUN apt-get update -y && apt-get install -y curl git make unzip zip python3 python3-pip && pip3 install boto3 && adduser --disabled-password --gecos "" builder
RUN curl -sS https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_linux_headless.64.zip | funzip > ${GODOT} && chmod 755 ${GODOT}

USER builder

RUN mkdir -p ${GODOT_TEMPLATE_PATH} && \
      cd ${GODOT_TEMPLATE_PATH} && \
      curl -sS https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_export_templates.tpz -o godot-templates.zip && \
      unzip godot-templates.zip && \
      mv ./templates ./${GODOT_TEMPLATE_DIR}
