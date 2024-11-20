<!--- 
	Author: Arowolo Abiodun
	Created: 2011/09/29
	Modified: 2011/09/29
	-> this page starts up the home page of the application
--->
<cfoutput>
<script language="Javascript" type="text/javascript">
	window.addEvent('domready', function()	{
		var tb3 = new aTab.Request('#application.Module.Operations.name#',{'cls':{
			tabContainer : 'm_tab_container',
			tabHandle : 'm_tab_handle',
			tabContent : 'm_tab_content',
			tabPane : 'm_tab_pane',
			tab : 'm_tab'
		}});

		<cfset qP = application.com.Module.getPagesByModule(application.Module.Operations.id)/>
		<cfset qPr = application.com.Module.getPrivileges(application.Module.Operations.id, request.userinfo.role)/>
		<cfif qPr.PageIds eq "*" or qPr.Recordcount eq 0> <!--- host --->
			<cfloop query="qP">
				tb3.newTab('#qP.Code#','#qP.Title#','#qP.URL#');			
			</cfloop>
		<cfelse>
			<cfloop query="qP">
				<cfif ListFind(qPr.PageIds,qP.PageId)>
					tb3.newTab('#qP.Code#','#qP.Title#','#qP.URL#');
				</cfif>		
			</cfloop>
		</cfif>

		$$('.__maintenance').adopt(tb3.render());
		tb3.showTab('__db_maintenance');

	});
</script>
</cfoutput>