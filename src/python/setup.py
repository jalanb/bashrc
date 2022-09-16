"""Set up the jab/src/python project"""


from setuptools import setup


import jab as src_python


setup(
    name="jab",
    packages=["jab"],
    version='0.8.61',
    url='https://github.com/jalanb/jab/',
    license='MIT License',
    author='J Alan Brogan',
    author_email='github@al-got-rhythm.net',
    description="Just jabs' stuff"
    platforms='any',
    classifiers=[
        'Programming Language :: Python :: 3.7',
        'Development Status :: 1 - Planning',
        'Natural Language :: English',
        'Environment :: Console',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: MIT License',
        'Operating System :: Darwin',
    ],
    install_requires=['pysyte'],
    tests_require=['pytest'],
    extras_require={
        'testing': ['pytest'],
    }
)

