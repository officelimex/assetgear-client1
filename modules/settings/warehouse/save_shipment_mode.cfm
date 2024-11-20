<!--- 
	Author: Arowolo Abiodun
	Created: 2011/09/30
	Modified: 2011/09/30
	-> edit a page 
--->
<cfparam default="0" name="url.id"/>
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />

<cfset shmId = '__warehouse_setting_c_shipment_mode' & url.id/>

<cfquery name="qP">
	SELECT * FROM shipment_mode
    WHERE ShipmentModeId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>


<cfoutput>

<f:Form id="#shmId#frm" action="modules/ajax/settings.cfm?cmd=SaveShipmentMode" EditId="#url.id#"> 
    <f:TextBox name="Mode" label="Mode" required value="#qP.Mode#"/> 
    <f:TextBox name="Days" label="Days" required validate="integer" value="#qP.Days#"/> 
</f:Form>

</cfoutput>