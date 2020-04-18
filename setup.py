from setuptools import setup, find_namespace_packages
import os

from dunamai import Version

REQUIRED = ["protobuf>=3.11.3", "grpclib>=0.3.1"]
EXTRAS = {}
# This is pretty hacky but dunamai expects things that don't
# apply to our versioning scheme.
VERSION_PATTERN = r"^(?P<base>\d+\.\d+\.\d+)((?P<stage>\.?)(?P<revision>\d+))?$"

version = Version.from_git(pattern=VERSION_PATTERN, latest_tag=True)
setup(
    name="zetasql",
    version=version.serialize(),
    description="gRPC client library for ZetaSQL",
    url="http://github.com/VideoAmp/zetasql",
    author="Gregory Bean",
    author_email="gbean@videoamp.com",
    packages=find_namespace_packages("python"),
    package_dir={"": "python"},
    package_data={"zetasql": ["py.typed", "**/*.pyi"]},
    zip_safe=False,
    python_requires=">=3.7",
    install_requires=REQUIRED,
    extras_require=EXTRAS,
    include_package_data=True,
    setup_requires=["dunamai>=1.1.0"],
)
