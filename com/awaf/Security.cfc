<cfcomponent>

	<cffunction name="init" access="public" returntype="Security"> 
    	<cfargument name="UseCaptcha"  type="boolean" default="false" />
        <cfargument name="UseLock" type="boolean" default="false" />
        
        <cfset this.UseCaptcha = arguments.UseCaptcha>
        <cfset this.UseLock = arguments.UseLock>
        
		<cfreturn this />
	</cffunction> 
    
    <cffunction name="EncryptPassword" access="public" returntype="string">
    	<cfargument name="role" required="yes" type="string">
        <cfargument name="username" required="yes" type="string">
        <cfargument name="pwd" required="yes" type="string">
 
        <cfset stemp = hash(arguments.role & arguments.username & arguments.pwd,'SHA-512')>
        <cfreturn stemp />
    </cffunction>
    
</cfcomponent>