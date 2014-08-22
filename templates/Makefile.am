ACLOCAL_AMFLAGS = -I m4

BINARCHDIR = bin/$(GAPARCH)
GAPINSTALLLIB = $(abs_top_srcdir)/$(BINARCHDIR)/{{PackageName}}.so

lib_LTLIBRARIES = {{PackageName}}.la

{{PackageName}}_la_SOURCES = src/{{PackageName}}.c
{{PackageName}}_la_CPPFLAGS = $(GAP_CPPFLAGS) -DCONFIG_H
# Note that the latter is only for GAP 4.4.12
{{PackageName}}_la_LDFLAGS = -module -avoid-version
if SYS_IS_CYGWIN
{{PackageName}}_la_LDFLAGS += -no-undefined -version-info 0:0:0 -Wl,$(GAPROOT)/bin/$(GAPARCH)/gap.dll
endif

all-local: {{PackageName}}.la
	$(mkdir_p) $(top_srcdir)/$(BINARCHDIR)
if SYS_IS_CYGWIN
	cp .libs/{{PackageName}}.dll $(GAPINSTALLLIB)
else
	cp .libs/{{PackageName}}.so $(GAPINSTALLLIB)
endif
	@echo "SUCCESS!"

distclean-local:
	rm -rf bin/*
	(cd doc ; ./clean)

doc:	doc/manual.six

doc/manual.six: doc/*.xml PackageInfo.g
	($(GAPROOT)/bin/gap.sh -A makedoc.g)
