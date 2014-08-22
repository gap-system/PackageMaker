LoadPackage( "{{PackageName}}" );
dirs := DirectoriesPackageLibrary( "{{PackageName}}", "tst" );

Test( Filename( dirs, "TODO.tst" ) );

# TODO:
# - loop over all *.tst files

