# Docker image for Jupyter notebook environment

## Main Objective

Provide Jupyter notebook environment which includes;
- OS: ubuntu
- Basic libraries (pandas, numpy, scipy, sklearn, plotly, matplotlib)
- (Optional) Your own Python libraries

## Usage

### Build

1. Put your wheel package for python libraries under `context/pythonlib`
2. run `build.sh ${PASSWORD_FOR_USER}`

### Run

1. Put `run.sh` or `run.bat` on the directory you want to save all the notebooks (Docker container mount current directory)
2. Execute `run.sh ${PORT}` or `run.bat ${PORT}`
3. Access notebook `localhost:${PORT}` on your browser
