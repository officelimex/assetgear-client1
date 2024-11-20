<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

    <cfparam name="Attributes.TagName" type="string" default="Label"/>  
    <cfparam name="Attributes.name" type="string" default=""/>
    <cfparam name="Attributes.value" type="string" default=""/>
  
 	<div class="control-group" style="margin-bottom:2px;">
    <label class="control-label">#Attributes.name#:</label>
	<div class="controls" style="padding-top:5px; color:##666666;">
    #replace(Attributes.value,chr(10),'<br/>','all')#
    </div>
<cfelse>
 </div>     
</cfif> 
</cfoutput>