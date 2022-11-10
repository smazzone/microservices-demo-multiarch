# Copyright 2021 Google LLC
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

#FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
FROM mcr.microsoft.com/dotnet/sdk:6.0.200-focal-arm64v8 as builder




WORKDIR /app
COPY . .
RUN dotnet restore cartservice.csproj
RUN dotnet build "./cartservice.csproj" -c Release -r linux-arm64 -o /out

# FROM builder AS publish
RUN dotnet publish cartservice.csproj -c Release -r linux-arm64 -o /out

# Building final image used in running container
#FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
#FROM mcr.microsoft.com/dotnet/aspnet:6.0.8-focal-arm64v8 AS final

FROM mcr.microsoft.com/dotnet/sdk:6.0.200-focal-arm64v8 AS final

#FROM mcr.microsoft.com/dotnet/runtime-deps:6.0.2-focal-arm64v8

RUN apt-get update -y
RUN apt-get install -y wget
RUN apt-get install -y curl

# Download and install the Datadog Tracer
#ENV TRACER_VERSION=2.14.0
RUN mkdir -p /opt/datadog \
    && mkdir -p /var/log/datadog \
    && TRACER_VERSION=$(curl -s https://api.github.com/repos/DataDog/dd-trace-dotnet/releases/latest | grep tag_name | cut -d '"' -f 4 | cut -c2-) \
    && curl -LO https://github.com/DataDog/dd-trace-dotnet/releases/download/v${TRACER_VERSION}/datadog-dotnet-apm_${TRACER_VERSION}_arm64.deb \
    && dpkg -i ./datadog-dotnet-apm_${TRACER_VERSION}_arm64.deb \
    && /opt/datadog/createLogPath.sh \
    && rm ./datadog-dotnet-apm_${TRACER_VERSION}_arm64.deb

RUN GRPC_HEALTH_PROBE_VERSION=v0.4.11 && \
     wget -qO/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-arm64 && \
    chmod +x /bin/grpc_health_probe


WORKDIR /app
COPY --from=builder /out .
ENV ASPNETCORE_URLS=http://*:7070
# Enable the tracer
ENV CORECLR_ENABLE_PROFILING=1
ENV CORECLR_PROFILER={846F5F1C-F9AE-4B07-969E-05C26BC060D8}
ENV CORECLR_PROFILER_PATH=/opt/datadog/Datadog.Trace.ClrProfiler.Native.so
ENV DD_DOTNET_TRACER_HOME=/opt/datadog
ENV DD_INTEGRATIONS=/opt/datadog/integrations.json
ENV LD_PRELOAD=/opt/datadog/continuousprofiler/Datadog.Linux.ApiWrapper.x64.so
ENV DD_PROFILING_ENABLED=1
# ENV DD_TRACE_DEBUG=1
ENTRYPOINT ["dotnet", "cartservice.dll"]
