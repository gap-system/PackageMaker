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

## License

`PackageMaker` is free software you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation; either version 2 of the License, or (at your option) any
later version. For details, see the file `COPYING` distributed as part of
this package or see the FSF's own site.

As a special exception to the terms of the GNU General Public License, you
are granted permission to distribute a package you generated using
`PackageMaker` under any open source license recognized that is by the [Open
Source Initiative (OSI)](https://opensource.org).
