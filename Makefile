all: bin/django var/db.sqlite3

bin/django: var/assets/jquery/bower.json bin/buildout buildout.cfg versions.cfg setup.py
	find src -type f -iname '*.py[co]' -delete
	bin/buildout
	touch -c $@

var/db.sqlite3:
	bin/django migrate

bin/flake8: bin/buildout

bin/buildout: bin/python
	bin/python bootstrap.py --version=2.2.1

bin/python: parts/virtualenv-1.11.6
	parts/virtualenv-1.11.6/virtualenv.py --python=python2.7 --setuptools --no-site-packages .

var/assets/jquery/bower.json: bin/node bower.json
	if [ -n "$$NODE_VIRTUAL_ENV" -a "$$NODE_VIRTUAL_ENV" = "$$PWD" ] ; then \
	    bower install ; \
	else \
	    . bin/activate && bower install ; \
	fi
	touch -c $@

bin/node: bin/nodeenv
	bin/nodeenv --node=0.11.13 --prebuilt -p --requirements=node-requirements.txt
	touch -c $@

bin/nodeenv: bin/python requirements.txt
	bin/pip install -r requirements.txt

parts/virtualenv-1.11.6:
	mkdir -p parts
	wget https://pypi.python.org/packages/source/v/virtualenv/virtualenv-1.11.6.tar.gz -O- | tar -xzf- -C parts

clean:
	rm -rf akl.lt.egg-info bin develop-eggs include .installed.cfg lib \
		   local parts share $(wildcard src/node-v0.*.*-*-*/) \
		   var eggs
	find src -type f -iname '*.egg-info' -delete
	find src -type f -iname '*.py[co]' -delete

run: bin/django
	bin/django runserver

test: bin/django flake8
	bin/django test akllt

flake8: bin/flake8
	bin/flake8 --exclude=migrations src/akllt

tags: bin/django
	bin/ctags -v

.PHONY: all clean run tags
