from setuptools import setup, find_namespace_packages
import os

REQUIRED = [
    "protobuf>=3.11.3",
    "grpclib>=0.3.1"
]
EXTRAS = {}

print(find_namespace_packages(exclude=["tests", "*.tests", "*.tests.*", "tests.*"]))

setup(name='zetasql',
    version='2020.03.99',
    description='gRPC Client library for ZetaSQL',
    url='http://github.com/VideoAmp/zetasql',
    author='Gregory Bean',
    author_email='gbean@videoamp.com',
    packages=find_namespace_packages(exclude=["tests", "*.tests", "*.tests.*", "tests.*"]),
    package_data = {
        'zetasql': ['py.typed', "**/*.pyi"],
    },
    zip_safe=False,
    install_requires=REQUIRED,
    extras_require=EXTRAS,
    include_package_data=True,
)
