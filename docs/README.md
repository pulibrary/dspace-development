# DSpace Development for the Princeton University Library

## Sphinx Documentation
Currently, documentation for using DSpace utilities is generated using [Sphinx](https://www.sphinx-doc.org/en/master/). This may be built locally, or more readily accessed using the [Read the docs](https://readthedocs.org/) service on <https://dspace-development.readthedocs.io/en/latest/>.

### Building the Documentation

First, please use the following to initialize the Python environment:
```bash
asdf local python 3.9.0 # or pyenv local 3.9.0
pip install pipenv
pipenv shell
pipenv sync
```

Then, please invoke the following to build the documentation locally:
```bash
cd docs
pipenv run sphinx-build -b html . _build
open _build/index.html
```
