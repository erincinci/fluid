#!/usr/bin/env bash
secrets_file="./secrets.env"
virtualenv_dir="./fluid-server"
temp_media_dir="./app/static/tmp"

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

# Create temp media directory if not exist
if [ ! -d ${temp_media_dir} ]; then
    echo "Initialising temp media dir.."
    mkdir ${temp_media_dir}
fi

# Update requirements
echo "Updating Python requirements.."
pip install -q -r requirements.txt
echo "Updating Bower requirements.."
bower install -q

# Start media server
python run.py --host ${FLUID_HOST} --port ${FLUID_PORT} --debug
