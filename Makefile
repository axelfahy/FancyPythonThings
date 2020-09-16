# Makefile to simplify test and build.

.PHONY: all
all: test

.PHONY: build-python
build-python:
	python setup.py sdist bdist_wheel

.PHONY: build-notebook
build-notebook:
	# Convert .ipynb to rst file. Needs pandoc installed.
	jupyter nbconvert --to rst notebooks/notebook-bff-plot.ipynb

.PHONY: clean
clean:
	rm -rf coverage_html_report .coverage
	rm -rf bff.egg-info
	rm -rf venv-dev
	rm -rf dist/
	rm -rf notebooks/notebook-bff-plot_files/

.PHONY: clean-notebooks
clean-notebooks:
	# Corrections of path to images in notebook export.
	sed -i 's/\.\. image:: /\.\. image:: \.\.\/\.\.\/notebooks\//g' notebooks/notebook-bff-plot.rst

.PHONY: test
test: code lint style coverage

.PHONY: baseline-plot
baseline-plot:
	pytest --mpl-generate-path=tests/baseline tests/test_plot.py

.PHONY: code
code:
	pytest --mpl tests/test_plot.py
	python -m pytest --pycodestyle --pydocstyle

.PHONY: lint
lint:
	python -m pytest --pylint --pylint-rcfile=.pylintrc --pylint-error-types=CWEF
	bandit -r bff -ll

.PHONY: style
style:
	flake8
	mypy bff tests

.PHONY: coverage
coverage:
	rm -rf coverage_html_report .coverage
	python -m pytest --cov=bff tests --cov-report=html:coverage_html_report
