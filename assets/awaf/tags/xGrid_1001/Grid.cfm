<!--- Author:	Arowolo Abiodun M.
----- Created	17/02/2012
----- Updated	17/02/2012
----- Copyright	adexfe systems (c) 2009
----- About		Coldfusion custom tag for AWAF --->

<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start"> 
    
	<cfparam name="Attributes.renderTo" type="string"/>
    <cfparam name="Attributes.url" type="string"/> 
    <cfparam name="Attributes.firstsortOrder" type="string" default="ASC"/>
    <cfparam name="Attributes.commandWidth" type="string" default=""/>
    <cfparam name="Attributes.class" type="string" default="table-striped"/>
    <cfparam name="Attributes.pageSize" type="numeric" default="20"/>
 	
    <cfset request.grid.renderTo = Attributes.renderTo/>
    <!--- add dynamic string to the url--->
    <!--- TODO: add the above to refresh on Grid --->
    <cfif Find('?',Attributes.url)>
    	<cfset Attributes.url = Attributes.url & "&__grd=" & RandRange(0,999999)/>
    <cfelse>
    	<cfset Attributes.url = Attributes.url & "?__grd=" & RandRange(0,999999)/>
    </cfif> 
<script type="text/javascript" charset="utf-8">
	document.addEvent('domready', function() { 
        var _g = new aGrid('#Attributes.renderTo#', {			
			url : '#Attributes.url#', 
			firstsortOrder: '#Attributes.firstsortOrder#',
			perPage : #Attributes.pageSize#,
			'class': '#Attributes.class#',
			<cfif Attributes.commandWidth neq "">commandWidth: '#Attributes.commandWidth#',</cfif>	     
<!--- close tag --->   
<cfelse>  
	

});
</script>	
   
 

</cfif> 
</cfoutput>