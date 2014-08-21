LoadPackage( "{{PACKAGENAME}}" );
dirs := DirectoriesPackageLibrary( "{{PACKAGENAME}}", "tst" );

Test( Filename( dirs, "TODO.tst" ) );

# TODO:
# - loop over all *.tst files

