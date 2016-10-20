# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
# coding: utf-8

from setuptools import setup, find_packages

NAME = "swaggerpetstore"
VERSION = "1.0.0"

# To install the library, run the following
#
# python setup.py install
#
# prerequisite: setuptools
# http://pypi.python.org/pypi/setuptools

REQUIRES = ["msrest>=0.2.0"]

setup(
    name=NAME,
    version=VERSION,
    description="SwaggerPetstore",
    author_email="",
    url="",
    keywords=["Swagger", "SwaggerPetstore"],
    install_requires=REQUIRES,
    packages=find_packages(),
    include_package_data=True,
    long_description="""\
    This is a sample server Petstore server.  You can find out more about Swagger at <a href="http://swagger.io">http://swagger.io</a> or on irc.freenode.net, #swagger.  For this sample, you can use the api key "special-key" to test the authorization filters
    """
)
