<!--- 
	Author: Arowolo Abiodun
	Created: 2011/09/29
	Modified: 2011/09/29
	-> this page starts up the developer module: the developer module allows the developer/host manage the application
--->
<cfoutput>
<script language="Javascript" type="text/javascript">
	window.addEvent('domready', function()	{
		var tb3 = new aTab.Request('#application.Module.developer.name#',{'cls':{
			tabContainer : 'm_tab_container',
			tabHandle : 'm_tab_handle',
			tabContent : 'm_tab_content',
			tabPane : 'm_tab_pane',
			tab : 'm_tab'
		}});
		
		<!--- get pages under the developer module ---> 
		<cfset qPage = application.com.Module.getPagesByModule(application.Module.developer.id)/>
		<cfloop query="qPage">
			tb3.newTab('#qPage.Code#','#qPage.Title#','#qPage.URL#');
		</cfloop>

		$$('.__dev').adopt(tb3.render());
		<!--- display the first tab --->
		tb3.showTab('__page');

	});
</script>
</cfoutput>