NAME = plugin.video.quasar
GIT = git
GIT_VERSION = $(shell $(GIT) describe --always)
VERSION = $(shell sed -ne "s/.*version=\"\([0-9a-z\.\-]*\)\"\sprovider.*/\1/p" addon.xml)
ARCHS = \
	android_arm \
	android_x64 \
	linux_x86 \
	linux_x64 \
	linux_arm \
	darwin_x64 \
	windows_x86 \
	windows_x64
ZIP_SUFFIX = zip
ZIP_FILE = $(NAME)-$(VERSION).$(ZIP_SUFFIX)

all: clean zip

$(ZIP_FILE):
	git archive --format zip --prefix $(NAME)/ --output $(ZIP_FILE) HEAD
	mkdir -p $(NAME)/resources/bin
	for arch in $(ARCHS); do \
		ln -s `pwd`/resources/bin/$$arch $(NAME)/resources/bin/$$arch; \
		zip -9 -r -g $(ZIP_FILE) $(NAME)/resources/bin/$$arch; \
	done
	rm -rf $(NAME)

zipfiles: addon.xml
	for arch in $(ARCHS); do \
		$(MAKE) zip ARCHS=$$arch ZIP_SUFFIX=$$arch.zip; \
	done

zip: $(ZIP_FILE)

clean:
	rm -f $(ZIP_FILE)
	rm -rf $(NAME)
