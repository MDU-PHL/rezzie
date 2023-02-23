"""
A small library for accessing internal resources and data shipped with your
package without using the pkg_resources API or the __file__ attribute.
"""

# package metadata
__version__ = "0.1.0"


# public API

import atexit
import importlib.resources
from contextlib import ExitStack


def get_path(module, *path):
    """
    Return a path to a resource shipped with your package. The path will last
    for the duration of test execution, and will be cleaned up automatically.
    This requires Python 3.9 or later.
    """
    file_manager = ExitStack()
    atexit.register(file_manager.close)
    ref = importlib.resources.files(module).joinpath(*path)
    path = file_manager.enter_context(importlib.resources.as_file(ref))
    return path
