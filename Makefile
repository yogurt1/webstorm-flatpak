#APP = $(foreach file, $(wildcard *.json), $(subst .json,.app,$(file)))
REPO = repo
APP = $(patsubst %.json,%,$(wildcard *.json))
VER = master

all: app
build: app
app: $(APP)

test:
	@echo $(APP:%=%.bundle)

uninstall:
	@flatpak --user uninstall $(APP)

install:
	@flatpak --user install --bundle $(APP:%=%.flatpak)

reinstall: uninstall install

clean:
	@rm -rf app repo .flatpak-builder $(APP:%=%.bundle)


%: %.json
	@rm -rf app
	@echo $@
	@flatpak-builder --require-changes --repo=$(REPO) --subject="Build of $@ `date`" ${EXPORT_ARGS} app $<
	@flatpak build-bundle repo $(patsubst %.json,%.flatpak,$<) $@ $(VER)

.PHONY: all clean test uninstall install build
