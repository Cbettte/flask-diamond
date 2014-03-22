# Ian Dennis Miller
# http://www.iandennismiller.com

SHELL=/bin/bash
PROJECT_NAME=Flask-Diamond
MOD_NAME=flask_diamond
WWWROOT=/var/www/$(PROJECT_NAME)
TEST_CMD=SETTINGS=$$PWD/etc/testing.conf nosetests -c tests/nose/test.cfg
TEST_SINGLE=SETTINGS=$$PWD/etc/testing.conf nosetests -c tests/nose/test-single.cfg

install:
	python setup.py install
	rsync -a $(MOD_NAME)/views/static $(WWWROOT)

clean:
	rm -rf build dist *.egg-info
	rm -rf docs/source/auto docs/build
	-rm `find . -name "*.pyc"`

server:
	SETTINGS=$$PWD/etc/dev.conf bin/manage.py runserver

shell:
	SETTINGS=$$PWD/etc/dev.conf bin/manage.py shell

watch:
	watchmedo shell-command -R -p "*.py" -c 'echo \\n\\n\\n\\nSTART; date; $(TEST_SINGLE); date' .

test:
	$(TEST_CMD)

single:
	$(TEST_SINGLE)

db:
	SETTINGS=$$PWD/etc/dev.conf bin/manage.py init_db
	SETTINGS=$$PWD/etc/dev.conf bin/manage.py populate_db

doc:
	rm -rf docs/source/auto
	mkdir -p docs/source/auto/$(MOD_NAME)
	sphinx-apidoc -o docs/source/auto/$(MOD_NAME) $(MOD_NAME)
	SETTINGS=$$PWD/etc/dev.conf sphinx-build -b html docs/source docs/build
	open docs/build/index.html

notebook:
	SETTINGS=$$PWD/etc/dev.conf cd var/ipython && ipython notebook

.PHONY: clean install test server watch notebook db dep single doc shell