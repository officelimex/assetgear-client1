<cfcomponent>

	<cffunction name="Sum" access="remote" returntype="string">
		<cfargument name="a" type="numeric" required="yes">
        <cfargument name="b" type="numeric" required="yes">
                
		<cfreturn arguments.a+arguments.b>
	</cffunction>

	<cffunction name="Multiply" access="remote" returntype="string">
		<cfargument name="a" type="string" required="no" default="0">
        <cfargument name="b" type="string" required="no" default="0">
        
        <cfset temp = val(arguments.a)*val(arguments.b)>
		<cfreturn NumberFormat(temp,'9,999.99')>
	</cffunction>
    
</cfcomponent>