#
# PackageMaker: A GAP package for creating new GAP packages
#
# This file contains package meta data. For additional information on
# the meaning and correct usage of these fields, please consult the
# manual of the "Example" package as well as the comments in its
# PackageInfo.g file.
#
SetPackageInfo( rec(

PackageName := "PackageMaker",
Subtitle := "A GAP package for creating new GAP packages",
Version := "0.7",
Date := "28/08/2014", # dd/mm/yyyy format

Persons := [
  rec(
    IsAuthor := true,
    IsMaintainer := true,
    FirstNames := "Max",
    LastName := "Horn",
    WWWHome := "http://www.quendi.de/math",
    Email := "max.horn@math.uni-giessen.de",
    PostalAddress := Concatenation(
               "AG Algebra\n",
               "Mathematisches Institut\n",
               "Justus-Liebig-Universität Gießen\n",
               "Arndtstraße 2\n",
               "35392 Gießen\n",
               "Germany" ),
    Place := "Gießen",
    Institution := "Justus-Liebig-Universität Gießen",
  ),
],

SourceRepository := rec(
    Type := "git",
    URL := Concatenation( "https://github.com/fingolfin/", ~.PackageName ),
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
PackageWWWHome  := Concatenation( "https://fingolfin.github.io/", ~.PackageName ),
README_URL      := Concatenation( ~.PackageWWWHome, "/README" ),
PackageInfoURL  := Concatenation( ~.PackageWWWHome, "/PackageInfo.g" ),
ArchiveURL      := Concatenation( ~.SourceRepository.URL,
                                 "/releases/download/v", ~.Version,
                                 "/", ~.PackageName ,"-", ~.Version ),
ArchiveFormats := ".tar.gz .tar.bz2",

##  Status information. Currently the following cases are recognized:
##    "accepted"      for successfully refereed packages
##    "submitted"     for packages submitted for the refereeing
##    "deposited"     for packages for which the GAP developers agreed
##                    to distribute them with the core GAP system
##    "dev"           for development versions of packages
##    "other"         for all other packages
##
Status := "dev",

AbstractHTML   :=  "",

PackageDoc := rec(
  BookName  := "PackageMaker",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "A GAP package for creating new GAP packages",
),

Dependencies := rec(
  GAP := ">= 4.8",
  NeededOtherPackages := [
      [ "GAPDoc", ">= 1.5" ],
      [ "AutoDoc", ">= 2016.02.16" ],
    ],
  SuggestedOtherPackages := [
      [ "AtlasRep", ">= 1.5" ], # for CurrentDateTimeString
      [ "io", ">= 3.0" ],       # for IO_gettimeofday
    ],
  ExternalConditions := [ ],
),

AvailabilityTest := function()
        return true;
    end,

TestFile := "tst/testall.g",

#Keywords := [ "TODO" ],

));


