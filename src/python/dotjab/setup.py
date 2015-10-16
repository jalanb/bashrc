"""Set up the dotjab project"""


from setuptools import setup


import dotjab


name = 'dotjab'


setup(
    name=name,
    packages=[name],
    version=dotjab.__version__,
    url='https://github.com/jalanb/dotjab/src/python/dotjab',
    license='MIT License',
    author='J Alan Brogan',
    author_email='github@al-got-rhythm.net',
    description=dotjab.__doc__,
    platforms='any',
    classifiers=[
        'Programming Language :: Python :: 2.7',
        'Development Status :: 1 - Planning',
        'Natural Language :: English',
        'Environment :: Console',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: MIT License',
        'Operating System :: Linux',
    ],
    install_requires=['dotsite'],
    test_suite='nose.collector',
    tests_require=['nose'],
    extras_require={
        'testing': ['nose'],
    }
)
