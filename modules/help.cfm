<!--- 
	Author: Arowolo Abiodun
	Created: 2011/09/29
	Modified: 2011/09/29
	-> this page starts up the home page of the application
--->
<cfoutput>

<cfimport taglib="../assets/awaf/tags/xTab_1000/" prefix="t" />

<t:TabRequest id="#application.Module.Help.name#" IsModuleTab>
	<cfset qP = application.com.Module.getPagesByModule(application.Module.Help.id)/>
    <cfloop query="qP">
    	<t:Tab id="#qP.Code#" title="#qP.Title#" url="#qP.URL#"/>
    </cfloop>
    <t:DefaultTab renderTo="__help" tabid="__ams_help"/>
</t:TabRequest>

</cfoutput>