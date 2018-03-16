# This is just for convenience.

.PHONY : all wheel venv clean rebuild reinstall

pyfiles = $(shell find src -type f -name '*.py')
# Probably breaks if the version is an alpha/beta or something.
version = $(shell grep ^version setup.py | grep -oh '[0-9].*\.[0-9].*\.[0-9]')
wheel = rse-$(version)-py2-none-any.whl

all : wheel
wheel : dist/$(wheel)
reinstall : uninstall install

dist/$(wheel) : $(pyfiles)
	python setup.py bdist_wheel

venv : wheel
	virtualenv venv; . venv/bin/activate; pip install dist/$(wheel); deactivate

install : wheel
	# Note: Installs to current venv, if any
	pip install dist/$(wheel)

uninstall :
	# Note: Won't uninstall dependencies
	pip uninstall -y rse

clean :
	-rm -rf build dist venv *.egg-info src/*.egg-info *.pyc .tox .pytest_cache

rebuild : clean all
