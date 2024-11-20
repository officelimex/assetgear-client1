<cfoutput>

    <cfscript>
    
        transaction action="begin"  {
            query name="qF"     {
                echo('SELECT * FROM `file` WHERE FileId=#val(url.id)#')
            }
            cpath = expandPath("../../../../doc/");
            path1 = "#cpath#attachment/#qF.Table#/#qF.PK#/#qF.File#"
            path2 = "#cpath#photo/#qF.Table#/#qF.PK#/#qF.File#"
            if (fileExists(path1)) {
              fileDelete(path1)
            }
            if (fileExists(path2)) {
              fileDelete(path2)
            }
            // file action="delete" file="#cpath#attachment/#qF.Table#/#qF.PK#/#qF.File#";
            // go ahead and remove the file on the database
            query name="qF"     {
                echo('DELETE FROM `file` WHERE FileId=#val(url.id)#')
            } 
        }
        
    </cfscript>
    
    <cfobjectcache action = "clear">
    
</cfoutput>