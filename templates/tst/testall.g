#
# {{PackageName}}: {{Subtitle}}
#
# This file runs package tests. It is also referenced in the package
# metadata in PackageInfo.g.
#
LoadPackage( "{{PackageName}}" );
dirs := DirectoriesPackageLibrary( "{{PackageName}}", "tst" );

Test( Filename( dirs, "TODO.tst" ) );

# TODO:
# - loop over all *.tst files

