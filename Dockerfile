FROM microsoft/aspnetcore:2.0

RUN apt-get update && apt-get -y upgrade && apt-get install -y awscli python3-pip

RUN pip3 install -U boto3
