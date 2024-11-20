<!--- 
	Author: Arowolo Abiodun
	Created: 2011/09/30
	Modified: 2011/09/30
	-> edit a page 
--->
<cfparam default="0" name="url.id"/>
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />

<cfset shlId = '__warehouse_setting_c_shelf_location' & url.id/>

<cfquery name="qP">
	SELECT * FROM shelf_location
    WHERE ShelfLocationId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>


<cfoutput>

<f:Form id="#shlId#frm" action="modules/ajax/settings.cfm?cmd=SaveShelfLocation" EditId="#url.id#"> 
    <f:TextBox name="Code" label="Code" required value="#qP.Code#"/> 
</f:Form>

</cfoutput>