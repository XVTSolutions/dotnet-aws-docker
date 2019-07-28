#!/bin/bash -e

# Run this script to bring up the last up-to-date version of the current m$
# dotnet image and build the coresponding xvt ones.

DOTNET_VERSION="2.2"

echo "Current dotnet version: $DOTNET_VERSION."

docker pull microsoft/dotnet:${DOTNET_VERSION}-aspnetcore-runtime

FULL_VERSION_TAG=$(docker run --rm microsoft/dotnet:2.2-aspnetcore-runtime dotnet --info | grep Version | awk '{print $2}')

docker build -t xvtsolutions/dotnet-aspnetcore-runtime-aws:$FULL_VERSION_TAG -f Dockerfile.dotnet-aspnetcore-runtime-aws .
docker tag xvtsolutions/dotnet-aspnetcore-runtime-aws:$FULL_VERSION_TAG xvtsolutions/dotnet-aspnetcore-runtime-aws:latest

docker build -t xvtsolutions/dotnet-aspnetcore-runtime-aws-newrelic:$FULL_VERSION_TAG -f Dockerfile.dotnet-aspnetcore-runtime-aws-newrelic .
docker tag xvtsolutions/dotnet-aspnetcore-runtime-aws-newrelic:$FULL_VERSION_TAG xvtsolutions/dotnet-aspnetcore-runtime-aws-newrelic:latest

docker build -t xvtsolutions/dotnet-aspnetcore-runtime-aws-unoconv:$FULL_VERSION_TAG -f Dockerfile.dotnet-aspnetcore-runtime-aws-unoconv .
docker tag xvtsolutions/dotnet-aspnetcore-runtime-aws-unoconv:$FULL_VERSION_TAG xvtsolutions/dotnet-aspnetcore-runtime-aws-unoconv:latest

docker pull microsoft/dotnet:${DOTNET_VERSION}-runtime
docker build -t xvtsolutions/dotnet-runtime-aws:${FULL_VERSION_TAG} -f Dockerfile.dotnet-console-runtime .
docker tag xvtsolutions/dotnet-runtime-aws:${FULL_VERSION_TAG} xvtsolutions/dotnet-runtime-aws:latest

docker build -t xvtsolutions/dotnet-runtime-aws-unoconv:$FULL_VERSION_TAG -f Dockerfile.runtime.unoconv .
docker tag  xvtsolutions/dotnet-runtime-aws-unoconv:$FULL_VERSION_TAG  xvtsolutions/dotnet-runtime-aws-unoconv:latest

docker build -t xvtsolutions/dotnet-aspnetcore-runtime-aws-unoconv-newrelic:$FULL_VERSION_TAG -f Dockerfile.dotnet-aspnetcore-runtime-aws-unoconv-newrelic .
docker tag xvtsolutions/dotnet-aspnetcore-runtime-aws-unoconv-newrelic:$FULL_VERSION_TAG xvtsolutions/dotnet-aspnetcore-runtime-aws-unoconv-newrelic:latest

# sonar scanner

docker pull microsoft/dotnet:2.2-sdk
FULL_VERSION_TAG=$(docker run --rm microsoft/dotnet:2.2-sdk dotnet --version)
docker build -t xvtsolutions/dotnet-sdk-sonar-scanner:${FULL_VERSION_TAG} -f Dockerfile.sonar-scanner .

echo
echo "############"
echo "Completed build for the following images:"
echo
echo "xvtsolutions/dotnet-aspnetcore-runtime-aws:$FULL_VERSION_TAG"
echo "xvtsolutions/dotnet-aspnetcore-runtime-aws-newrelic:$FULL_VERSION_TAG"
echo "xvtsolutions/dotnet-aspnetcore-runtime-aws-unoconv:$FULL_VERSION_TAG"
echo "xvtsolutions/dotnet-aspnetcore-runtime-aws-unoconv-newrelic:$FULL_VERSION_TAG"
echo "xvtsolutions/dotnet-runtime-aws:${FULL_VERSION_TAG}"
echo "xvtsolutions/dotnet-runtime-aws-unoconv:$FULL_VERSION_TAG"
echo
echo "You have to login docker hub and push it manually if it is ready"
echo
echo "############"

