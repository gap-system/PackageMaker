#
# PackageMaker - a GAP script for creating GAP packages
#
# Copyright (c) 2013-2014 Max Horn
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
#

if fail = LoadPackage("AutoDoc", ">= 2014.03.27") then
    Error("AutoDoc version 2014.03.27 is required.");
fi;

LoadPackage("io"); # try to load io (it is optional)

PACKAGE_MAKER_VERSION := "0.6";

TranslateTemplate := function (template, outfile, subst)
    local out_stream, in_stream, line, pos, end_pos, key, val, i, tmp, c;

    if template = fail then
        template := Concatenation( "templates/", outfile );
    fi;
    outfile := Concatenation( subst.PackageName, "/", outfile );

    in_stream := InputTextFile( template );
    out_stream := OutputTextFile( outfile, false );
    SetPrintFormattingStatus( out_stream, false );

    while not IsEndOfStream( in_stream ) do
        line := ReadLine( in_stream );
        if line = fail then
            break;
        fi;

        # Substitute {{ }} blocks
        pos := -1;
        while true do
            pos := PositionSublist( line, "{{", pos + 1 );
            if pos = fail then
                break;
            fi;

            end_pos := PositionSublist( line, "}}", pos + 1 );
            if end_pos = fail then
                continue;
            fi;

            key := line{[pos+2..end_pos-1]};
            if not IsBound(subst.(key)) then
                Error("Unknown substitution key '",key,"'\n");
            else
                val := subst.(key);
                if not IsString(val) and IsList(val) and IsRecord(val[1]) then
                    WriteAll( out_stream, line{[1..pos-1]} );
                    PrintTo( out_stream, "[\n" );
                    for i in [1..Length(val)] do
                        PrintTo( out_stream, "  rec(\n" );
                        for key in RecNames(val[i]) do
                            PrintTo( out_stream, "    ", key, " := ");
                            tmp := val[i].(key);
                            if IsString(tmp) then
                                if '\n' in tmp then
                                    PrintTo( out_stream, "Concatenation(\n" );
                                    tmp := SplitString(tmp,"\n");
                                    for c in [1..Length(tmp)-1] do
                                        PrintTo( out_stream, "               \"",tmp[c],"\\n\",\n");
                                    od;
                                    PrintTo( out_stream, "               \"",tmp[Length(tmp)],"\" )");
                                else
                                    PrintTo( out_stream, "\"" );
                                    for c in tmp do
                                        if c = '\n' then
                                            WriteByte( out_stream, IntChar('\\') );
                                            WriteByte( out_stream, IntChar('n') );
                                        else
                                            WriteByte( out_stream, IntChar(c) );
                                        fi;
                                    od;
                                    PrintTo( out_stream, "\"");
                                fi;
                            else
                                PrintTo( out_stream, tmp );
                            fi;
                            PrintTo( out_stream, ",\n" );
                        od;
                        PrintTo( out_stream, "  ),\n" );
                    od;
                    PrintTo( out_stream, "]" );
                    WriteAll( out_stream, line{[end_pos+2..Length(line)]} );
                    line := "";
                else
                    line := Concatenation( line{[1..pos-1]}, val, line{[end_pos+2..Length(line)]} );
                fi;
            fi;

#            Print("Found at pos ", [pos,from], " string '", line{[pos..end_pos+1]}, "'\n");
#            Print("Found at pos ", [pos,from], " string '", line{[pos+2..end_pos-1]}, "'\n");

        od;

        WriteAll( out_stream, line );

    od;

    CloseStream(out_stream);
    CloseStream(in_stream);
end;

FlushOutput := function()
    # FIXME: Is there a better alternative to this?
    Print("\c");
end;

AskYesNoQuestion := function( question )
    local stream, default, ans;

    stream := InputTextUser();

    Print(question);
    default := ValueOption( "default" );
    if default = true then
        Print(" [Y/n] "); FlushOutput();
    elif default = false then
        Print(" [y/N] "); FlushOutput();
    else
        default := fail;
        Print(" [y/n] "); FlushOutput();
    fi;

    while true do
        ans := CharInt(ReadByte(stream));
        if ans in "yYnN" then
            Print([ans,'\n']);
            ans := ans in "yY";
            break;
        elif ans in "\n\r" and default <> fail then
            Print("\n");
            ans := default;
            break;
        elif ans = '\c' then
            Print("\nUser aborted\n"); # HACK since Ctrl-C does not work
            JUMP_TO_CATCH("abort"); # HACK, undocumented command
        fi;
    od;

    CloseStream(stream);
    return ans;
end;

AskQuestion := function( question )
    local stream, default, ans;

    default := ValueOption( "default" );

    # Print the question prompt
    Print(question, " ");
    if default <> fail then
        Print("[", default, "] ");
    fi;
    FlushOutput();

    # Read user input
    stream := InputTextUser();
    ans := ReadLine(stream);    # FIXME: this disables Ctrl-C !!!!
    CloseStream(stream);

    # Clean it up
    if ans = "\n" and default <> fail then
        ans := default;
    else
        ans := Chomp(ans);
    fi;
    NormalizeWhitespace("ans");

    if ans = "quit" then Error("User aborted"); fi; # HACK since Ctrl-C does not work

    return ans;
end;

AskAlternativesQuestion := function( question, answers )
    local stream, default, i, ans;

    Assert(0, IsList(answers) and Length(answers) >= 2);

    default := ValueOption( "default" );
    if default = fail then
        default := 1;
    else
        Assert(0, default in [1..Length(answers)]);
    fi;

    for i in [1..Length(answers)] do
        Print(" (",i,")   ", answers[i][1], "\n");
    od;

    while true do
        ans := AskQuestion(question : default := default);

        if Int(ans) in [1..Length(answers)] then
            ans := answers[Int(ans)][2];
            break;
        fi;

        question := "Invalid choice. Please try again";
    od;

    return ans;
end;

EXTRA_PERSON_KEYS := [ "Email", "WWWHome", "Institution", "Place", "PostalAddress"];

PkgAuthorRecs := function()
    local pers, pkgname, pkg, u, p, k, name;
    pers:=[];
    for pkgname in RecNames(GAPInfo.PackagesInfo) do
        for pkg in GAPInfo.PackagesInfo.(pkgname) do
            Append(pers, pkg.Persons);
        od;
    od;

    # Assume that entries with identical Firstname + Lastname
    # correspond to same person. Aggregate their person records
    # accordingly.
    u := rec();
    for p in pers do
        name := Concatenation(p.LastName, ", ", p.FirstNames);

        if not IsBound(u.(name)) then
            u.(name) := rec();
            for k in EXTRA_PERSON_KEYS do
                u.(name).(k) := [];
            od;
        fi;

        for k in EXTRA_PERSON_KEYS do
            if IsBound(p.(k)) then
                Add(u.(name).(k), p.(k));
            fi;
        od;
    od;

    # We now may have many duplicate entries for e.g. emails.
    # Remove the duplicates and sort the remaining unique
    # keys by how often they occurred before.
    for name in RecNames(u) do
        p := u.(name);
        for k in EXTRA_PERSON_KEYS do
            p.(k) := Collected(p.(k));
            SortBy(p.(k), x -> -x[2]);
            p.(k) := List(p.(k), x -> x[1]);
        od;
    od;

    return u;
end;

Command := function(cmd, args)
    local out, outstream, instream, path, cmd_full, res;

    out := "";
    outstream := OutputTextString(out, false);
    instream := InputTextString("");

    path := DirectoriesSystemPrograms();
    cmd_full := Filename( path, cmd );
    if cmd_full = fail then
        CloseStream(instream);
        CloseStream(outstream);
        #Error("Could not locate command '", cmd, "' in your PATH");
        return fail;
    fi;

    res := Process(DirectoryCurrent(), cmd_full, instream, outstream, args);

    CloseStream(instream);
    CloseStream(outstream);

    if res = 0 then
        return out;
    fi;
    return fail;
end;

# Return current date as a string with format DD/MM/YYYY.
Today := function()
    local secs, tmp, date;
    if IsBound(IO_gettimeofday) then
        secs := IO_gettimeofday().tv_sec;
    elif IsBound(CurrentDateTimeString) then
        tmp := CurrentDateTimeString(["-u", "+%s"]);
    else
        tmp := Chomp(Command("date", [ "-u", "+%s" ]));
    fi;

    if IsBound(tmp) and IsString(tmp) and tmp <> "unknown" then
        secs := Int(tmp);
    fi;

    if not IsBound(secs) then
        # We failed to determine the current date
        return "TODO";
    fi;

    date := DMYDay(Int(secs / 86400));
    date := date + [100, 100, 0];
    date := List( date, String );
    date := Concatenation( date[1]{[2,3]}, "/", date[2]{[2,3]}, "/", date[3] );

    return date;
end;

PackageWizard := function()
    local pkginfo, repotype, date, p, github, alphanum, kernel,
        pers, name, key, q, tmp;

    Print("Welcome to the GAP PackageMaker Wizard (version ",PACKAGE_MAKER_VERSION,").\n",
          "I will now guide you step-by-step through the package\n",
          "creation process by asking you some questions.\n\n");

    #
    # Phase 1: Ask lots of questions.
    #

    pkginfo := rec();

    while true do
        pkginfo.PackageName := AskQuestion("What is the name of the package?" : isValid := IsValidIdentifier);
        if IsValidIdentifier(pkginfo.PackageName) then
            break;
        fi;
        Print("Sorry, the package name must be a valid identifier (non-empty, only letters and digits, not a number, not a keyword)\n");
    od;
    if IsExistingFile(pkginfo.PackageName) then
        Print("ERROR: A file or directory with this name already exists.\n");
        Print("Please move it away or choose another package name.");
        return;
    fi;

    pkginfo.Subtitle := AskQuestion("Enter a short (one sentence) description of your package:"
                : isValid := g -> Length(g) < 80);

    #
    # Package version: Just default to some value. We could ask the user
    # for a version, but they only need to change one spot for it, and
    # when creating a new package, this is not so important.
    #
    pkginfo.Version := "0.1";
    #pkginfo.Version := AskQuestion("What is the version of your package?" : default := "0.1" );

    #
    # Package release date: just pick the current date. Similarly to the
    # package version, we don't allow customizing this in the wizard.
    #
    pkginfo.Date := Today();
    #pkginfo.Date := AskQuestion("What is the release date of your package?" : default := Today() );

#     repotype := AskAlternativesQuestion("Shall I create a Git or Mercurial repository for your new package?",
#                     [
#                       [ "Yes, Git", "git" ],
#                       [ "Yes, Mercurial", "hg" ],
#                       [ "No", fail ]
#                     ] );
    repotype := false;  # TODO: implement this

    if repotype = "git" and true = AskYesNoQuestion("Setup for use with GitHub?" : default := true) then
        alphanum := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

        # Try to get github username from git config
        tmp := Command("git", ["config", "github.user"]);
        if tmp <> fail then
            tmp := Chomp(tmp);
        fi;

        github := rec();
        github.username := AskQuestion("What is your GitHub username?"
                            : isValid := n -> Length(n) > 0 and n[1] <> '-' and
                                    ForAll(n, c -> c = '-' or c in alphanum),
                              default := tmp);
        github.reponame := AskQuestion("What is the repository name?"
                            : default := pkginfo.PackageName,
                              isValid := n -> Length(n) > 0 and
                                    ForAll(n, c -> c in "-._" or c in alphanum));
        github.gh_pages := true;
        #github.gh_pages := AskYesNoQuestion("Do you want to use GitHubPagesForGAP?" : default := true)
    fi;

    if IsBound(github) and github.gh_pages then
        pkginfo.PackageWWWHome := Concatenation("http://",github.username,".github.io/",github.reponame);
        pkginfo.ArchiveURL     := Concatenation("Concatenation(\"https://github.com/",github.username,"/",github.reponame,"/\",\n",
                                  "                                \"releases/download/v\", ~.Version,\n",
                                  "                                \"/",pkginfo.PackageName,"-\", ~.Version)");
    else
        pkginfo.PackageWWWHome := AskQuestion("URL of package homepage?");
        if pkginfo.PackageWWWHome = "" then
            pkginfo.PackageWWWHome := "http://TODO";
        fi;
        pkginfo.ArchiveURL     := Concatenation( "Concatenation( ~.PackageWWWHome, \"",
                                    pkginfo.PackageName, "-\", ~.Version )" );

    fi;
    
    # Ensure the URL ends with a trailing slash.
    if Length(pkginfo.PackageWWWHome) > 0 and pkginfo.PackageWWWHome[Length(pkginfo.PackageWWWHome)] <> '/' then
        Add(pkginfo.PackageWWWHome, '/');
    fi;

    pkginfo.README_URL     := "Concatenation( ~.PackageWWWHome, \"README\" )";
    pkginfo.PackageInfoURL := "Concatenation( ~.PackageWWWHome, \"PackageInfo.g\" )";

    kernel := AskAlternativesQuestion("Shall your package provide a GAP kernel extension?",
                    [
                      [ "No", fail ],
                      [ "Yes, written in C", "C" ],
                      [ "Yes, written in C++", "C++" ],
                    ] );

    if kernel <> fail then

        pkginfo.KERNEL_EXT_INIT_G := Concatenation(
            "_PATH_SO:=Filename(DirectoriesPackagePrograms(\"",pkginfo.PackageName,"\"), \"",pkginfo.PackageName,".so\");\n",
            "if _PATH_SO <> fail then\n",
            "    LoadDynamicModule(_PATH_SO);\n",
            "fi;\n",
            "Unbind(_PATH_SO);\n");
        pkginfo.KERNEL_EXT_MAKEDOC_G := Concatenation("\nPrintTo(\"VERSION\", PackageInfo(\"",pkginfo.PackageName,"\")[1].Version);\n");
        if kernel = "C++" then
            pkginfo.KERNEL_EXT_LANG_CONFIGURE_AC := "AC_PROG_CXX\nAC_LANG([C++])";
            pkginfo.KERNEL_EXT_LANG_EXT := "cc";
        else
            pkginfo.KERNEL_EXT_LANG_CONFIGURE_AC := "AC_PROG_CC\nAC_LANG([C])";
            pkginfo.KERNEL_EXT_LANG_EXT := "c";
        fi;

    else
        pkginfo.KERNEL_EXT_INIT_G := "";
        pkginfo.KERNEL_EXT_MAKEDOC_G := "";
        pkginfo.KERNEL_EXT_LANG_CONFIGURE_AC := "";
        pkginfo.KERNEL_EXT_LANG_EXT := "";
    fi;

    #
    # Package authors and maintainers
    #
    pers := PkgAuthorRecs();
    pkginfo.Persons := [];
    Print("\n");
    Print("Next I will ask you about the package authors and maintainers.\n\n");
    repeat
        p := rec();
        p.LastName := AskQuestion("Last name?");
        p.FirstNames := AskQuestion("First name(s)?");

        p.IsAuthor := AskYesNoQuestion("Is this one of the package authors?" : default := true);
        p.IsMaintainer := AskYesNoQuestion("Is this a package maintainer?" : default := true);

        name := Concatenation(p.LastName, ", ", p.FirstNames);
        for key in EXTRA_PERSON_KEYS do
            q := Concatenation(key, "?");
            if IsBound(pers.(name)) then
                tmp := pers.(name).(key);
            else
                tmp := [];
            fi;
            if Length(tmp) = 0 then
                p.(key) := AskQuestion(q);
            elif Length(tmp) = 1 then
                p.(key) := AskQuestion(q : default := tmp[1]);
            else
                tmp := List(tmp, x -> [x,x]);
                Add(tmp, ["other", fail]);
                p.(key) := AskAlternativesQuestion(q, tmp);
                if p.(key) = fail then
                    p.(key) := AskQuestion(q);
                fi;
            fi;
            #if p.(key) = "" then
            #    Unbind(p.(key));
            #fi;
        od;

        Add(pkginfo.Persons, p);
    until false = AskYesNoQuestion("Add another person?" : default := false);

    #
    # Phase 2: Create the package directory structure
    #

    if not AUTODOC_CreateDirIfMissing( pkginfo.PackageName ) then
        Error("Failed to create package directory");
    fi;

    TranslateTemplate(fail, "README", pkginfo );
    TranslateTemplate("templates/PackageInfo.g.in", "PackageInfo.g", pkginfo );
    TranslateTemplate(fail, "init.g", pkginfo );
    TranslateTemplate(fail, "read.g", pkginfo );
    TranslateTemplate(fail, "makedoc.g", pkginfo );

    if not AUTODOC_CreateDirIfMissing( Concatenation( pkginfo.PackageName, "/gap" ) ) then
        Error("Failed to create `gap' directory in package directory");
    fi;
    TranslateTemplate("templates/gap/PKG.gi", Concatenation("gap/", pkginfo.PackageName, ".gi"), pkginfo );
    TranslateTemplate("templates/gap/PKG.gd", Concatenation("gap/", pkginfo.PackageName, ".gd"), pkginfo );

    if not AUTODOC_CreateDirIfMissing( Concatenation( pkginfo.PackageName, "/tst" ) ) then
        Error("Failed to create `tst' directory in package directory");
    fi;
    TranslateTemplate(fail, "tst/testall.g", pkginfo );

    if kernel <> fail then
        # create a simple kernel extension with a build system

        TranslateTemplate(fail, "Makefile.am", pkginfo );
        TranslateTemplate(fail, "configure.ac", pkginfo );

        if not AUTODOC_CreateDirIfMissing( Concatenation( pkginfo.PackageName, "/src" ) ) then
            Error("Failed to create `src' directory in package directory");
        fi;
        if kernel = "C++" then
            TranslateTemplate("templates/src/PKG.cc", Concatenation("src/", pkginfo.PackageName, ".cc"), pkginfo );
        else
            TranslateTemplate("templates/src/PKG.c", Concatenation("src/", pkginfo.PackageName, ".c"), pkginfo );
        fi;

        if not AUTODOC_CreateDirIfMissing( Concatenation( pkginfo.PackageName, "/m4" ) ) then
            Error("Failed to create `m4' directory in package directory");
        fi;
        TranslateTemplate(fail, "m4/ac_find_gap.m4", pkginfo );
        
        TranslateTemplate(fail, "autogen.sh", pkginfo );
        Exec(Concatenation("chmod a+x ", pkginfo.PackageName, "/autogen.sh")); # FIXME HACK
        
        PrintTo( Concatenation( pkginfo.PackageName, "/VERSION" ), pkginfo.Version );
    fi;
    

    #
    # Phase 3 (optional): Setup a git repository and gh-pages
    #
    if repotype = "git" then

        # TODO
        #if Command("git", ["init"]) = fail then
        #  Error("Failed to create git repository");
        #fi;

        #TranslateTemplate(fail, ".gitignore", pkginfo );
    elif repotype = "hg" then

        # TODO
        #if Command("hg", ["init"]) = fail then
        #  Error("Failed to create git repository");
        #fi;

        #TranslateTemplate(fail, ".hgignore", pkginfo );
    fi;
end;
