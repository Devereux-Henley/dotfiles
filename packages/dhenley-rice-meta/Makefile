SPEC := dhenley-rice-meta.spec
DIST := $(CURDIR)/dist
BUILD := $(CURDIR)/.rpmbuild
IMAGE := registry.fedoraproject.org/fedora:44

.PHONY: rpm clean

rpm:
	mkdir -p $(DIST)
	podman run --rm -v $(CURDIR):/work:Z -w /work $(IMAGE) sh -c '\
	  dnf install -q -y rpm-build >/dev/null && \
	  rpmbuild -bb --define "_topdir /work/.rpmbuild" $(SPEC) && \
	  cp /work/.rpmbuild/RPMS/noarch/*.rpm /work/dist/'
	@echo
	@ls -1 $(DIST)/*.rpm

clean:
	rm -rf $(DIST) $(BUILD)
