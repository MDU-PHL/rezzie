"""
A small library for accessing internal resources and data shipped with your
package without using the pkg_resources API or the __file__ attribute.
"""

# package metadata
__version__ = "1.0.0"


# public API

import sys
import pathlib

if sys.version_info < (3, 9):
    from importlib_resources import files

    def get_path(module: str, *path: str) -> pathlib.Path:
        """
        Return a path to a resource shipped with your package. The path will last
        for the duration of test execution, and will be cleaned up automatically.
        This code works with versions of python 3.6 to 3.8.
        """
        path = files(module).joinpath(*path)
        return path

else:
    import atexit
    import importlib.resources
    from contextlib import ExitStack

    def get_path(module: str, *path: setattr) -> pathlib.Path:
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
