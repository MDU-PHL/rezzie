`rezzie`: A small library for accessing resources and data shipped with your 
package without using the pkg_resources API.

## Background

It is a common pattern to ship data files with your Bioinformatic Python packages. 
There are a number of ways of accessing these data files, but they can be
cumbersome and error prone. One common approach, often recommended on on 
StackOverflow, is to use the `__file__` attribute of the module to find the 
path of running script, and from there find the relative path to the resource. 
But, this approach is fragile, and can easily break if the resource is moved, 
and doesn't deal with the case where the resource is in a zip file. 

Another approach is to use the `pkg_resources` API. But, that module is very large
and has a lot of dependencies, which can cause significant startup times for 
your command-line tools.

A third-party package called `importlib_resources` provides a nice API for to 
deal with this problem, and in more recent versions of (Python ≥3.9) it has become
part of the standard library. It is built on the `importlib` API of the standard
library.

Here, we provide a simple library that has a single function to access the path
to any resource shipped with your package. The function returns a `pathlib.Path`
object, which can be used to open the resource as a file and manipulate it as
is needed by your tool.

We have made it so that it supports versions of Python ≥3.6. When using versions
of Python ≥3.9, it uses the standard library `importlib_resources` API, otherwise
it uses the `importlib_resources` package from PyPI. It will only install
the `importlib_resources` package if the Python version version requires. So, it
should keep things lean if you are using a recent version of Python. 

For that reason, and many more, we recommend that you use Python ≥3.10. There are
significant performance improvements in the standard library `importlib` API, and
significant performances in Python overall to warrant the upgrade.

## Installation

You can install `rezzie` from PyPI using `pip`:

    pip install rezzie

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