<cfcomponent displayname="Color">
	
    <cffunction name="init" access="public" returntype="Color">
    	
        <cfreturn this />
    </cffunction>
    
    <cffunction name="RandColor" access="public" returntype="string">
    	<cfargument name="Type" default="safe" type="string" />
        
        <cfset var stemp = "" />
        <cfset var colorCode = "A,B,C,D,E,F,1,2,3,4,5,6,7,8,9,0" />
    	<cfif arguments.Type eq "safe">
        	<cfloop from="1" to="3" index="i">
        		<cfset ccode = listgetat(colorCode,RandRange(1,16)) />
                <cfset stemp = stemp & "#ccode##ccode#" />            
            </cfloop>
        <cfelse>
        	<cfloop from="1" to="6" index="i">
        		<cfset ccode = listgetat(colorCode,RandRange(1,16)) />
                <cfset stemp = stemp & "#ccode#" />            
            </cfloop>
		</cfif>
        <cfreturn stemp />
    </cffunction>
    
</cfcomponent>