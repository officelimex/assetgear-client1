<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">
    <cfparam name="Attributes.TagName" type="string" default="Table"/> 
    <cfparam name="Attributes.Id" default="" />
    <cfparam name="Attributes.height" type="string" default="315px"/>
    <cfparam name="Attributes.allowInput" type="boolean" default="false"/>
    <cfif Attributes.allowInput>
    	<cfparam name="Attributes.allowUpdate" type="boolean" default="true"/>
    <cfelse>
    	<cfparam name="Attributes.allowUpdate" type="boolean" default="false"/>
    </cfif>
	<!---TODO:add allowDelete--->
    <cfparam name="Attributes.bind" type="string" default=""/>
    <cfparam name="Attributes.Event" type="string" default=""/>
    <cfparam name="Attributes.data" type="string" default=""/><!--- enter the url to product json data in this format data[['x',44],[],[],[]] ---->
 
 	<cfset sid = CreateUUID()/>

    <cfset request.tabletag.sessionid = sid/>

    <input type="hidden" name="#Attributes.Id#" value="#sid#"/>
    
    <cfset _id = "_#left(sid,'8')#"/>
<div id="#_id#"></div> 

<script type="text/javascript">
window.addEvent('domready', function()  {       
    var ae = new aEditTable('#_id#',{
        'allowInput':#Attributes.allowInput#,'allowUpdate':#Attributes.allowUpdate#, height:'#Attributes.height#', sessionId:'#sid#',
<cfelse>

    });
	<cfif Attributes.bind neq "">
	<cfset i=0/>
	<cfloop list="#Attributes.bind#" index="elbind" delimiters=",">
	<cfset i++/>
	$('#request.form.formid##elbind#').addEvent('#listgetat(Attributes.Event,i)#', function(e){
		new Request.JSON({
			url: '#listgetat(Attributes.data,i)#&s=#sid#&id='+e.target.value,
			onFailure: function()	{
				alert('error');
			}, 
			onSuccess: function(x){
				ae.clear();
				ae.addRows(x.data);
			}
		}).send();	
	})
	</cfloop>
    </cfif>
	 
});

</script>
</cfif>
</cfoutput>
