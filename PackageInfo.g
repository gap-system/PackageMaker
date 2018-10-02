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
Version := "0.8",
Date := "01/03/2016", # dd/mm/yyyy format

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
    URL := Concatenation( "https://github.com/gap-system/", ~.PackageName ),
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
PackageWWWHome  := Concatenation( "https://gap-system.github.io/", ~.PackageName ),
README_URL      := Concatenation( ~.PackageWWWHome, "/README.md" ),
PackageInfoURL  := Concatenation( ~.PackageWWWHome, "/PackageInfo.g" ),
ArchiveURL      := Concatenation( ~.SourceRepository.URL,
                                 "/releases/download/v", ~.Version,
                                 "/", ~.PackageName, "-", ~.Version ),
ArchiveFormats := ".tar.gz",

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
  GAP := ">= 4.9",
  NeededOtherPackages := [
      [ "AutoDoc", ">= 2018.02.14" ],
      [ "io", ">= 3.0" ],       # for IO_gettimeofday
    ],
  SuggestedOtherPackages := [ ],
  ExternalConditions := [ ],
),

AvailabilityTest := function()
        return true;
    end,

TestFile := "tst/testall.g",

#Keywords := [ "TODO" ],

));


