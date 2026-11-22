# Jupyter Notebook in Docker

This image runs Notebook 7 on Ubuntu 24.04 with Python 3.12 and includes
pandas, NumPy, SciPy, scikit-learn, SHAP, and causalml. Use
`shap.TreeExplainer` in notebooks that previously used FastTreeSHAP.

## Build and run on Apple Silicon

Start Docker Desktop, then build from the repository checkout:

```sh
./build.sh
```

The scripts use `linux/amd64` so the pinned Python dependencies can all install
from wheels. Docker Desktop runs this image under emulation on Apple Silicon,
which can be slower than running a native image.

From the directory where you want to save notebooks, run the launcher by its
path (use `./run.sh 8888` if you are already in the checkout):

```sh
/path/to/notebook_docker/run.sh 8888
```

On Windows, run `run.bat 8888` from the workspace directory. Both launchers
mount the current directory and expose Jupyter only on localhost. Choose a
different host port if 8888 is already in use.

Open the URL containing the generated token from the startup output. You can
also retrieve it while the container is running with `docker ps` followed by
`docker logs <container-id>`. If you chose a different host port, replace
`8888` in the logged URL with that port and retain the token.

## Try a native arm64 build

From the repository checkout, try the existing pins with a separate image tag:

```sh
docker build --platform linux/arm64 --build-arg "USERID=$(id -u)" -t my_notebook:arm64 .
docker run --rm --platform linux/arm64 -p 127.0.0.1:8888:8888 \
  -v "$PWD:/home/neo/notebook_workspace" my_notebook:arm64
```

If a pinned wheel is unavailable for arm64, try resolving the dependencies in
a separate checkout using the command below with
`--python-platform aarch64-manylinux_2_28`. Keep the amd64 lockfile for the
default build.

## Update Python dependencies

Edit `context/pythonlib/requirements.in`, then regenerate the pinned
requirements from the repository root:

```sh
uv pip compile --python-version 3.12 --python-platform x86_64-manylinux_2_28 \
  --only-binary :all: context/pythonlib/requirements.in -o context/pythonlib/requirements.txt
```

Add `--upgrade` to refresh existing pins. The image installs the pinned
requirements into a virtual environment and runs `pip check`.
