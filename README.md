# `PackageMaker`

`PackageMaker` is a [GAP](https://www.gap-system.org/) package that makes
it easy and convenient to create new GAP packages.

You can use it as follows:

1. Download `PackageMaker` and extract it into a GAP `pkg` directory.

2. Start GAP, load the `PackageMaker` package and run the package wizard:

    LoadPackage("PackageMaker");
    PackageWizard();

3. Answer the questions about your new package. Afterwards, `PackageMaker`
   creates a new directory for the new package and populates it with all the
   files needed for a basic package.

4. Move the newly created package directory to a suitable place.

Next, you may wish to learn more about the purpose of the various
generated files as well as the the meaning and correct usage of the
entries in the `PackageInfo.g` file.

To do that, please consult the manual of the "Example" package as well
as the comments in its PackageInfo.g file.

## Contact

Please submit bug reports, suggestions for improvements and patches via
the [issue tracker](https://github.com/gap-system/PackageMaker/issues).

You can also contact me directly via [email](max@quendi.de).
