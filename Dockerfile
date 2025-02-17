FROM quay.io/ansible/ansible-runner:latest

RUN dnf install -y \
    python3-pip \
    git \
    && dnf clean all

COPY requirements.txt /tmp/requirements.txt
RUN python3 -m pip install --upgrade pip \
    && python3 -m pip install -r /tmp/requirements.txt

COPY requirements.yml /tmp/requirements.yml
RUN ansible-galaxy collection install -r /tmp/requirements.yml

COPY bindep.txt /tmp/bindep.txt
RUN if [ -f /tmp/bindep.txt ]; then \
    dnf install -y $(cat /tmp/bindep.txt) \
    && dnf clean all; \
    fi

WORKDIR /runner
ENV ANSIBLE_FORCE_COLOR=True