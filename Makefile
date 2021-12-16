#!/usr/bin/make -f
SHELL = bash

public: submodules
	@hugo

submodules:
	@cd themes/dot-hugo/
	@git submodule init
	@git submodule update
	@cd -
