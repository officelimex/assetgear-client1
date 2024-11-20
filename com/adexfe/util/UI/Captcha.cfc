<cfcomponent extends="assetgear.com.adexfe.util.Random">
	
	<cffunction name="Init" access="public" returntype="Captcha">
	
		<cfreturn this>
	</cffunction>
	
	<cffunction name="Create" access="public" returntype="string">
		<cfargument name="text" required="no" default="#RandValue(6)#" type="string"> 
		<cfargument name="level" required="no" default="low" type="string" hint="high, medium, low">
		
		<cfimage required action="captcha" text="#arguments.text#" difficulty="#arguments.level#">
		
		<cfreturn arguments.text>
	</cffunction>
    
</cfcomponent>