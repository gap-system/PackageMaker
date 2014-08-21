if fail = LoadPackage("AutoDoc", ">= 2014.03.27") then
    Error("AutoDoc version 2014.03.27 is required.");
fi;


TranslateTemplate := function (template, outfile, subst)
    local out_stream, in_stream, line, pos, end_pos, key, val, i, tmp, c;
    
    if template = fail then
        template := Concatenation( "templates/", outfile, ".in" );
    fi;
    outfile := Concatenation( subst.PACKAGENAME, "/", outfile );

    in_stream := InputTextFile( template );
    out_stream := OutputTextFile( outfile, false );
    SetPrintFormattingStatus( out_stream, false );
    
    while not IsEndOfStream( in_stream ) do
        line := ReadLine( in_stream );
        if line = fail then
            break;
        fi;
        
        # Substitute {{ }} blocks
        pos := 0;
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
            if IsBound(subst.(key)) then
                val := subst.(key);
                if IsList(val) and IsRecord(val[1]) then
                    WriteAll( out_stream, line{[1..pos-1]} );
                    PrintTo( out_stream, "[\n" );
                    for i in [1..Length(val)] do
                        PrintTo( out_stream, "  rec(\n" );
                        for key in RecNames(val[i]) do
                            PrintTo( out_stream, "    ", key, " := ");
                            tmp := val[i].(key);
                            if IsString(tmp) then
                                PrintTo( out_stream, "\"" );
                                for c in tmp do
                                    if c = '\n' then
                                        WriteByte( out_stream, IntChar('\\') );
                                        WriteByte( out_stream, IntChar('n') );
                                    else
                                        WriteByte( out_stream, IntChar(c) );
                                    fi;
                                od;
                                PrintTo( out_stream, "\"") ;
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


CreatePackage := function( pkgname )
    local authors, version, date, subst;

    authors := ValueOption( "authors" );
    if authors = fail then
        if IsBound( DefaultAuthor ) then
            authors := [ DefaultAuthor ];
        else
            Error("Missing author information");
        fi;
    fi;
    
    version := ValueOption( "version" );
    if version = fail then
        version := "0.1";
    fi;
    
    date := ValueOption( "date" );
    if date = fail then
        # Use current date, in format DD/MM/YYYY
        # FIXME: This code has year 10,000 bug!
        date := DMYDay(Int(Int(CurrentDateTimeString(["-u", "+%s"])) / 86400));
        date := date + [100, 100, 0];
        date := List( date, String );
        date := Concatenation( date[1]{[2,3]}, "/", date[2]{[2,3]}, "/", date[3] );
    fi;
    
    # TODO: we should prevent overwriting existing data.
    # But during testing, it is useful to be able to re-generate things quickly

    if not AUTODOC_CreateDirIfMissing( pkgname ) then
        Error("Failed to create package directory");
    fi;

    if not AUTODOC_CreateDirIfMissing( Concatenation( pkgname, "/gap" ) ) then
        Error("Failed to create `gap' directory in package directory");
    fi;

    subst := rec(
        PACKAGENAME := pkgname,
        DATE := date,
        VERSION := version,
        DATE := date,
        SUBTITLE := "TODO",
#        AUTHORS := "[ rec( TODO := true ) ]",
        AUTHORS := authors,
    );

    # TODO: For the source files, use ReadPackage() instead or so?
    TranslateTemplate(fail, "PackageInfo.g", subst );
    TranslateTemplate(fail, "init.g", subst );
    TranslateTemplate(fail, "read.g", subst );
    TranslateTemplate(fail, "makedoc.g", subst );
    TranslateTemplate("templates/gap/PKG.gi", Concatenation("gap/", pkgname, ".gi"), subst );
    TranslateTemplate("templates/gap/PKG.gd", Concatenation("gap/", pkgname, ".gd"), subst );

    
    if ValueOption( "kernel" ) <> false then
        if not AUTODOC_CreateDirIfMissing( Concatenation( pkgname, "/src" ) ) then
            Error("Failed to create `src' directory in package directory");
        fi;
        # TODO: create a simple kernel extension and a build system??? 
    fi;

    # Optionally: ru
    if ValueOption( "git" ) <> false then
        # TODO:
        # git init
        # git add
        # git ci -m "New package PKGNAME"
    fi;


end;
