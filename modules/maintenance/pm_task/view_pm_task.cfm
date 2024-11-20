<cfparam default="0" name="url.id"/>

<cfparam name="url.cid" default=""/>
<cfset pmtId = "__pm_task_c_all_pm_task#url.cid#" & url.id/>

<cfoutput>
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />

<cfquery name="qPM">
	SELECT * 
    FROM pm_task
    WHERE PMTaskId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>
  
<cfquery name="qD">
	SELECT * 
    FROM core_department
    WHERE DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qPM.DepartmentId#"/>
</cfquery>

<cfquery name="qF">
	SELECT * 
    FROM frequency 
    WHERE FrequencyId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qPM.FrequencyId#"/>
</cfquery>
<cfquery name="qRT">
	SELECT * 
    FROM reading_type
    WHERE ReadingTypeId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qPM.ReadingTypeId#"/>
</cfquery>
<cfif url.id eq 0>
	<br/>
</cfif>
<cfparam name="getType" default=""/>
<f:Form id="#pmtId#frm" action="modules/ajax/maintenance.cfm?cmd=SavePMTask" EditId="#url.id#"> 

<table width="100%" border="0">
  <tr> 
    <td width="50%" valign="top"> 
			<f:Label name="Description" value="#qPM.Description#"/>
			<cfset qA = application.com.Asset.GetAssetByAssetLocatonIds(qPM.AssetLocationId)/>
			<f:Label name="Assets" value="#valuelist(qA.Asset)#"/>
			<f:Label name="Department" Value="#qD.Name#"/>
			<f:Label name="Is Active" value="#qPM.IsActive#"/>
    </td>
    <td class="horz-div" valign="top"> 
        <cfif qPM.Type eq 'd'>
        	<cfset getType = "Date"/>
        <cfelse>
            <cfset getType = "Milestone"/>
        </cfif>
        <f:Label name="Type" value="#getType#"/> 
        <cfif qPM.Type eq "d">
            <f:Label name="Frequency" Value="	#qF.Description#"/>
            <f:Label name="Notify" value="#qPM.NotifyBefore#"/>
            <f:Label name="Start Time" value="	#dateformat(qPM.StartTime,'yyyy/mm/dd')#"/>
        <cfelse>
            <f:Label name="Reading Type" Value="	#qRT.Type#"/>
            <f:Label name="Milestone" label="Recurring: Every" required value="#qPM.Milestone#" class="span4"/>
            <f:Label name="Notify Before" value="#qPM.NotifyBefore#" />
        </cfif>
    </td>
  </tr> 
  <tr>
  	<td colspan="2" >
 		<br/><f:Label name="Task Details" value="#qPM.TaskDetails#"  class="12"/>    
    </td>
  </tr>
  <tr>
  	<td colspan="2">
    	<f:Label name="Note" value="#qPM.Note#"  class="12"/> 
    </td>
  </tr>
</table>


</f:Form>

</cfoutput>