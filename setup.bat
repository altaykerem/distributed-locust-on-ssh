@ECHO OFF
::===============================================================
:: The below program runs a locust setup on aws instances
::
::===============================================================

:: Set variables
SET keyDir="<identity file>"
SET locustDir="<directory of the locust file on the server>"
SET masterHost="<IP/DNS>"
SET workerHost[0]="<IP/DNS>"
SET workerHost[1]="<IP/DNS>"
SET workerCPU=2

:: Cheat commands
ECHO "http://%masterHost%:8089/"

:: Run locust master
start cmd.exe /k "ssh -i %keyDir% ec2-user@%masterHost% ""source locust-env/bin/activate; cd %keyDir%;locust -f locustfile.py --master"""

:: Run locust workers
:: For each worker, run locust for each CPU

set i=0
:workerLoop
if defined workerHost[%i%] (
    for /l %%x in (1, 1, %workerCPU%) do (
        start cmd.exe /k "ssh -i %keyDir% ec2-user@%%workerHost[%i%]%% ""source locust-env/bin/activate; cd %keyDir%;locust -f locustfile.py --worker --master-host=%masterHost%"""
    )
    set /a "i+=1"
    GOTO :workerLoop
)

START "" "http://%masterHost%:8089/"

PAUSE
