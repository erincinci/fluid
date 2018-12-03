#!/usr/bin/env bash
secrets_file="./secrets.env"
virtualenv_dir="./fluid-server"

# Read variables from env file
if [ ! -f ${secrets_file} ]; then
    echo ERROR: Failed to find ${secrets_file}. 1>&2
    exit 1 # terminate and indicate error
fi
source ${secrets_file}

# Create or activate python virtual env
if [ ! -d ${virtualenv_dir} ]; then
    echo "Initialising virtualenv.."
    virtualenv -p python3 fluid-server
fi
source fluid-server/bin/activate

# Update requirement
pip install -q -r requirements.txt

# Start media server
python run.py --host ${FLUID_HOST} --port ${FLUID_PORT} --debug
