#!/bin/bash -e

# Run this script to bring up the last up-to-date version of the current m$
# dotnet image and build the coresponding xvt ones.
echo "Current dotnet version: 3.0."

# Build the ASPNETCORE images
docker pull mcr.microsoft.com/dotnet/core/aspnet:3.0
FULL_VERSION_TAG=$(docker run --rm mcr.microsoft.com/dotnet/core/aspnet:3.0 dotnet --info | grep Version | awk '{print $2}')

docker build -t xvtsolutions/dotnet-aspnetcore-runtime-aws:$FULL_VERSION_TAG -f Dockerfile.dotnet-aspnetcore-runtime-aws .
docker tag xvtsolutions/dotnet-aspnetcore-runtime-aws:$FULL_VERSION_TAG xvtsolutions/dotnet-aspnetcore-runtime-aws:latest

docker build -t xvtsolutions/dotnet-aspnetcore-runtime-aws-newrelic:$FULL_VERSION_TAG -f Dockerfile.dotnet-aspnetcore-runtime-aws-newrelic .
docker tag xvtsolutions/dotnet-aspnetcore-runtime-aws-newrelic:$FULL_VERSION_TAG xvtsolutions/dotnet-aspnetcore-runtime-aws-newrelic:latest

docker build -t xvtsolutions/dotnet-aspnetcore-runtime-aws-unoconv:$FULL_VERSION_TAG -f Dockerfile.dotnet-aspnetcore-runtime-aws-unoconv .
docker tag xvtsolutions/dotnet-aspnetcore-runtime-aws-unoconv:$FULL_VERSION_TAG xvtsolutions/dotnet-aspnetcore-runtime-aws-unoconv:latest

docker build -t xvtsolutions/dotnet-runtime-aws:${FULL_VERSION_TAG} -f Dockerfile.dotnet-console-runtime .
docker tag xvtsolutions/dotnet-runtime-aws:${FULL_VERSION_TAG} xvtsolutions/dotnet-runtime-aws:latest

echo
echo "############"
echo "Completed build for the following ASPNETCORE images:"
echo
echo "xvtsolutions/dotnet-aspnetcore-runtime-aws:$FULL_VERSION_TAG"
echo "xvtsolutions/dotnet-aspnetcore-runtime-aws-newrelic:$FULL_VERSION_TAG"
echo "xvtsolutions/dotnet-aspnetcore-runtime-aws-unoconv:$FULL_VERSION_TAG"
echo "xvtsolutions/dotnet-aspnetcore-runtime-aws-unoconv-newrelic:$FULL_VERSION_TAG"
echo
echo "############"

# Build the RUNTIME images
docker pull mcr.microsoft.com/dotnet/core/runtime:3.0

FULL_VERSION_TAG=$(docker run --rm mcr.microsoft.com/dotnet/core/runtime:3.0 dotnet --info | grep Version | awk '{print $2}')

docker build -t xvtsolutions/dotnet-runtime-aws-unoconv:$FULL_VERSION_TAG -f Dockerfile.runtime.unoconv .
docker tag  xvtsolutions/dotnet-runtime-aws-unoconv:$FULL_VERSION_TAG  xvtsolutions/dotnet-runtime-aws-unoconv:latest

docker build -t xvtsolutions/dotnet-aspnetcore-runtime-aws-unoconv-newrelic:$FULL_VERSION_TAG -f Dockerfile.dotnet-aspnetcore-runtime-aws-unoconv-newrelic .
docker tag xvtsolutions/dotnet-aspnetcore-runtime-aws-unoconv-newrelic:$FULL_VERSION_TAG xvtsolutions/dotnet-aspnetcore-runtime-aws-unoconv-newrelic:latest

echo
echo "############"
echo "Completed build for the following RUNTIME images:"
echo
echo "xvtsolutions/dotnet-runtime-aws:${FULL_VERSION_TAG}"
echo "xvtsolutions/dotnet-runtime-aws-unoconv:$FULL_VERSION_TAG"
echo
echo "############"

# SDK Images
docker pull mcr.microsoft.com/dotnet/core/sdk:3.0
FULL_VERSION_TAG=$(docker run --rm mcr.microsoft.com/dotnet/core/sdk:3.0 dotnet --version)

docker build -t xvtsolutions/dotnet-sdk-sonar-scanner:${FULL_VERSION_TAG} -f Dockerfile.sonar-scanner .
docker tag xvtsolutions/dotnet-sdk-sonar-scanner:${FULL_VERSION_TAG} xvtsolutions/dotnet-sdk-sonar-scanner:latest

echo
echo "############"
echo "Completed build for the following SDK images:"
echo
echo "xvtsolutions/dotnet-sdk-sonar-scanner:${FULL_VERSION_TAG}"
echo
echo "############"

echo
echo "############"
echo "Completed build for all images."
echo "You have to login docker hub and push it manually if it is ready"
echo
echo "############"
