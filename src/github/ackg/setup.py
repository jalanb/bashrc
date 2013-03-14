'setup'

from setuptools import setup

import imp


def get_version():
    '''read version var from script'''
    ver_file = None
    try:
        imp.load_source('ackg', 'bin/ackg')
        import ackg
        version = ackg.VERSION
        return version
    finally:
        if ver_file is not None:
            ver_file.close()


setup(name='ackg',
      version=get_version(),
      scripts=["bin/ackg", "bin/group_grep_output"],
      install_requires=[],
      author="Thibault Kruse",
      author_email="thibault.kruse@gmx.de",
      url="https://github.com/tkruse/ackg",
      download_url="https://github.com/tkruse/ackg",
      keywords=["grep", "python", "linux"],
      classifiers=["Programming Language :: Python",
                   "License :: OSI Approved :: BSD License"],
      description=("Script wrapping GNU find, xargs/parallel," +
                   "grep to search code for pattern"),
      long_description="""With ackg for Linux you can search folders
of your harddrive for source files containing a given pattern, similar
to grep.""",
      license="BSD")
