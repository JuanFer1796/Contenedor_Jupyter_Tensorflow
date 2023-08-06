FROM ubuntu:18.04

RUN apt update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt update && apt-get install -y python3.8 python3-pip python3.8-dev
RUN python3.8 -m pip install --upgrade pip

# Copy file into containers working dir 
COPY requirements.txt . 

# Install jupyter and python packages
RUN python3.8 -m pip install jupyter
RUN python3.8 -m pip install -r requirements.txt

# Create and enter project folder
RUN mkdir project
WORKDIR /project

# Start jupyter (this runs when container is started)
CMD jupyter notebook --ip 0.0.0.0 --no-browser --allow-root
