.PHONY: all clean build test

all: test

clean:
	rm -rf build/ *.so */*.c */*.pyc

build: clean
	python setup.py build_ext --inplace

test: build
	nosetests

itest:
	while true; do inotifywait -e modify --exclude '.*\.swp' src/ tests/; make test; done
