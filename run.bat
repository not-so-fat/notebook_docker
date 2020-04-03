PORT=%1
docker run --rm -p %PORT%:8888 -v %cd%:/home/neo/notebook_workspace my_notebook:0.0
