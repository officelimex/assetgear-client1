<!--- Author:	Arowolo Abiodun M.
----- Created	26/02/2012
----- Updated	26/02/2012
----- Copyright	adexfe systems (c) 2009
----- About		xNav Coldfusion custom tag --->

<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start"> 
	<cfparam name="Attributes.TagName" type="string" default="Nav"> 
	<cfparam name="Attributes.renderTo" type="string">
 	
    <cfset request.nav.navitem = ArrayNew(1)/>
               
<div class="well" style="padding: 8px 0; margin-top:30px">
<ul class="nav nav-list">   
<cfelse>
</ul>
</div> 
<script type="text/javascript">
	document.addEvent('domready', function() {
		<cfloop array="#request.nav.navitem#" index="navIt">
		$('#navIt.id#').addEvent('click', function(e)	{  
			 <!--- add window --->
			 <cfif StructKeyExists(navIt.Window,'TagName')>
				var aWin = new aWindow('#navIt.Window.id#',	{
					renderTo : $('#Attributes.renderTo#'),
					<cfif navIt.Window.title eq "">
						title : '#navIt.title#',
					<cfelse>
						title : '#navIt.Window.title#',
					</cfif>
					<!---warnBeforeClose : true,--->
					size : {
						height : '#navIt.Window.height#',
						width : '#navIt.Window.width#'
					}
				}); 				
				aWin.addContent(new aPane.Request('#navIt.Window.url#'));
				aWin.addCloseButton();
				<!---- add buttons --->
				<cfloop array="#navIt.Window.buttons#" index="butn">
					aWin.addButton(new aButton('#butn.id#', {
						value : '#butn.value#',
						'class' : '#butn.class#',
						click : function()	{ 
							// add validator 
							var frm = '#butn.formId#';
							new Form.Validator.Inline($(frm), { 								   
								onFormValidate: function(passed, form, event) {
									if (passed) {
										$(frm).set('send', {
											onFailure: function(r){showError(r)},
											onSuccess: function(){
												//alert('new page was successfuly created');
												aWin.close();
											}
										}).send();
									}
							}}).validate(); 
						}
					}));				
				</cfloop>	
			 </cfif>
		});
		</cfloop>
	});
</script>
</cfif> 
</cfoutput>