#!/bin/bash

pushd msrest
rm -rf dist
python3 ./setup.py sdist --formats=zip
python3 ./setup.py bdist_wheel
python2 ./setup.py bdist_wheel
popd

pushd msrestazure
rm -rf dist
python3 ./setup.py sdist --formats=zip
python3 ./setup.py bdist_wheel
python2 ./setup.py bdist_wheel
popd
