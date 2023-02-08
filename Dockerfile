###########################################
###########################################
## Dockerfile to run MegaLinter ##
###########################################
###########################################

# @not-generated

#############################################################################################
## @generated by .automation/build.py using descriptor files, please do not update manually ##
#############################################################################################
#FROM__START
FROM mvdan/shfmt:latest-alpine as shfmt
FROM cljkondo/clj-kondo:2023.01.20-alpine as clj-kondo
FROM hadolint/hadolint:v2.12.0-alpine as hadolint
FROM mstruebing/editorconfig-checker:2.4.0 as editorconfig-checker
FROM ghcr.io/assignuser/chktex-alpine:latest as chktex
FROM yoheimuta/protolint:latest as protolint
FROM zricethezav/gitleaks:v8.15.3 as gitleaks
FROM ghcr.io/terraform-linters/tflint:v0.44.1 as tflint
FROM tenable/terrascan:1.16.0 as terrascan
FROM alpine/terragrunt:latest as terragrunt
FROM checkmarx/kics:alpine as kics
#FROM__END

##################
# Get base image #
##################
# 3.10.5 is not usable until https://github.com/jruere/multiprocessing-logging/issues/56 is fixed
FROM python:3.11.1-alpine3.17

#############################################################################################
## @generated by .automation/build.py using descriptor files, please do not update manually ##
#############################################################################################
#ARG__START
ARG PWSH_VERSION='latest'
ARG PWSH_DIRECTORY='/opt/microsoft/powershell'
ARG ARM_TTK_NAME='master.zip'
ARG ARM_TTK_URI='https://github.com/Azure/arm-ttk/archive/master.zip'
ARG ARM_TTK_DIRECTORY='/opt/microsoft'
ARG BICEP_EXE='bicep'
ARG BICEP_URI='https://github.com/Azure/bicep/releases/latest/download/bicep-linux-musl-x64'
ARG BICEP_DIR='/usr/local/bin'
ARG DART_VERSION='2.8.4'
ARG GLIBC_VERSION='2.34-r0'
ARG PMD_VERSION=6.48.0
ARG PSSA_VERSION='latest'
#ARG__END

####################
# Run APK installs #
####################

WORKDIR /

#############################################################################################
## @generated by .automation/build.py using descriptor files, please do not update manually ##
#############################################################################################
#APK__START
RUN apk add --update --no-cache \
                bash \
                ca-certificates \
                curl \
                gcc \
                git \
                git-lfs \
                libffi-dev \
                make \
                musl-dev \
                openssh \
                docker \
                openrc \
                go \
                icu-libs \
                libcurl \
                libintl \
                libssl1.1 \
                libstdc++ \
                lttng-ust-dev \
                zlib \
                zlib-dev \
                openjdk11 \
                perl \
                perl-dev \
                gnupg \
                php81 \
                php81-phar \
                php81-mbstring \
                php81-xmlwriter \
                php81-tokenizer \
                php81-ctype \
                php81-curl \
                php81-dom \
                php81-simplexml \
                composer \
                dpkg \
                nodejs \
                npm \
                yarn \
                openssl \
                readline-dev \
                g++ \
                libc-dev \
                libgcc \
                libxml2-dev \
                libxml2-utils \
                linux-headers \
                R \
                R-dev \
                R-doc \
                nodejs-current \
                ruby \
                ruby-dev \
                ruby-bundler \
                ruby-rdoc \
    && git config --global core.autocrlf true
#APK__END

# PATH for golang & python
ENV GOROOT=/usr/lib/go \
    GOPATH=/go
    # PYTHONPYCACHEPREFIX="$HOME/.cache/cpython/" NV: not working for all packages :/
# hadolint ignore=DL3044
ENV PATH="$PATH":"$GOROOT"/bin:"$GOPATH"/bin
RUN mkdir -p ${GOPATH}/src ${GOPATH}/bin || true && \
    # Ignore npm package issues
    yarn config set ignore-engines true || true

#############################################################################################
## @generated by .automation/build.py using descriptor files, please do not update manually ##
#############################################################################################
#PIP__START

#PIP__END

#PIPVENV__START
RUN PYTHONDONTWRITEBYTECODE=1 pip3 install --no-cache-dir --upgrade pip virtualenv \
    && mkdir -p "/venvs/ansible-lint" && cd "/venvs/ansible-lint" && virtualenv . && source bin/activate && PYTHONDONTWRITEBYTECODE=1 pip3 install --no-cache-dir ansible-lint && deactivate && cd ./../.. \
    && mkdir -p "/venvs/cpplint" && cd "/venvs/cpplint" && virtualenv . && source bin/activate && PYTHONDONTWRITEBYTECODE=1 pip3 install --no-cache-dir cpplint && deactivate && cd ./../.. \
    && mkdir -p "/venvs/cfn-lint" && cd "/venvs/cfn-lint" && virtualenv . && source bin/activate && PYTHONDONTWRITEBYTECODE=1 pip3 install --no-cache-dir cfn-lint && deactivate && cd ./../.. \
    && mkdir -p "/venvs/djlint" && cd "/venvs/djlint" && virtualenv . && source bin/activate && PYTHONDONTWRITEBYTECODE=1 pip3 install --no-cache-dir djlint && deactivate && cd ./../.. \
    && mkdir -p "/venvs/pylint" && cd "/venvs/pylint" && virtualenv . && source bin/activate && PYTHONDONTWRITEBYTECODE=1 pip3 install --no-cache-dir pylint typing-extensions && deactivate && cd ./../.. \
    && mkdir -p "/venvs/black" && cd "/venvs/black" && virtualenv . && source bin/activate && PYTHONDONTWRITEBYTECODE=1 pip3 install --no-cache-dir black && deactivate && cd ./../.. \
    && mkdir -p "/venvs/flake8" && cd "/venvs/flake8" && virtualenv . && source bin/activate && PYTHONDONTWRITEBYTECODE=1 pip3 install --no-cache-dir flake8 && deactivate && cd ./../.. \
    && mkdir -p "/venvs/isort" && cd "/venvs/isort" && virtualenv . && source bin/activate && PYTHONDONTWRITEBYTECODE=1 pip3 install --no-cache-dir isort black && deactivate && cd ./../.. \
    && mkdir -p "/venvs/bandit" && cd "/venvs/bandit" && virtualenv . && source bin/activate && PYTHONDONTWRITEBYTECODE=1 pip3 install --no-cache-dir bandit bandit_sarif_formatter && deactivate && cd ./../.. \
    && mkdir -p "/venvs/mypy" && cd "/venvs/mypy" && virtualenv . && source bin/activate && PYTHONDONTWRITEBYTECODE=1 pip3 install --no-cache-dir mypy && deactivate && cd ./../.. \
    && mkdir -p "/venvs/pyright" && cd "/venvs/pyright" && virtualenv . && source bin/activate && PYTHONDONTWRITEBYTECODE=1 pip3 install --no-cache-dir pyright==1.1.270 && deactivate && cd ./../.. \
    && mkdir -p "/venvs/checkov" && cd "/venvs/checkov" && virtualenv . && source bin/activate && PYTHONDONTWRITEBYTECODE=1 pip3 install --no-cache-dir packaging==21.3 checkov && deactivate && cd ./../.. \
    && mkdir -p "/venvs/semgrep" && cd "/venvs/semgrep" && virtualenv . && source bin/activate && PYTHONDONTWRITEBYTECODE=1 pip3 install --no-cache-dir semgrep && deactivate && cd ./../.. \
    && mkdir -p "/venvs/rst-lint" && cd "/venvs/rst-lint" && virtualenv . && source bin/activate && PYTHONDONTWRITEBYTECODE=1 pip3 install --no-cache-dir restructuredtext_lint && deactivate && cd ./../.. \
    && mkdir -p "/venvs/rstcheck" && cd "/venvs/rstcheck" && virtualenv . && source bin/activate && PYTHONDONTWRITEBYTECODE=1 pip3 install --no-cache-dir rstcheck && deactivate && cd ./../.. \
    && mkdir -p "/venvs/rstfmt" && cd "/venvs/rstfmt" && virtualenv . && source bin/activate && PYTHONDONTWRITEBYTECODE=1 pip3 install --no-cache-dir rstfmt && deactivate && cd ./../.. \
    && mkdir -p "/venvs/snakemake" && cd "/venvs/snakemake" && virtualenv . && source bin/activate && PYTHONDONTWRITEBYTECODE=1 pip3 install --no-cache-dir snakemake && deactivate && cd ./../.. \
    && mkdir -p "/venvs/snakefmt" && cd "/venvs/snakefmt" && virtualenv . && source bin/activate && PYTHONDONTWRITEBYTECODE=1 pip3 install --no-cache-dir snakefmt && deactivate && cd ./../.. \
    && mkdir -p "/venvs/proselint" && cd "/venvs/proselint" && virtualenv . && source bin/activate && PYTHONDONTWRITEBYTECODE=1 pip3 install --no-cache-dir proselint && deactivate && cd ./../.. \
    && mkdir -p "/venvs/sqlfluff" && cd "/venvs/sqlfluff" && virtualenv . && source bin/activate && PYTHONDONTWRITEBYTECODE=1 pip3 install --no-cache-dir sqlfluff && deactivate && cd ./../.. \
    && mkdir -p "/venvs/yamllint" && cd "/venvs/yamllint" && virtualenv . && source bin/activate && PYTHONDONTWRITEBYTECODE=1 pip3 install --no-cache-dir yamllint && deactivate && cd ./../..  \
    && find . | grep -E "(/__pycache__$|\.pyc$|\.pyo$)" | xargs rm -rf && rm -rf /root/.cache
ENV PATH="${PATH}":/venvs/ansible-lint/bin:/venvs/cpplint/bin:/venvs/cfn-lint/bin:/venvs/djlint/bin:/venvs/pylint/bin:/venvs/black/bin:/venvs/flake8/bin:/venvs/isort/bin:/venvs/bandit/bin:/venvs/mypy/bin:/venvs/pyright/bin:/venvs/checkov/bin:/venvs/semgrep/bin:/venvs/rst-lint/bin:/venvs/rstcheck/bin:/venvs/rstfmt/bin:/venvs/snakemake/bin:/venvs/snakefmt/bin:/venvs/proselint/bin:/venvs/sqlfluff/bin:/venvs/yamllint/bin
#PIPVENV__END

############################
# Install NPM dependencies #
#############################################################################################
## @generated by .automation/build.py using descriptor files, please do not update manually ##
#############################################################################################

ENV NODE_OPTIONS="--max-old-space-size=8192" \
    NODE_ENV=production
#NPM__START
WORKDIR /node-deps
RUN npm --no-cache install --ignore-scripts \
                sfdx-cli \
                typescript \
                @coffeelint/cli \
                jscpd@3.3.26 \
                stylelint \
                stylelint-config-standard \
                stylelint-config-sass-guidelines \
                stylelint-scss \
                gherkin-lint \
                graphql \
                graphql-schema-linter \
                npm-groovy-lint \
                htmlhint \
                eslint \
                eslint-config-airbnb \
                eslint-config-prettier \
                eslint-config-standard \
                eslint-plugin-import \
                eslint-plugin-jest \
                eslint-plugin-node \
                eslint-plugin-prettier \
                eslint-plugin-promise \
                eslint-plugin-vue \
                babel-eslint \
                @babel/core \
                @babel/eslint-parser \
                @microsoft/eslint-formatter-sarif \
                standard \
                prettier \
                @prantlf/jsonlint \
                eslint-plugin-jsonc \
                v8r \
                npm-package-json-lint \
                npm-package-json-lint-config-default \
                eslint-plugin-react \
                eslint-plugin-jsx-a11y \
                markdownlint-cli \
                markdown-link-check \
                markdown-table-formatter \
                @stoplight/spectral@5.6.0 \
                secretlint \
                @secretlint/secretlint-rule-preset-recommend \
                @secretlint/secretlint-formatter-sarif \
                cspell \
                sql-lint \
                tekton-lint \
                prettyjson \
                @typescript-eslint/eslint-plugin \
                @typescript-eslint/parser && \
    npm audit fix --audit-level=critical || true \
    && npm cache clean --force || true \
    && rm -rf /root/.npm/_cacache \
    && find . -name "*.d.ts" -delete \
    && find . -name "*.map" -delete \
    && find . -name "*.npmignore" -delete \
    && find . -name "*.travis.yml" -delete \
    && find . -name "CHANGELOG.md" -delete \
    && find . -name "README.md" -delete \
    && find . -name ".package-lock.json" -delete \
    && find . -name "package-lock.json" -delete \
    && find . -name "README.md" -delete
WORKDIR /

#NPM__END

# Add node packages to path #
ENV PATH="/node-deps/node_modules/.bin:${PATH}" \
    NODE_PATH="/node-deps/node_modules"

##############################
# Installs ruby dependencies #
#############################################################################################
## @generated by .automation/build.py using descriptor files, please do not update manually ##
#############################################################################################

#GEM__START
RUN echo 'gem: --no-document' >> ~/.gemrc && \
    gem install \
          scss_lint \
          puppet-lint \
          goodcheck \
          rubocop \
          rubocop-github \
          rubocop-performance \
          rubocop-rails \
          rubocop-rspec
#GEM__END

##############################
# Installs rust dependencies #
#############################################################################################
## @generated by .automation/build.py using descriptor files, please do not update manually ##
#############################################################################################

#CARGO__START
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --profile minimal --default-toolchain stable \
    && export PATH="/root/.cargo/bin:${PATH}" \
    && rustup component add clippy && cargo install --force --locked sarif-fmt  shellcheck-sarif \
    && rm -rf /root/.cargo/registry /root/.cargo/git /root/.cache/sccache
ENV PATH="/root/.cargo/bin:${PATH}"
#CARGO__END

##############################
# COPY instructions #
#############################################################################################
## @generated by .automation/build.py using descriptor files, please do not update manually ##
#############################################################################################

#COPY__START
COPY --from=shfmt /bin/shfmt /usr/bin/
COPY --from=clj-kondo /bin/clj-kondo /usr/bin/
COPY --from=hadolint /bin/hadolint /usr/bin/hadolint
COPY --from=editorconfig-checker /usr/bin/ec /usr/bin/editorconfig-checker
COPY --from=chktex /usr/bin/chktex /usr/bin/
COPY --from=protolint /usr/local/bin/protolint /usr/bin/
COPY --from=gitleaks /usr/bin/gitleaks /usr/bin/
COPY --from=tflint /usr/local/bin/tflint /usr/bin/
COPY --from=terrascan /go/bin/terrascan /usr/bin/
COPY --from=terragrunt /usr/local/bin/terragrunt /usr/bin/
COPY --from=terragrunt /bin/terraform /usr/bin/
COPY --from=kics /app/bin/kics /usr/bin/
COPY --from=kics /app/bin/assets /opt/kics/assets/
#COPY__END

#############################################################################################
## @generated by .automation/build.py using descriptor files, please do not update manually ##
#############################################################################################
#OTHER__START
RUN rc-update add docker boot && rc-service docker start || true \
# ARM installation
    && mkdir -p ${PWSH_DIRECTORY} \
    && curl --retry 5 --retry-delay 5 -s https://api.github.com/repos/powershell/powershell/releases/${PWSH_VERSION} \
        | grep browser_download_url \
        | grep linux-alpine-x64 \
        | cut -d '"' -f 4 \
        | xargs -n 1 wget -O - \
        | tar -xzC ${PWSH_DIRECTORY} \
    && ln -sf ${PWSH_DIRECTORY}/pwsh /usr/bin/pwsh \

# CSHARP installation
    && wget --tries=5 -q -O dotnet-install.sh https://dot.net/v1/dotnet-install.sh \
    && chmod +x dotnet-install.sh \
    && ./dotnet-install.sh --install-dir /usr/share/dotnet -channel 6.0 -version latest

ENV PATH="${PATH}:/root/.dotnet/tools:/usr/share/dotnet"

# JAVA installation
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk
ENV PATH="$JAVA_HOME/bin:${PATH}"

# PHP installation
RUN wget --tries=5 -q -O phive.phar https://phar.io/releases/phive.phar \
    && wget --tries=5 -q -O phive.phar.asc https://phar.io/releases/phive.phar.asc \
    && PHAR_KEY_ID="0x9D8A98B29B2D5D79" \
    && ( gpg --keyserver keyserver.pgp.com --recv-keys "$PHAR_KEY_ID" \
        || gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$PHAR_KEY_ID" \
        || gpg --keyserver pgp.mit.edu --recv-keys "$PHAR_KEY_ID" \
        || gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys "$PHAR_KEY_ID" ) \
    && gpg --verify phive.phar.asc phive.phar \
    && chmod +x phive.phar \
    && mv phive.phar /usr/local/bin/phive \
    && rm phive.phar.asc \
    && update-alternatives --install /usr/bin/php php /usr/bin/php81 110

ENV PATH="/root/.composer/vendor/bin:$PATH"

# POWERSHELL installation
RUN mkdir -p ${PWSH_DIRECTORY} \
    && curl --retry 5 --retry-delay 5 -s https://api.github.com/repos/powershell/powershell/releases/${PWSH_VERSION} \
        | grep browser_download_url \
        | grep linux-alpine-x64 \
        | cut -d '"' -f 4 \
        | xargs -n 1 wget -O - \
        | tar -xzC ${PWSH_DIRECTORY} \
    && ln -sf ${PWSH_DIRECTORY}/pwsh /usr/bin/pwsh \
    && chmod +x /usr/bin/pwsh \

# SALESFORCE installation
# Next line commented because already managed by another linter
# ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk
# Next line commented because already managed by another linter
# ENV PATH="$JAVA_HOME/bin:${PATH}"
    && echo y|sfdx plugins:install sfdx-hardis \
    && npm cache clean --force || true \
    && rm -rf /root/.npm/_cacache \

# SCALA installation
    && curl -fLo coursier https://git.io/coursier-cli && \
        chmod +x coursier


# VBDOTNET installation
# Next line commented because already managed by another linter
# RUN wget --tries=5 -q -O dotnet-install.sh https://dot.net/v1/dotnet-install.sh \
#     && chmod +x dotnet-install.sh \
#     && ./dotnet-install.sh --install-dir /usr/share/dotnet -channel 6.0 -version latest
# Next line commented because already managed by another linter
# ENV PATH="${PATH}:/root/.dotnet/tools:/usr/share/dotnet"

# actionlint installation
ENV GO111MODULE=on
RUN go install github.com/rhysd/actionlint/cmd/actionlint@latest && go clean --cache

# arm-ttk installation
ENV ARM_TTK_PSD1="${ARM_TTK_DIRECTORY}/arm-ttk-master/arm-ttk/arm-ttk.psd1"
RUN curl --retry 5 --retry-delay 5 -sLO "${ARM_TTK_URI}" \
    && unzip "${ARM_TTK_NAME}" -d "${ARM_TTK_DIRECTORY}" \
    && rm "${ARM_TTK_NAME}" \
    && ln -sTf "${ARM_TTK_PSD1}" /usr/bin/arm-ttk \
    && chmod a+x /usr/bin/arm-ttk \

# bash-exec installation
    && printf '#!/bin/bash \n\nif [[ -x "$1" ]]; then exit 0; else echo "Error: File:[$1] is not executable"; exit 1; fi' > /usr/bin/bash-exec \
    && chmod +x /usr/bin/bash-exec \

# shellcheck installation
    && ML_THIRD_PARTY_DIR="/third-party/shellcheck" \
    && mkdir -p ${ML_THIRD_PARTY_DIR} \
    && wget -qO- "https://github.com/koalaman/shellcheck/releases/download/stable/shellcheck-stable.linux.x86_64.tar.xz" | tar -xJv --directory ${ML_THIRD_PARTY_DIR} \
    && mv "${ML_THIRD_PARTY_DIR}/shellcheck-stable/shellcheck" /usr/bin/ \
    && find ${ML_THIRD_PARTY_DIR} -type f -not -name 'LICENSE*' -delete -o -type d -empty -delete \

# shfmt installation
# Managed with COPY --from=shfmt /bin/shfmt /usr/bin/

# bicep_linter installation
    && curl --retry 5 --retry-delay 5 -sLo ${BICEP_EXE} "${BICEP_URI}" \
    && chmod +x "${BICEP_EXE}" \
    && mv "${BICEP_EXE}" "${BICEP_DIR}" \

# clj-kondo installation
# Managed with COPY --from=clj-kondo /bin/clj-kondo /usr/bin/

# csharpier installation
    && /usr/share/dotnet/dotnet tool install -g csharpier \

# dartanalyzer installation
    && wget --tries=50 -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && wget --tries=5 -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
    && apk add --force-overwrite --no-cache glibc-${GLIBC_VERSION}.apk && rm glibc-${GLIBC_VERSION}.apk \
    && wget --tries=5 https://storage.googleapis.com/dart-archive/channels/stable/release/${DART_VERSION}/sdk/dartsdk-linux-x64-release.zip -O - -q | unzip -q - \
    && chmod +x dart-sdk/bin/dart* \
    && mv dart-sdk/bin/* /usr/bin/ && mv dart-sdk/lib/* /usr/lib/ && mv dart-sdk/include/* /usr/include/ \
    && rm -r dart-sdk/ \

# hadolint installation
# Managed with COPY --from=hadolint /bin/hadolint /usr/bin/hadolint

# editorconfig-checker installation
# Managed with COPY --from=editorconfig-checker /usr/bin/ec /usr/bin/editorconfig-checker

# dotenv-linter installation
    && wget -q -O - https://raw.githubusercontent.com/dotenv-linter/dotenv-linter/master/install.sh | sh -s \

# golangci-lint installation
    && wget -O- -nv https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh \
    && golangci-lint --version \

# revive installation
    && go install github.com/mgechev/revive@latest && go clean --cache \

# checkstyle installation
    && CHECKSTYLE_LATEST=$(curl -s https://api.github.com/repos/checkstyle/checkstyle/releases/latest \
        | grep browser_download_url \
        | grep ".jar" \
        | cut -d '"' -f 4) \
    && curl --retry 5 --retry-delay 5 -sSL $CHECKSTYLE_LATEST \
        --output /usr/bin/checkstyle \

# pmd installation
    && wget --quiet https://github.com/pmd/pmd/releases/download/pmd_releases%2F${PMD_VERSION}/pmd-bin-${PMD_VERSION}.zip && \
    unzip pmd-bin-${PMD_VERSION}.zip && \
    rm pmd-bin-${PMD_VERSION}.zip && \
    mv pmd-bin-${PMD_VERSION} /usr/bin/pmd && \
    chmod +x /usr/bin/pmd/bin/run.sh \

# ktlint installation
    && curl --retry 5 --retry-delay 5 -sSLO https://github.com/pinterest/ktlint/releases/latest/download/ktlint && \
    chmod a+x ktlint && \
    mv "ktlint" /usr/bin/ \

# kubeval installation
    && ML_THIRD_PARTY_DIR="/third-party/kubeval" \
    && mkdir -p ${ML_THIRD_PARTY_DIR} \
    && wget -P ${ML_THIRD_PARTY_DIR} -q https://github.com/instrumenta/kubeval/releases/latest/download/kubeval-linux-amd64.tar.gz \
    && tar xf ${ML_THIRD_PARTY_DIR}/kubeval-linux-amd64.tar.gz --directory ${ML_THIRD_PARTY_DIR} \
    && mv ${ML_THIRD_PARTY_DIR}/kubeval /usr/local/bin \
    && rm ${ML_THIRD_PARTY_DIR}/kubeval-linux-amd64.tar.gz \
    && find ${ML_THIRD_PARTY_DIR} -type f -not -name 'LICENSE*' -delete -o -type d -empty -delete \

# kubeconform installation
    && ML_THIRD_PARTY_DIR="/third-party/kubeconform" \
    && KUBECONFORM_VERSION=v0.5.0 \
    && mkdir -p ${ML_THIRD_PARTY_DIR} \
    && wget -P ${ML_THIRD_PARTY_DIR} -q https://github.com/yannh/kubeconform/releases/download/$KUBECONFORM_VERSION/kubeconform-linux-amd64.tar.gz \
    && tar xf ${ML_THIRD_PARTY_DIR}/kubeconform-linux-amd64.tar.gz --directory ${ML_THIRD_PARTY_DIR} \
    && mv ${ML_THIRD_PARTY_DIR}/kubeconform /usr/local/bin \
    && rm ${ML_THIRD_PARTY_DIR}/kubeconform-linux-amd64.tar.gz \
    && find ${ML_THIRD_PARTY_DIR} -type f -not -name 'LICENSE*' -delete -o -type d -empty -delete \

# chktex installation
# Managed with COPY --from=chktex /usr/bin/chktex /usr/bin/
    && cd ~ && touch .chktexrc && cd / \

# luacheck installation
    && wget --tries=5 https://www.lua.org/ftp/lua-5.3.5.tar.gz -O - -q | tar -xzf - \
    && cd lua-5.3.5 \
    && make linux \
    && make install \
    && cd .. && rm -r lua-5.3.5/ \
    && wget --tries=5 https://github.com/cvega/luarocks/archive/v3.3.1-super-linter.tar.gz -O - -q | tar -xzf - \
    && cd luarocks-3.3.1-super-linter \
    && ./configure --with-lua-include=/usr/local/include \
    && make \
    && make -b install \
    && cd .. && rm -r luarocks-3.3.1-super-linter/ \
    && luarocks install luacheck \
    && cd / \

# checkmake installation
    && ( [ -d /usr/local/bin ] || mkdir -p /usr/local/bin ) \
    && wget -q "https://github.com/mrtazz/checkmake/releases/download/0.2.1/checkmake-0.2.1.linux.amd64" -O /usr/local/bin/checkmake \
    && chmod 755 /usr/local/bin/checkmake \

# perlcritic installation
    && curl --retry 5 --retry-delay 5 -sL https://cpanmin.us/ | perl - -nq --no-wget Perl::Critic \

# phpcs installation
    && phive --no-progress install phpcs -g --trust-gpg-keys 31C7E470E2138192 \

# phpstan installation
    && phive --no-progress install phpstan -g --trust-gpg-keys CF1A108D0E7AE720 \

# psalm installation
    && phive --no-progress install psalm -g --trust-gpg-keys 8A03EA3B385DBAA1,12CE0F1D262429A5 \

# phplint installation
    && composer global require --ignore-platform-reqs overtrue/phplint ^5.3 \
    && composer global config bin-dir --absolute \

# powershell installation
    && pwsh -c 'Install-Module -Name PSScriptAnalyzer -RequiredVersion ${PSSA_VERSION} -Scope AllUsers -Force' \

# powershell_formatter installation
# Next line commented because already managed by another linter
# RUN pwsh -c 'Install-Module -Name PSScriptAnalyzer -RequiredVersion ${PSSA_VERSION} -Scope AllUsers -Force'

# protolint installation
# Managed with COPY --from=protolint /usr/local/bin/protolint /usr/bin/

# lintr installation
    && mkdir -p /home/r-library \
    && cp -r /usr/lib/R/library/ /home/r-library/ \
    && Rscript -e "install.packages(c('lintr','purrr'), repos = 'https://cloud.r-project.org/')" \
    && R -e "install.packages(list.dirs('/home/r-library',recursive = FALSE), repos = NULL, type = 'source')" \

# raku installation
    && curl -L https://github.com/nxadm/rakudo-pkg/releases/download/v2020.10-02/rakudo-pkg-Alpine3.12_2020.10-02_x86_64.apk > rakudo-pkg-Alpine3.12_2020.10-02_x86_64.apk \
    && apk add --no-cache --allow-untrusted rakudo-pkg-Alpine3.12_2020.10-02_x86_64.apk \
    && rm rakudo-pkg-Alpine3.12_2020.10-02_x86_64.apk \
    && /opt/rakudo-pkg/bin/add-rakudo-to-path \
    # && source /root/.profile \
    && /opt/rakudo-pkg/bin/install-zef-as-user

ENV PATH="~/.raku/bin:/opt/rakudo-pkg/bin:/opt/rakudo-pkg/share/perl6/site/bin:$PATH"

# devskim installation
# Next line commented because already managed by another linter
# RUN wget --tries=5 -q -O dotnet-install.sh https://dot.net/v1/dotnet-install.sh \
#     && chmod +x dotnet-install.sh \
#     && ./dotnet-install.sh --install-dir /usr/share/dotnet -channel 6.0 -version latest
# Next line commented because already managed by another linter
# ENV PATH="${PATH}:/root/.dotnet/tools:/usr/share/dotnet"
RUN dotnet tool install --global Microsoft.CST.DevSkim.CLI \

# dustilock installation
    && ML_THIRD_PARTY_DIR=/download/dustilock && \
    mkdir -p ${ML_THIRD_PARTY_DIR} && \
    git clone https://github.com/Checkmarx/dustilock.git ${ML_THIRD_PARTY_DIR} && \
    cd ${ML_THIRD_PARTY_DIR} && \
    go build && go clean --cache && \
    chmod +x dustilock && \
    mv "${ML_THIRD_PARTY_DIR}/dustilock" /usr/bin/ && \
    find ${ML_THIRD_PARTY_DIR} -type f -not -name 'LICENSE*' -delete -o -type d -empty -delete && \
    cd / \

# gitleaks installation
# Managed with COPY --from=gitleaks /usr/bin/gitleaks /usr/bin/

# syft installation
    && curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin \

# trivy installation
    && wget --tries=5 -q -O - https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin \

# sfdx-scanner-apex installation
    && sfdx plugins:install @salesforce/sfdx-scanner \
    && npm cache clean --force || true \
    && rm -rf /root/.npm/_cacache \

# sfdx-scanner-aura installation
# Next line commented because already managed by another linter
# RUN sfdx plugins:install @salesforce/sfdx-scanner \
#     && npm cache clean --force || true \
#     && rm -rf /root/.npm/_cacache

# sfdx-scanner-lwc installation
# Next line commented because already managed by another linter
# RUN sfdx plugins:install @salesforce/sfdx-scanner \
#     && npm cache clean --force || true \
#     && rm -rf /root/.npm/_cacache

# scalafix installation
    && ./coursier install scalafix --quiet --install-dir /usr/bin && rm -rf /root/.cache \

# misspell installation
    && ML_THIRD_PARTY_DIR="/third-party/misspell" \
    && mkdir -p ${ML_THIRD_PARTY_DIR} \
    && curl -L -o ${ML_THIRD_PARTY_DIR}/install-misspell.sh https://git.io/misspell \
    && sh .${ML_THIRD_PARTY_DIR}/install-misspell.sh \
    && find ${ML_THIRD_PARTY_DIR} -type f -not -name 'LICENSE*' -delete -o -type d -empty -delete \
    && find /tmp -path '/tmp/tmp.*' -type f -name 'misspell*' -delete -o -type d -empty -delete \

# tsqllint installation
# Next line commented because already managed by another linter
# RUN wget --tries=5 -q -O dotnet-install.sh https://dot.net/v1/dotnet-install.sh \
#     && chmod +x dotnet-install.sh \
#     && ./dotnet-install.sh --install-dir /usr/share/dotnet -channel 6.0 -version latest
# Next line commented because already managed by another linter
# ENV PATH="${PATH}:/root/.dotnet/tools:/usr/share/dotnet"
    && dotnet tool install --global TSQLLint \

# tflint installation
# Managed with COPY --from=tflint /usr/local/bin/tflint /usr/bin/

# terrascan installation
# Managed with COPY --from=terrascan /go/bin/terrascan /usr/bin/

# terragrunt installation
# Managed with COPY --from=terragrunt /usr/local/bin/terragrunt /usr/bin/

# terraform-fmt installation
# Managed with COPY --from=terragrunt /bin/terraform /usr/bin/

# kics installation
# Managed with COPY --from=kics /app/bin/kics /usr/bin/
    && mkdir -p /opt/kics/assets
ENV KICS_QUERIES_PATH=/opt/kics/assets/queries KICS_LIBRARIES_PATH=/opt/kics/assets/libraries
# Managed with COPY --from=kics /app/bin/assets /opt/kics/assets/

#OTHER__END

################################
# Installs python dependencies #
################################
COPY megalinter /megalinter
RUN PYTHONDONTWRITEBYTECODE=1 python /megalinter/setup.py install \
    && PYTHONDONTWRITEBYTECODE=1 python /megalinter/setup.py clean --all \
    && rm -rf /var/cache/apk/* \
    && find . | grep -E "(/__pycache__$|\.pyc$|\.pyo$)" | xargs rm -rf

#######################################
# Copy scripts and rules to container #
#######################################
COPY megalinter/descriptors /megalinter-descriptors
COPY TEMPLATES /action/lib/.automation

###########################
# Get the build arguments #
###########################
ARG BUILD_DATE
ARG BUILD_REVISION
ARG BUILD_VERSION

#################################################
# Set ENV values used for debugging the version #
#################################################
ENV BUILD_DATE=$BUILD_DATE \
    BUILD_REVISION=$BUILD_REVISION \
    BUILD_VERSION=$BUILD_VERSION

#FLAVOR__START
ENV MEGALINTER_FLAVOR=all
#FLAVOR__END

#########################################
# Label the instance and set maintainer #
#########################################
LABEL com.github.actions.name="MegaLinter" \
      com.github.actions.description="The ultimate linters aggregator to make sure your projects are clean" \
      com.github.actions.icon="code" \
      com.github.actions.color="red" \
      maintainer="Nicolas Vuillamy <nicolas.vuillamy@gmail.com>" \
      org.opencontainers.image.created=$BUILD_DATE \
      org.opencontainers.image.revision=$BUILD_REVISION \
      org.opencontainers.image.version=$BUILD_VERSION \
      org.opencontainers.image.authors="Nicolas Vuillamy <nicolas.vuillamy@gmail.com>" \
      org.opencontainers.image.url="https://megalinter.io" \
      org.opencontainers.image.source="https://github.com/oxsecurity/megalinter" \
      org.opencontainers.image.documentation="https://megalinter.io" \
      org.opencontainers.image.vendor="Nicolas Vuillamy" \
      org.opencontainers.image.description="Lint your code base with GitHub Actions"

#EXTRA_DOCKERFILE_LINES__START
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x entrypoint.sh
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
#EXTRA_DOCKERFILE_LINES__END
