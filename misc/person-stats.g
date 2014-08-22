#
# Compute some stats about package authors by looking at the
# Persons entries of all packages.
#
pers:=[];
for pkgname in RecNames(GAPInfo.PackagesInfo) do
    for pkg in GAPInfo.PackagesInfo.(pkgname) do
        Append(pers, pkg.Persons);
    od;
od;
SortBy(pers, x -> x.LastName);

Print("Found ", Length(pers), " person records\n");

# we may or may not want to honor how many packages
# actually contain a given name / address / etc.
#pers := Set(pers);

Print("Found ", Length(Set(pers)), " unique person records\n");

keys := [ "Email", "FirstNames", "Institution", "IsAuthor",
   "IsMaintainer", "LastName", "Place", "PostalAddress", "WWWHome"];

s := rec();
t := rec();
for k in keys do
    s.(k) := [];
    for p in pers do
        if IsBound(p.(k)) then
            Add(s.(k), p.(k));
        fi;
    od;
    t.(k) := Collected(s.(k));
    SortBy(t.(k), x -> -x[2]);
od;

# gap> Length(s.Email);
# 243
# gap> Length(Set(s.Email));
# 163
# gap> Length(s.FirstNames);
# 261
# gap> Length(Set(s.FirstNames));
# 134

# Assume that entries with identical Firstname + Lastname
# correspond to same person. Aggregate their person records
# accordingly.
u := rec();
for p in pers do
    k:=Concatenation(p.LastName, ", ", p.FirstNames);
    #k:=Concatenation(p.FirstNames, " --- ", p.LastName);
    p := ShallowCopy(p);
    Unbind(p.IsAuthor);
    Unbind(p.IsMaintainer);
    if not IsBound(u.(k)) then
        u.(k) := [p];
    else
        AddSet(u.(k), p);
    fi;
od;

for n in Set(RecNames(u)) do
    Print(n, ": ", Length(u.(n)), " person records\n");
od;
