# Docker image for Jupyter notebook environment

## Main Objective

Provide Jupyter notebook environment which includes;
- OS: ubuntu
- Basic libraries (jupyter, numpy, pandas + libraries described in `context/pythonlib/requirements.txt`)

## Usage

### Build

1. Edit `context/pythonlib/requirements.txt` to change Python libraries to be installed
2. run `build.sh ${PASSWORD_FOR_USER}`

### Run

1. Put `run.sh` or `run.bat` on the directory you want to save all the notebooks (Docker container mount current directory)
2. Execute `run.sh ${PORT}` or `run.bat ${PORT}`
3. Access notebook `localhost:${PORT}` on your browser
