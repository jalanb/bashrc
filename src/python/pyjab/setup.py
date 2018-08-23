"""Set up the jab project"""


from setuptools import setup


import jab


setup(
    name=jab.name,
    packages=[jab.name],
    version=jab.__version__,
    url='https://github.com/jalanb/jab/tree/master/src/python/jab',
    license='MIT License',
    author='J Alan Brogan',
    author_email='github@al-got-rhythm.net',
    description=jab.__doc__,
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
