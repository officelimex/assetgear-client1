<!--- Author:	Arowolo Abiodun M.
----- Created	26/02/2012
----- Updated	26/02/2012
----- Copyright	adexfe systems (c) 2009
----- About		xTab Coldfusion custom tag --->

<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">  
     <cfparam name="Attributes.TagName" type="string" default="TabRequest"/>
     <cfparam name="Attributes.id" type="string"/>
     <cfparam name="Attributes.IsApplicationTab" type="boolean" default="false"/>
     <cfparam name="Attributes.IsModuleTab" type="boolean" default="false"/>
     
<script language="Javascript" type="text/javascript">

	window.addEvent('domready', function()	{
	<cfif Attributes.IsApplicationTab>
		var tb = new aTab.Request('#Attributes.id#',{
			'cls' : {
				tabContainer : 's_tab_container',
				tabHandle : 's_tab_handle',
				tabContent : 's_tab_content',
				tabPane : 's_tab_pane',
				tab : 's_tab'
			}
		});
		
		tb.addEvent('rendercomplete', function()	{
			resizeTab();
		});
		
		tb.newTab('sd', '','',{clickable:false, class:'app_logo'}); 
	</cfif>	
	
	<cfif Attributes.IsModuleTab>
		var tb = new aTab.Request('#Attributes.id#',{'cls':{
			tabContainer : 'm_tab_container',
			tabHandle : 'm_tab_handle',
			tabContent : 'm_tab_content',
			tabPane : 'm_tab_pane',
			tab : 'm_tab'
		}});
	</cfif>		
<cfelse>
 });
</script>
</cfif>
</cfoutput>