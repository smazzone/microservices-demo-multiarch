# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM --platform=$BUILDPLATFORM golang:1.19.3-alpine AS builder
RUN apk add --no-cache ca-certificates git
RUN apk add build-base

WORKDIR /src
# restore dependencies
COPY go.mod go.sum ./
RUN go mod download
COPY . .

ARG BUILDOS 
ARG BUILDARCH
# RUN echo ${BUILDOS}
# RUN echo ${BUILDARCH}

# Skaffold passes in debug-oriented compiler flags
ARG SKAFFOLD_GO_GCFLAGS
RUN GOOS=$BUILDOS GOARCH=$BUILDARCH go build -gcflags="${SKAFFOLD_GO_GCFLAGS}" -o /productcatalogservice .

FROM --platform=$BUILDPLATFORM alpine:3.16.2 AS without-grpc-health-probe-bin
RUN apk add --no-cache ca-certificates

WORKDIR /src
COPY --from=builder /productcatalogservice ./server
COPY products.json .

# Definition of this variable is used by 'skaffold debug' to identify a golang binary.
# Default behavior - a failure prints a stack trace for the current goroutine.
# See https://golang.org/pkg/runtime/
ENV GOTRACEBACK=single

EXPOSE 3550
ENTRYPOINT ["/src/server"]

FROM without-grpc-health-probe-bin
# RUN GRPC_HEALTH_PROBE_VERSION=v0.4.14 && \
#     wget -qO/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-arm64 && \
#     chmod +x /bin/grpc_health_probe

# "change to ARCH=arm if you are on M1 or ARCH=amd if your are on Intel"
# ARG ARCH=arm
# RUN echo $ARCH
# # ENV ARCH=arm
# # RUN echo $ARCH

# RUN GRPC_HEALTH_PROBE_VERSION=v0.4.14 && \
#     wget -qO/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-${ARCH}64 && \
#     chmod +x /bin/grpc_health_probe

ARG TARGETOS 
ARG TARGETARCH
# RUN echo ${TARGETOS}
# RUN echo ${TARGETARCH}

# RUN GRPC_HEALTH_PROBE_VERSION=v0.4.14 && \
#     wget -qO/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-${ARCH}64 && \
#     chmod +x /bin/grpc_health_probe

RUN GRPC_HEALTH_PROBE_VERSION=v0.4.14 && \
    wget -qO/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-${TARGETARCH} && \
    chmod +x /bin/grpc_health_probe