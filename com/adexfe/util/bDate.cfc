<cfcomponent>

	<cffunction name="Init" access="public" returntype="bDate"> 
	 
		<cfreturn this>
	</cffunction>
	
	<cffunction name="DateFormat1" access="public" returntype="string" hint="return x years y months">
		<cfargument name="m" hint="months" type="numeric">
		
		<cfset temp = "">
		
		<cfif arguments.m neq 0>
		
			<cfset y = arguments.m \ 12>
			<cfset mon = abs((y * 12) - arguments.m)>
			
			<cfif y gt 0>
				<cfif y eq 1>
					<cfset temp = "#y# Year">
				<cfelse>
					<cfset temp = "#y# Years">
				</cfif>
			</cfif>
			
			<cfif mon eq 1>
				<cfset temp = temp & " #mon# Month">
			<cfelseif mon gt 1>
				<cfset temp = temp & " #mon# Months">
			</cfif>
		</cfif>
		
		<cfreturn trim(temp)>
	</cffunction>
	
</cfcomponent>