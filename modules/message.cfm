<cfoutput>
<cfimport taglib="../assets/awaf/tags/xTab_1000/" prefix="t" />

<t:TabRequest id="#application.Module.Messages.name#" IsModuleTab>
	<cfset qP = application.com.Module.getPagesByModule(application.Module.Messages.id)/>
    <cfloop query="qP">
    	<t:Tab id="#qP.Code#" title="#qP.Title#" url="#qP.URL#"/>
    </cfloop>
    <t:DefaultTab renderTo="__message" tabid="__inbox"/>
</t:TabRequest>
</cfoutput> 
