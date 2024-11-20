<cfcomponent>

	<cffunction name="init" access="public" returntype="bQuery"> 
    
		<cfreturn this>
	</cffunction>
    
    <cffunction name="ExpandClause" access="public" returntype="string">
    	<cfargument name="IdList" required="yes" type="string">
        <cfargument name="Field" required="yes" type="string">
        <cfargument name="ReturnPrefix" required="no" type="string" default="">
        <cfargument name="join" required="no" type="string" default="OR">
        
		<cfset inlist = "" />
        <cfloop list="#IdList#" index="lst">
            <cfset inlist = ListAppend(inList,'#Field# = #lst#','^') />
        </cfloop>
        <cfset inlist = replace(inlist,'^',' #join# ','ALL') />
        <cfset sql = " #inlist#" />
        
        <cfif trim(sql) neq "">
			<cfset sql ="#ReturnPrefix# (" & sql & ")" >
		</cfif>
        <cfreturn sql >
    </cffunction>
    
</cfcomponent>