<cfcomponent hint="User Role" displayname="Role">

	<cffunction name="init" access="public" returntype="Role">   
        
        <cfset this.SQL_ROLE = "SELECT * FROM u_role" />
        
		<cfreturn this>
	</cffunction>
    
    <cffunction name="GetRole" access="public" returntype="query" hint="get role">
    	<cfargument name="rid" type="numeric" required="yes" hint="RoleId">
        
        <cfquery name="qRole">
        	#this.SQL_ROLE#
            WHERE RoleId = <cfqueryparam value="#arguments.roleid#" cfsqltype="cf_sql_integer">
        </cfquery>
        
        <cfreturn qRole/>
    </cffunction>
    
    <cffunction name="GetRoles" access="public" returntype="query" hint="get roles">
    	<cfargument name="rid" type="numeric" required="yes" hint="RoleId">
        
        <cfquery name="qRoles">
        	#this.SQL_ROLE#
            WHERE RoleId = <cfqueryparam value="#arguments.roleid#" cfsqltype="cf_sql_integer">
        </cfquery>
        
        <cfreturn qRoles />
    </cffunction>
        
</cfcomponent>