#
# PackageMaker: A GAP package for creating new GAP packages
#
# This file is a script which compiles the package manual.
#
if fail = LoadPackage("AutoDoc", "2016.02.16") then
    Error("AutoDoc version 2016.02.16 or newer is required.");
fi;

AutoDoc( : scaffold := true, autodoc := true );

QUIT;
