<cflock type="exclusive" scope="session" timeout="50">	
    <cfset StructClear(Session)/>
</cflock>

<cflocation addtoken="no" url="login.cfm"> 