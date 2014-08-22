PackageMaker
============

Create a GAP package skeleton in a few seconds:
```
  Read("PackageMaker.g");
  CreatePackage("MyPackage");
```
This creates a new directory named MyPackage and populates it with
all the files needed for a basic package.

You can customize it via optional arguments:

  CreatePackage("MyPackage" : version := "1.1", date := "25/04/2013");

You can also provide a list of author records, but since this tends to
be long, you will probably want to instead set a default author
record in your gaprc file. E.g. I use this:

```
DefaultAuthor :=
  rec( LastName := "Horn",
       FirstNames := "Max",
       IsAuthor := true,
       IsMaintainer := true,
       Email := "max.horn@math.uni-giessen.de",
       WWWHome := "http://www.quendi.de/math",
       PostalAddress := Concatenation(
               "AG Algebra\n",
               "Mathematisches Institut\n",
               "JLU Gießen\n",
               "Arndtstraße 2\n",
               "D-35392 Gießen\n",
               "Germany" ),
       Place := "Gießen",
       Institution := "Justus-Liebig-Universität Gießen"
     );
```

This code is released under the GPL 2.
