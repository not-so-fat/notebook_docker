# JupyterLab in Docker

This image runs JupyterLab on Ubuntu 24.04 with Python 3.12 and includes
pandas, NumPy, SciPy, scikit-learn, SHAP, and causalml. Use
`shap.TreeExplainer` in notebooks that previously used FastTreeSHAP.

## Use it from any folder

Install and start Docker Desktop. Clone the repository and build the
`my_notebook:0.0` image once:

```sh
git clone https://github.com/not-so-fat/notebook_docker.git ~/tools/notebook_docker
cd ~/tools/notebook_docker
./build.sh
```

The build targets `linux/amd64` for Python wheel availability. Docker Desktop
emulates amd64 on Apple Silicon, so it can be slower than a native image.

If you already built an earlier image, rerun `./build.sh` to update it.

Add a symlink to the [launcher](bin/notebook) in a directory on your PATH:

```sh
ln -s ~/tools/notebook_docker/bin/notebook /usr/local/bin/notebook
```

If `/usr/local/bin` is unwritable or outside your PATH, use `~/.local/bin`
and add it to your PATH if needed:

```sh
mkdir -p ~/.local/bin
ln -s ~/tools/notebook_docker/bin/notebook ~/.local/bin/notebook
export PATH="$HOME/.local/bin:$PATH"
```

To keep that PATH change for future terminals, add the export to your shell
startup file. Launch JupyterLab from the directory where you want to work:

```sh
cd ~/Documents/my-analysis && notebook
```

The current directory is the workspace, so files persist there. Press Ctrl-C
to stop Jupyter and remove the container. The launcher publishes Jupyter on
`127.0.0.1` only, prints the token URL, and opens it in the browser when
available. It starts at port 8888 and picks the next free port when needed.
Use `notebook 9000` to start the search at port 9000, or `notebook --help` for usage.
The launcher opens `/lab`. To use the Notebook interface, visit `/tree` on
the same host and port after signing in.

## Run without installing the launcher

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
