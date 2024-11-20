<!--- 
	Author: Arowolo Abiodun
	Created: 2011/09/30
	Modified: 2011/09/30
	-> edit a page 
--->
<cfparam default="0" name="url.id"/>
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />

<cfset rdtId = '__maintenance_setting_c_reading_type' & url.id/>

<cfquery name="qP">
	SELECT * FROM reading_type
    WHERE ReadingTypeId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>


<cfoutput>

<f:Form id="#rdtId#frm" action="modules/ajax/settings.cfm?cmd=SaveReadingType" EditId="#url.id#"> 
    <f:TextBox name="Code" label="Code" required value="#qP.Code#"/> 
    <f:TextBox name="Type" label="Type" required value="#qP.Type#"/> 
</f:Form>

</cfoutput>