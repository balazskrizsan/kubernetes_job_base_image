FROM google/cloud-sdk:alpine AS gcp
FROM ghcr.io/getsops/sops:v3.9.4-alpine AS sops
FROM postgres:16.2 AS postgres

FROM alpine:latest

COPY --from=gcp /google-cloud-sdk /google-cloud-sdk
COPY --from=sops /usr/local/bin/sops /usr/local/bin/sops
COPY --from=postgres /usr/lib /usr/lib
COPY --from=postgres /usr/bin /usr/bin

ENV PATH=$PATH:/google-cloud-sdk/bin

RUN apk add --no-cache aws-cli curl ca-certificates \
    && curl -LO "https://dl.k8s.io/release/v1.32.2/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/
