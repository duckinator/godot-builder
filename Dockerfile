FROM debian:9-slim

ENV GODOT_VERSION 3.1.1
ENV GODOT_TEMPLATE_DIR 3.1.1.stable

ENV HOME /home/builder
ENV PATH $PATH:/opt/butler
ENV GODOT_TEMPLATE_PATH $HOME/.local/share/godot/templates/
ENV GODOT /usr/local/bin/godot

# FIXME: I have no idea why /home/builder exists and has to be removed?
#        Is it some kind of caching bullshit?
RUN apt-get update -y && apt-get install -y curl git make unzip zip python3 python3-pip && rm -rf /home/builder && adduser --disabled-password --gecos "" builder

# Download Godot.
RUN curl -sS https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_linux_headless.64.zip | funzip > ${GODOT} && chmod 755 ${GODOT}

# Download itch.io's butler tool.
RUN mkdir -p /opt/butler && \
      cd /opt/butler && \
      curl -L -sS https://broth.itch.ovh/butler/linux-amd64/LATEST/archive/default -o latest.zip && \
      unzip latest.zip && \
      chmod +x butler

USER builder

RUN mkdir -p ${GODOT_TEMPLATE_PATH} && \
      cd ${GODOT_TEMPLATE_PATH} && \
      curl -sS https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_export_templates.tpz -o godot-templates.zip && \
      unzip godot-templates.zip && \
      mv ./templates ./${GODOT_TEMPLATE_DIR}
