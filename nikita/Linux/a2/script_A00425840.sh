# Linux Assignment 2
# Team Members
# Mohd Nawaz Hussain - A00428036
# Caner Adil Irfanoglu - A00425840

#Question 01
mkdir -p ./out
echo "Directory out created."

# This command creates a directory 'out', if it does not exist where the script resides.

#Question 02
cd ./out
echo "Inside directory out."

#Quesrion 03
wget -N -P ./ http://lnx.cs.smu.ca/docker/Dockerfile
wget -N -P ./ http://lnx.cs.smu.ca/docker/app.py

echo "Dockerfile and app.py inside out directory."

# The command here downloads the two files, but only if they do not exist from previous runs.

#Question 04
date="$(date "+%d")"

echo $date

if ! ((date % 2)); then
    sed -i 's/Hello World!/Today is an even day/g' ./app.py
else
	sed -i 's/Hello World!/Today is an odd day/g' ./app.py
fi

echo "app.py file Hello World! changed depending on the day of the month."

#The command in this function checks if the day of the date is even or not and replaced "Hello World" accordingly.

#Question 05
docker build -t ca_irfanoglu_a2 .

echo "Docker ca_irfanoglu_a2 built."

#The command here builds the docker using my account name.

#Question 06
freeport=0

for port in $(seq 2000  9696); 
do 
echo -ne "\035" | telnet 127.0.0.1 $port > /dev/null 2>&1; 
[ $? -eq 1 ] && echo "$port" && freeport=$port&& break; 
done

echo "Finding free port . . "
#The command above finds a free port between 2000 and 9696 and assigns it to the freeport variable.

docker run -d -p $freeport:80 ca_irfanoglu_a2
echo "Found free port and assigned docker ca_irfanoglu_a2 to it."

#The command above runs the docker on the free port found earlier.

#Question 07
value=$(docker container ls | grep ca_irfanoglu_a2 | cut -d ' ' -f 1 | head -n 1)
echo $value
value_ip=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $value)
echo "Container's IP is $value_ip" 

#The commands above are grepping ca_irfanoglu_a2 value from list of dockers currently existing on the server. 
#It is then grabbing the latest value and getting the IP address from the NetworkSettings for that speicified Docker.

echo "Initializing Trap for in case of unexpected termination of program."

#Trap is set here in case the program terminates unexpectedly in the next commands to be executed.
trap "echo 'Program is terminating...'; docker stop $value; docker rm $value; docker image rm "ca_irfanoglu_a2"; echo 'Termination successful, clean up done.'; exit 0" 2 1 9
echo "Sleeping..."

#The sleep function here is for testing purpose. During the sleep period, CTRL + C can be pressed to test if the trap runs successfully and gracefully exits the docker.
sleep 3

#Question 08,09 & 11
wget_link='localhost:'$freeport
echo $wget_link
wget -O serv.html "$wget_link"
file="./serv.html"
if [ ! -e "$file" ]
then
    echo -e "$0: File '${file}' not found.\nClean up starting..."
    docker stop $value
    docker rm $value
    docker image rm "ca_irfanoglu_a2"
    echo "Clean up finished."
    exit 1
else
    echo -e "Successfully created '${file}'.\nClean up starting..."
    docker stop $value
    docker rm $value
    docker image rm "ca_irfanoglu_a2"
    echo "Clean up finished."
    exit 0
fi

#We first get web page served by docker with wget and save it to 'serv_html'. Then, we do clean up and exit either with a success or an error code. 

#End of program, did not complete optional question 10 as posted on Brightspace. Thank you from Caner and Nawaz.
