<cfparam default="0" name="url.id"/>

<cfset astId = "__asset_c_all_asset_view" & url.id/>

<cfset Id1 = "#astId#_1"/>
<cfset Id2 = "#astId#_2"/>
<cfset Id3 = "#astId#_3"/>
<cfset Id4 = "#astId#_4"/>

<cfset Id6 = "#astId#_6"/>
<cfset Id7 = "#astId#_7"/>
<cfset Id8 = "#astId#_8"/>
<cfset Id9 = "#astId#_9"/>

<cfset Id10 = "#astId#_910"/>

<cfoutput>
<cfimport taglib="../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../assets/awaf/tags/xUtil/" prefix="util" />

<cfset qA = application.com.Asset.getAsset(url.id)/>

<cfquery name="qPA">
	SELECT * FROM asset
    WHERE AssetId <> <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>

<cfquery name="qAC">
	SELECT * FROM asset_category
    WHERE ParentAssetCategoryId IS NOT NULL
</cfquery>

<cfquery name="qAL">
	SELECT
    	CONCAT(l.Name,'~',al.LocationId) Location,l.Name,
    	al.Status, al.Quantity, al.AssetId, al.AssetLocationId
    FROM asset_location al
    INNER JOIN location l ON al.LocationId = l.LocationId
    WHERE AssetId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>

<cfquery name="qPM" cachedwithin="#CreateTime(24,0,0)#">
	SELECT
    	pm.*,
        f.Description Frequency,
        rt.Code ReadingType,
        d.Name Department,
        u.Name unit
    FROM pm_task pm
    LEFT JOIN frequency f ON f.FrequencyId = pm.FrequencyId
    LEFT JOIN reading_type rt ON rt.ReadingTypeId = pm.ReadingTypeId
    INNER JOIN core_department d ON d.DepartmentId = pm.DepartmentId
    LEFT JOIN core_unit u ON u.UnitId = pm.UnitId
    INNER JOIN asset_location al ON al.AssetLocationId = pm.AssetLocationId
    WHERE pm.AssetLocationId = #val(qAL.AssetLocationId)#
    	AND pm.IsActive = "yes"
</cfquery>

<cfquery name="qD">
	SELECT * FROM core_department
</cfquery>

<cfquery name="qMR">
	SELECT * FROM reading_type
</cfquery>

<cfquery name="qEx">
    SELECT ExpirationId,AssetId,Title,DATE_FORMAT(Date,'%Y/%m/%d')Date,Reminder FROM expiration
    WHERE AssetId = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#url.id#"/>
</cfquery>

<f:Form id="#astId#frm" action="">
<div id="#Id1#">
<table width="100%" border="0">
  <tr>
    <td width="50%" valign="top">

    <util:FileView type="p" table="asset" pk="#url.id#" source="doc/photo/" column="1"/>


    </td>
    <td valign="top">
     <f:Label name="Name" value="#qA.Description#" />

    <f:Label name="Category" value="#qA.AssetCategory#" />
    <f:Label name="Parent Asset" value="#qA.ParentAsset#" />

    <f:Label name="Status" value="#qA.Status#" />
    <f:Label name="Meter Reading type" value="#qA.ReadingType#" />

    <!---<f:Label name="Location" value="#qA.Location#" />--->
    <f:Label name="Model" value="#qA.Model#" />
    <f:Label name="Serial ##" value="#qA.SerialNumber#"/>
    <f:Label name="Class" value="#qA.Class#"/>
    <f:Label name="Ownership" value="#qA.Ownership#"/>
    <!---<f:CheckBox name="DepartmentIds" ListValue="#ValueList(qD.DepartmentId)#" ListDisplay="#ValueList(qD.Name)#" inline showlabel label="Department" />--->
    </td>
  </tr>
</table>

</div>
<div id="#Id2#">
    <table width="100%" border="0">
      <tr>
        <td width="40%" valign="top">
        <util:ViewCustomFields table="asset" pk="#url.id#"/>
        </td>
        <td class="horz-div" valign="top" style="padding-left:10px;">
			<table class="table">
				<thead>
					<tr>
						<th>Location</th>
						<th>Quantity</th>
						<th>Status</th>
					</tr>
				</thead>
				<cfloop query="qAL">
					<tr>
						<td>#qAL.Name#</td>
						<td>#qAL.Quantity#</td>
						<td>#qAL.Status#</td>
					</tr>
				</cfloop>
			</table>

			<table class="table">
				<thead>
					<tr>
						<th>Expiration name</th>
						<th>Expiration date</th>
						<th>Reminder</th>
					</tr>
				</thead>
			  <cfloop query="qEx">
			  <tr><td>#qEx.Title#</td>
			    <td>#qEx.Date#</td>
			    <td>#qEx.Reminder# days</td>
			  </tr></cfloop>
			</table>

        </td>
      </tr>
    </table>
</div>
<div id="#Id4#">
<table class="table table-striped table-condensed table-hover"><thead><tr>
    <th>##</th><th>Description</th>
    <th>Quantity</th>
    <th>Location</th>
  </tr></thead>
<cfif listlen(qA.ItemIds)>
<cfquery name="qSP" cachedwithin="#CreateTime(1,0,0)#">
	#application.com.Item.WAREHOUSE_ITEM_SQL#
    WHERE ItemId IN (#qA.ItemIds#)
</cfquery>
<tbody>
<cfloop query="qSP">
  <tr><td>#qSP.ItemId#</td><td>#qSP.ItemDescription#</td>
    <td>#qSP.QOH# #qSP.UM#</td>
    <td>#qSP.Location#</td>
  </tr></cfloop>
  </tbody>
</cfif>
</table>
</div>

<div id="#Id6#">
</div>
<div id="#Id7#" align="left">
	#qA.Note#
</div>
<div id="#Id8#">
	<cfquery name="qJH" cachedwithin="#CreateTime(24,0,0)#">
		SELECT
			wo.Description, wo.WorkOrderId, wo.DateOpened,
			u.Name Unit, TotalCost
		FROM work_order wo
			LEFT JOIN core_unit u ON u.UnitId = wo.UnitId
		WHERE AssetId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
			AND wo.Status = 'close'
		ORDER BY wo.DateOpened DESC
		LIMIT 0,10
	</cfquery>
	<cfquery name="qFR" cachedwithin="#CreateTime(24,0,0)#">
			SELECT
				f.*
			FROM
				asset_failure_report AS f
			INNER JOIN asset_location AS al ON f.AssetLocationId = al.AssetLocationId
			INNER JOIN asset AS a ON al.AssetId = a.AssetId
	</cfquery>
	<table class="table table-striped table-condensed table-hover">
		<thead>
			<tr>
	   		<th>WO ##</th>
				<th>Description</th>
				<th>Department</th>
				<th nowrap="nowrap">Date opened</th>
				<th nowrap="nowrap" style="text-align:right;">Cost(&##8358;)</th>
			</tr>
		</thead>
		<cfloop query="qJH">
			<tr>
				<td><a href="modules/maintenance/workorder/print_workorder.cfm?id=#qJH.WorkOrderId#" target="_blank">#qJH.WorkOrderId#</a></td>
				<td>#qJH.Description#</td>
				<td>&nbsp;#qJH.Unit#</td>
				<td>#dateformat(qJH.DateOpened,'dd-mmm-yyyy')#</td>
				<td style="text-align:right;">#Numberformat(TotalCost,'9,999.99')#</td>
			</tr>
		</cfloop>
	</table>

	<cfif qJH.recordcount>
		<div align="center"><a href="modules/maintenance/asset/print_job_history.cfm?id=#url.id#" target="_blank">View Job History Report</a></div>
	</cfif>
	<cfif qJH.recordcount>
		<div align="center"><a href="modules/maintenance/asset/print_asset_failure_history.cfm?id=#url.id#" target="_blank">View Failure Report History</a></div>

	</cfif>


</div>
<div id="#Id9#">
<table class="table table-striped table-condensed table-hover"><thead><tr>
  <th>##</th>
    <th>Task</th>
    <th>Department/Unit</th>
    <th>Freq/Milestone</th>
  </tr></thead>
  <cfloop query="qPM">
  <tr>
    <td>#qPM.PMTaskId#</td>
    <td>#qPM.Description#</td>
    <td><cfif qPM.UnitId eq 0>#qPM.Department#<cfelse>#qPM.Unit#</cfif> </td>
    <td><cfif qPM.Type eq "d">#qPM.Frequency#<cfelse>#qPM.Milestone# #ReadingType#</cfif></td>
  </tr></cfloop>
</table>
</div>

<div id="#Id10#" align="center">
<table width="250" border="1">
  <tr>
    <td style="padding:5px;">#qA.Description#. &mdash;#url.id#</td>
    <td width="80" align="right"><img src="http://chart.apis.google.com/chart?chs=110x110&cht=qr&chl=http://#application.appName#.assetgear.net/services/view_asset.cfm?id=#url.id#&choe=UTF-8&chld=M|1" /></td>
  </tr>
  </table>

</div>

<nt:NavTab renderTo="#astId#">
	<nt:Tab>
   	<nt:Item title="General" isactive/>
		<nt:Item title="Specs., Exp. & Locations"/>
		<nt:Item title="Spare Parts"/>
		<nt:Item title="Attachments"/>
		<nt:Item title="Note"/>
		<nt:Item title="Job History"/>
		<nt:Item title="PM Task"/>
		<nt:Item title="Tag"/>
   </nt:Tab>
   <nt:Content>
		<nt:Item id="#Id1#" isactive/>
		<nt:Item id="#Id2#"/>
		<nt:Item id="#Id4#"/>
		<nt:Item id="#Id6#"/>
		<nt:Item id="#Id7#"/>
		<nt:Item id="#Id8#"/>
		<nt:Item id="#Id9#"/>
		<nt:Item id="#Id10#"/>
    </nt:Content>
</nt:NavTab>
</f:Form>
</cfoutput>
