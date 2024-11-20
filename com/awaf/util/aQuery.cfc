<cfcomponent>
	
	<cffunction name="Init" returntype="aQuery" access="public">
		
		<cfreturn this/>
	</cffunction>

	<cffunction name="QueryToStruct" returntype="struct" hint="convert a query to struct">
		<cfargument name="q" type="query" required="true" hint="the query to convert" />
		
		<cfloop index="col" list="#q.ColumnList#">
			<cfset nS[col] = q[col]/>
		</cfloop>
		<cfreturn nS/>
	</cffunction>

</cfcomponent>