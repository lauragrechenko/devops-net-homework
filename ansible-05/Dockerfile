FROM rockylinux:9

ENV MOLECULE_NO_LOG=false \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

# System deps (no 'curl' to avoid conflict with curl-minimal)
RUN dnf -y update && \
    dnf -y install \
      python3 python3-pip python3-setuptools \
      gcc make which tar xz bzip2 bzip2-devel xz-devel \
      openssl openssl-devel libffi-devel zlib zlib-devel \
      readline-devel sqlite-devel tk-devel findutils wget git \
      sshpass rsync sudo podman jq && \
    dnf clean all && rm -rf /var/cache/dnf

# Optional: keep virtualenv handy (tox can use stdlib venv too)
RUN python3 -m pip install --no-cache-dir --upgrade pip virtualenv

# Build CPython 3.10 + 3.11
ARG PY310=3.10.14
ARG PY311=3.11.9
WORKDIR /tmp

# 3.10
RUN set -eux; \
    wget -q "https://www.python.org/ftp/python/${PY310}/Python-${PY310}.tgz"; \
    tar -xf "Python-${PY310}.tgz"; \
    cd "Python-${PY310}"; \
    ./configure --enable-optimizations; \
    make -j"$(nproc)"; \
    make altinstall; \
    cd /tmp; rm -rf "Python-${PY310}" "Python-${PY310}.tgz"

# 3.11
RUN set -eux; \
    wget -q "https://www.python.org/ftp/python/${PY311}/Python-${PY311}.tgz"; \
    tar -xf "Python-${PY311}.tgz"; \
    cd "Python-${PY311}"; \
    ./configure --enable-optimizations; \
    make -j"$(nproc)"; \
    make altinstall; \
    cd /tmp; rm -rf "Python-${PY311}" "Python-${PY311}.tgz"

# Verify interpreters (py39 from distro, py310/py311 from source)
RUN python3.9 -V && /usr/local/bin/python3.10 -V && /usr/local/bin/python3.11 -V

# Tox/Molecule/Ansible toolchain per your matrix
RUN python3.9 -m pip install --no-cache-dir \
      'tox>=4.0' \
      'molecule>=6.0' \
      'molecule-plugins[docker]>=23.5' \
      'molecule-plugins[podman]>=23.5' \
      ansible-lint \
      jmespath

# Your containers.conf
COPY containers.conf /etc/containers/containers.conf

CMD ["/bin/bash"]
