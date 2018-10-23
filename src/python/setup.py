"""Set up the jab/src/python project"""


from setuptools import setup


import jab as src_python


setup(
    name=src_python.name,
    packages=[src_python.name],
    version=src_python.__version__,
    url='https://github.com/jalanb/jab/tree/master/src/python/',
    license='MIT License',
    author='J Alan Brogan',
    author_email='github@al-got-rhythm.net',
    description=src_python.__doc__,
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
    install_requires=['pysyte'],
    test_suite='nose.collector',
    tests_require=['nose'],
    extras_require={
        'testing': ['nose'],
    }
)

