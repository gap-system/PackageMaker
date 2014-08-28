PackageMaker
============

PackageMaker is a [GAP](http://www.gap-system.org/) package that makes
it easy and convenient to create new GAP packages.

TODO: adjust the instructions below to the fact that PackageMaker now is
a package itself.

1. Download PackageMaker and extract it.

2. Open a terminal in the PackageMaker directory.

3. Start GAP, load the PackageMaker package and run the package wizeard.
  ```
  LoadPackage("PackageMaker");
  PackageWizard();
  ```
  This will ask you a couple questions about your new package, then
  creates a new directory for it and populates it with all the files
  needed for a basic package.

4. Move the newly created package directory to a suitable place.

Next, you may wish to learn more about the purpose of the various
generated files as well as the the meaning and correct usage of the
entries in the PackageInfo.g file.

Tp do that, please consult the manual of the "Example" package as well
as the comments in its PackageInfo.g file.

# Contact

Please submit bug reports, suggestions for improvements and patches via
the [issue tracker](https://github.com/fingolfin/PackageMaker/issues).

You can also contact me directly via [email](max@quendi.de).
