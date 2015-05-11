"""A companion module to sys"""
import sys
from dotsite.paths import path as Path


paths = []


def refresh_paths():
    """Refresh the module-level paths"""
    paths[:] = []
    for p in sys.path:
        paths.append(Path(p))


def get_refreshed_paths():
    """Refresh the module-level paths and return it"""
    refresh_paths()
    return paths


def sites(some_paths=None):
    """All items in some_paths which have "site-"

    Uses sis.paths by default, so gives all the site- paths from sys
    """
    if not some_paths:
        some_paths = paths
    return [l for l in some_paths if 'site-' in l]


def site_packages(some_paths=None):
    """All items in some_paths with basename "site-packages"

    Uses sis.paths by default, so gives all site-packages from sys"""
    if not some_paths:
        some_paths = paths
    return [p for p in some_paths if p.basename() == 'site-packages']


refresh_paths()
