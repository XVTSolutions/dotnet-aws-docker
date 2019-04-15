Description
-----------

This is the docker files and update script used to build a series of docker
images used by XVT and publish in docker hub.

It provides:

- dotnet console runtime envronment
- dotnet aspnetcore
- aws cli
- python3 with boto, botocore and boto3 library
- unoconv and its dependencies to be used for PDF converter

The idea is building the final application image which has a entry script as a
python script. The python script can fetch the run time configuration variables
from AWS SSM parameter store and export it into the environments before doing a
`execvpe` the final dotnet to start the dotnet app.

*Update to the latest dotnet version from base image*

Have a look at script `update-dotnet.sh` and then run it.

*Example of the entry point python script*

```
#!/usr/bin/python3

import boto3
import os

ENV = os.environ.get('ENV', 'int')
REGION = os.environ.get('AWS_REGION', 'ap-southeast-2')

# Clear up to be sure the session wont take any accidently wrong AWS
# Credential and use the task role instead.

try:
    del os.environ['AWS_ACCESS_KEY_ID']
    del os.environ['AWS_SECRET_ACCESS_KEY']
except:
    pass

session = boto3.session.Session(region_name=REGION)

ssm = session.client('ssm')

output_from_aws_fetch = ssm.get_parameters(
        Names=[
                'param_key1',
                'param_key2'
            ],
        WithDecryption=True
    )

parameters = output_from_aws_fetch['Parameters']

for param in parameters:
    os.environ.update(
            {
              param['Name']: param['Value']
            }
        )

print("DEBUG: Executing dotnet using 'execvpe dotnet ... ")
os.execvpe("dotnet", ["dotnet", "Application.dll"], os.environ)

```

*Example of the final app Docker file*

```
FROM xvtsolutions/dotnet-aspnetcore-runtime-aws:2.1.4

ENV KESTREL_PORT 80
EXPOSE 80

# Copying build result and entry point script
WORKDIR /app
COPY obj/Docker/publish .
COPY docker_entry_point.py .

ENTRYPOINT ["/app/docker_entry_point.py"]

```
