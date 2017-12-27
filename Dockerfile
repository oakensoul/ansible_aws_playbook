FROM python:alpine3.6

RUN \
  apk -v --update add \
    bash \
    curl \
    openssh-client \
    py-setuptools \
    py-dateutil \
    py-httplib2 \
    py-jinja2 \
    py-paramiko \
    py-yaml \
    tar && \
  rm -rf /var/cache/apk/*

RUN pip install boto && pip install boto3 && pip install awscli && pip install ansible

RUN mkdir /etc/ansible/ /ansible
RUN echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/hosts

RUN mkdir -p /ansible/playbooks
WORKDIR /ansible/playbooks

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True
ENV PATH /ansible/bin:$PATH
ENV PYTHONPATH /ansible/lib

ENTRYPOINT ["ansible-playbook"]
