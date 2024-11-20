<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">
  
    <cfparam name="Attributes.TagName" type="string" default="Set"/> 
 	<cfparam name="Attributes.value" type="string"/>
    <cfparam name="Attributes.name" type="string" default=""/>
    <cfparam name="Attributes.color" type="string" default=""/> 
    <cfparam name="Attributes.isSliced" type="string" default=""/>
    
    <!---<cfassociate basetag="cf_Chart,cf_Dataset"/>---> 
    
<!--- close tag --->   
<cfelse>
    <cfset nval = ""/>
    
    <cfif Attributes.name neq ""><cfset nval = "name='#Attributes.name#'"/></cfif>
    <cfif Attributes.color neq ""><cfset nval = nval & "color='#Attributes.color#'"/></cfif>
    <cfif Attributes.isSliced neq ""><cfset nval = nval & "isSliced='#Attributes.isSliced#'"/></cfif>
    
    
    <cfset request.chart.xmldata = request.chart.xmldata & "<set value='#Attributes.value#' #nval#/>"/> 
 
</cfif> 
</cfoutput>