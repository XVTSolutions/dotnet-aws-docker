# This is to build xvtsolutions/dotnet-aspnetcore-runtime-aws:2.1
# docker build -t xvtsolutions/dotnet-aspnetcore-runtime-aws .
# docker tag xvtsolutions/dotnet-aspnetcore-runtime-aws xvtsolutions/dotnet-aspnetcore-runtime-aws:2.1

# Based on the previous status this is not a for build, but runtime only.

FROM microsoft/dotnet:2.2-aspnetcore-runtime

RUN apt-get update && apt-get -y upgrade && apt-get install -y awscli python3-pip && apt-get clean

RUN pip3 install -U boto3
