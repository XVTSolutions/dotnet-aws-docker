# This is to build xvtsolutions/dotnet-aspnetcore-runtime-aws:<dotnet_version>
# docker build -t xvtsolutions/dotnet-aspnetcore-runtime-aws .
# docker tag xvtsolutions/dotnet-aspnetcore-runtime-aws xvtsolutions/dotnet-aspnetcore-runtime-aws:<dotnet_version>

# Based on the previous status this is not a for build, but runtime only.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.0

RUN apt-get update && apt-get -y upgrade && apt-get install -y awscli python3-pip && apt-get clean

RUN pip3 install -U boto3
