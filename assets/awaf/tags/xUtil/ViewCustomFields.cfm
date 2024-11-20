<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">
    <cfparam name="Attributes.TagName" type="string" default="ViewCustomFields"/> 
    <cfparam name="Attributes.table" type="string"/>
    <cfparam name="Attributes.pk" type="numeric"/>

    <cfquery name="qF">
        SELECT * FROM `custom_field`
        WHERE `Table` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.table#"/>
            AND `PK` = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.pk#"/>
    </cfquery>

    
    <cfloop query="qF">
<div class="control-group" style="margin-bottom:2px;">
    <label class="control-label">#qF.Field#:</label>
	<div class="controls" style="padding-top:5px; color:##666666;">
    #replace(qF.Value,chr(13),'<br/>','all')#
    </div> </div>
    </cfloop>
 
<cfelse>
	
</cfif>
</cfoutput>
