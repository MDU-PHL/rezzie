`rezzie`: A small library for accessing resources and data shipped with your 
package without using the pkg_resources API.

## Background

Shipping data files with your Bioinformatic Python packages is a typical pattern. There are several ways of accessing these data files, but they can be cumbersome and error-prone. One common approach often recommended on StackOverflow is to use the module's `__file__` attribute to find the path of the running script and, from there, find the relative path to the resource. But, this approach is fragile and can easily break if the resource is moved, and it doesn't deal with the case where the resource is in a zip file. Another approach is to use the `pkg_resources` API. But, that module is substantial and has a lot of dependencies, which can cause significant startup times for your command-line tools.

A third-party package called `importlib_resources` provides a nice API to deal with this problem, and in more recent versions of (Python ≥3.9), it has become part of the standard library and is built on the `importlib.resource` API of the standard library.

Here, we provide a simple library that has a single function to access the path to any resource shipped with 

## Installation

You can install `rezzie` from PyPI using `pip`:

```bash
    pip install rezzie
```

## Usage

To use `rezzie`, you need to have a package that has resources that you want to
access. For example, let's say you have a package called `my_package` that has
a resource called `my_resource.txt` in a folder called `data`, that you want to 
access. You can do that using the `rezzie` API as follows:

```python
    from rezzie import get_path

    resource_path = get_path("my_package", "data", "my_resource.txt")
```

The `get_path` function takes two arguments: the name of the package, and the
path and name of the resource.

## Example

Let's say you have a package called `my_package` that has a resource called
`my_resource.txt` in a folder called `data`, that you want to access.

The `my_package` package has the following structure:

```bash
    my_package
    ├── __init__.py
    ├── data
    │   └── my_resource.txt
    └── __main__.py
```

Your `pyproject.toml` file should look like this to ensure the data files are 
packaged correctly (this assumes using `setuptools` as the build backend):

```toml
    [build-system]
    requires = ["setuptools>=42", "wheel"]
    build-backend = "setuptools.build_meta"

    [project]
    name = "my_package"
    
    [tool.setuptools]
    include-package-data = true

    [tool.setuptools.package-data]
    my_package = ["*.txt"]
```

The `my_package/__init__.py` file should look like this:

```python
    from rezzie import get_path

    resource_path = get_path("my_package", "data", "my_resource.txt")
```