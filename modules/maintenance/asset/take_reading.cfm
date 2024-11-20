<!--- 
	Author: Arowolo Abiodun
	Created: 2011/09/30
	Modified: 2011/09/30
	-> edit a page 
--->
<cfparam default="0" name="url.id"/>
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />

<cfset astcId = '__asset_c_meter_reading' & url.id/>

<cfquery name="qMR">
	#application.com.Asset.METER_READING_SQL#
    WHERE al.AssetLocationId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery> 

<cfoutput>
 
<f:Form id="#astcId#frm" action="modules/ajax/maintenance.cfm?cmd=TakeAssetReading" EditId="#url.id#">
	<f:Label name="Last Reading" value="#numberformat(qMR.CurrentReading,'9,999.99')# #qMR.ReadingCode#"/>
    <input type="hidden" value="#qMR.CurrentReading#" name="PreviousReading"/> 
    <input type="hidden" value="#qMR.AssetLocationId#" name="AssetLocationId"/> 
    <f:DatePicker name="EntryDate" label="Entry date" required value="#dateformat(now(),'yyyy/mm/dd')#"/> 
    <f:TextBox name="CurrentReading" label="Current Reading" required class="span3" inlinehelp="#qMR.ReadingType# (#qMR.ReadingCode#)"/> 
    <f:TextArea name="Comment" label="Comment/Remark" class="span7" inlinehelp=""/>
</f:Form> 

<cfquery name="qM" result="rt">
	SELECT
    	t.PMTaskId, t.Description, t.Milestone,
    	m.Reading CurrentReading
    FROM pm_task t
    INNER JOIN asset_location al ON al.AssetLocationId = t.AssetLocationId
    INNER JOIN pm_milestone m ON m.PMTaskId = t.PMTaskId
    WHERE al.AssetLocationId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
    	AND t.Type = "m"
        AND t.Isactive = "yes"
</cfquery>
<table class="table"><thead>
  <tr>
    <th>##</th>
    <th>Task</th>
    <th>Milestone</th>
    <th>Current</th>
    <th>Due at (#qMR.ReadingCode#)</th>
  </tr>
</thead>
  <tbody>
  
      <cfloop query="qM">
      <tr>
        <td>#qM.PMTaskId#</td>
        <td>#qM.Description#</td>
        <td>#qM.Milestone#</td>
        <td style="color:green;">#qM.CurrentReading#</td>
        <td style="color:red;">#numberformat(qMR.CurrentReading+(qM.Milestone-qM.CurrentReading),'9,999.99')#</td>
      </tr>
      </cfloop>
  
  </tbody>
</table>



</cfoutput>
<!---<script>

document.addEvent('domready', function() {

});
</script>--->