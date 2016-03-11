#
# {{PackageName}}: {{Subtitle}}
#
# This file is part of the build system of a GAP kernel extension.
# Requires automake.
#
ACLOCAL_AMFLAGS = -I cnf/m4

BINARCHDIR = bin/$(GAPARCH)
GAPINSTALLLIB = $(BINARCHDIR)/{{PackageName}}.so

lib_LTLIBRARIES = {{PackageName}}.la

{{PackageName}}_la_SOURCES = src/{{PackageName}}.{{KERNEL_EXT_LANG_EXT}}
{{PackageName}}_la_CPPFLAGS = $(GAP_CPPFLAGS) -DCONFIG_H
{{PackageName}}_la_LDFLAGS = -module -avoid-version
if SYS_IS_CYGWIN
{{PackageName}}_la_LDFLAGS += -no-undefined -version-info 0:0:0 
{{PackageName}}_la_LDFLAGS += -Wl,$(GAPROOT)/bin/$(GAPARCH)/gap.dll
endif

all-local: $(GAPINSTALLLIB)

$(GAPINSTALLLIB): {{PackageName}}.la
	$(mkdir_p) $(BINARCHDIR)
if SYS_IS_CYGWIN
	cp .libs/{{PackageName}}.dll $(GAPINSTALLLIB)
else
	cp .libs/{{PackageName}}.so $(GAPINSTALLLIB)
endif

clean-local:
	rm -f $(GAPINSTALLLIB)

distclean-local:
	rm -rf bin/*

doc:
	($(GAPROOT)/bin/gap.sh -A makedoc.g)
