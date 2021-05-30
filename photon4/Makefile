# vim:ft=make:

# Defaults
MAKEFILE             := $(lastword $(MAKEFILE_LIST))
PHOTON_INSTALLATIONS := developer minimal ostree rt

# Help
.PHONY: help

help:
		@echo "Targets:"
		@echo "  validate\n"
		@echo "  build"
		@echo "    $(addsuffix \n   , $(addprefix build-, $(PHOTON_INSTALLATIONS)))"
		@echo "  publish"
		@echo "    $(addsuffix \n   , $(addprefix publish-, $(PHOTON_INSTALLATIONS)))"
		@echo "  clean"
		@echo ""

# Packer targets
.PHONY: validate* build* publish*

validate:
	@echo "=> Validating"
	packer validate .

build: validate
	@echo "=> Building: all versions"
	@for version in $(PHOTON_INSTALLATIONS) ; do \
		$(MAKE) -f $(MAKEFILE) build-$$version ;   \
	done

build-%: 
	@echo "=> Building: $(patsubst build-%,%, $@)"
	packer build -var-file=override.pkrvars.hcl -var installation=$(patsubst build-%,%, $@) -except=vagrant-cloud . 

publish: validate
	@echo "=> Publishing: all versions"
	@for version in $(PHOTON_INSTALLATIONS) ; do \
		$(MAKE) -f $(MAKEFILE) publish-$$version ; \
	done

publish-%: 
	@echo "=> Publishing: $(patsubst publish-%,%, $@)"
	packer build -var-file=override.pkrvars.hcl -var installation=$(patsubst publish-%,%, $@) . 

.PHONY: clean
clean:
	/bin/rm -rf output/*

