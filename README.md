PackageMaker
============

PackageMaker is a [GAP](http://www.gap-system.org/) script that makes
it super easy and convenient to create a new GAP package.

1. Download PackageMaker and extract it.

2. Open a terminal in the PackageMaker directory.

3. Start GAP, load the PackageMaker script and run the package wizeard.
```
  Read("PackageMaker.g");
  PackageWizard();
```
This will ask you a couple questions about your new package, then
creates a new directory for it and populates it with all the files
needed for a basic package.

4. Move the newly created package directory to a suitable place.

# Contact

Please submit bug reports, suggestions for improvements and patches via
the [issue tracker](https://github.com/fingolfin/PackageMaker/issues).

You can also contact me directly via [email](max@quendi.de).
