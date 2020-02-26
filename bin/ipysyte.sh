#! /usr/bin/env bash

# pysyte () {
#     python -c " \
#         import pysyte; \
#         from pysyte.types import paths; \
#         print(paths.path(pysyte); \
#         "
# }
# 

pysyte=~/hub/pysyte
cd $pysyte/.venv/bin/
source ./activate
PYTHONPATH=$pysyte ./ipython3 --no-confirm-exit 
