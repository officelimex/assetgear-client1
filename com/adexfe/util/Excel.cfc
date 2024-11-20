<cfcomponent output="yes">

	<cffunction name="init" access="public" returntype="Excel">
      
		<cfreturn this>
	</cffunction>
    
    <cffunction name="getExcelSheet" access="public" output="true" returntype="any" > 
       <cfargument name="filename" required="true" type="string" />
       <cfargument name="sheetName" default="sheet1" type="string" />
       <cfscript>
          var c = "";
          var stmnt = "";
          var rs = "";
          var sql = "Select * from [#sheetName#$]";
          var myQuery = ""; 
		 //WriteOutput(fileExists(arguments.filename));
          if(len(trim(arguments.filename)) and fileExists(arguments.filename))
	
          {
             try
             {
                CreateObject("java","java.lang.Class").forName("sun.jdbc.odbc.JdbcOdbcDriver");
                c = CreateObject("java","java.sql.DriverManager").getConnection("jdbc:odbc:Driver={Microsoft Excel Driver (*.xls)};DBQ=" & arguments.filename );
                stmnt = c.createStatement();
                rs = stmnt.executeQuery(sql);
                myQuery = CreateObject('java','coldfusion.sql.QueryTable').init(rs);
             }
             catch(any e)
             {
                // error-handling code 
                WriteOutput(e);
             }   
          }
          return myQuery;
       </cfscript> 
    </cffunction>
    
</cfcomponent>