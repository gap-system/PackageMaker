

CreatePackage := function( pkgname )
    local author, version, date;

    author := ValueOptions( "author" );
    if author = fail then
        if IsBound( GlobalAuthor ) then
            author := GlobalAuthor;
        else
            Error("Missing author information");
        fi;
    fi;
    
    version := ValueOptions( "version" );
    if version = fail then
        version = "0.1";