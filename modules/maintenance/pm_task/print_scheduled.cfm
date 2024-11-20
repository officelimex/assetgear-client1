 <cfoutput>

<cfdocument pagetype="a4" format="pdf" margintop="0.1" marginbottom="0" marginleft="0" marginright="0" orientation="portrait">
<html>
<head>
<cfset bg = "##f0f2f8"/>
<cfset brd_c = "##d6daeb"/>
<cfset brd_c2 = "##5364a9"/>
<style type="text/css">
	html,body{padding:0; margin:0;font: 12px Tahoma;}
	.head_section td{font-size: 11px;padding:5px;}
	.head_section td.left{background-color:#bg#;border-left:#brd_c# 1px solid;}
	.head_section td.left,.head_section td.right{border-top:#brd_c# 1px solid;border-right:#brd_c# 1px solid;}
	.head_section td.bottom{border-bottom:#brd_c# 1px solid;}
	.sub_head{font-size:10px; background-color:#bg#;border-top:#brd_c# 1px solid; padding:5px;}
	.content{font-size:11px;padding:5px;}
	.tbl{
	font-size: 9px;
}
	.tbl th, .tbl tr.hd td{font-weight: normal;background-color:#bg#;border-top:#brd_c2# 2px solid;border-right:#brd_c# 1px solid; text-align:left; padding:4px;}
	.tbl th.left,.tbl tr.hd td.left{border-left:#brd_c# 1px solid;}
	.tbl td{
	padding: 3px 5px;
border-bottom:#brd_c# 1px solid;border-right:#brd_c# 1px solid;}
	.tbl td.left{border-left:#brd_c# 1px solid;}
	.tbl tr.bottom td{border-bottom:#brd_c# 1px solid;}
	.tbl td.no-right{border-right:none;}
	.tbl td.cbg{background-color:#bg#;}
	.tbl td.no-bottom{border-bottom:none !important;}
	.a-right{text-align:right !important;}
</style>
</head>
<body>
<table width="100%">

<cfdocumentitem type = "header">
<cfset request.letterhead.title="Assets PM Task"/>
<cfset request.letterhead.Id=""/>
<cfset request.letterhead.date = "Date: #dateformat(Now(),'mmmm yyyy')#"/>
<cfif isdefined("url.w")>
	<cfset request.letterhead.date = "Period: #dateformat(sd,'mmmm yyyy')# (Weekly)"/>
</cfif>
<cfinclude template="../../../include/letter_head.cfm"/>

</cfdocumentitem>
<cfquery name="qAS">
    SELECT
        pm.*,
        a.Description Asset, a.AssetId,
        f.Description Frequency,
        rt.Type ReadingType,
        l.Name Location
    FROM
        pm_task pm
    INNER JOIN asset_location al ON al.AssetLocationId = pm.AssetLocationId
    INNER JOIN location l ON l.LocationId = al.LocationId
    INNER JOIN asset a ON a.AssetId = al.AssetId
    LEFT JOIN frequency f ON pm.FrequencyId = f.FrequencyId
    LEFT JOIN reading_type rt ON pm.ReadingTypeId = rt.ReadingTypeId
    WHERE a.Description LIKE "%#form.assetname#%"
    AND IsActive = "Yes"
</cfquery>
<cfquery name="qA">
	#application.com.Asset.ASSET_SQL#
    WHERE a.description LIKE "%#form.assetname#%"
    AND a.Status = "Online"
</cfquery>
<cfloop query="qA">
    <div class="sub_head" style="padding-left:20px">#Description#</div>
    <td>
    	<table width="100%" align="right" class="tbl">
        	<tr bgcolor="##FFDFDF">
            	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                <td width="40px">##</td>
            	<td width="100px">Location</td>
            	<td width="170px">Task</td>
            	<td width="90px">Frequency</td>
            	<td width="40px">MileStone</td>
            </tr>
            <cfquery name="qAS" result="rt">
                SELECT
                    pm.*,
                    a.Description Asset, a.AssetId,
                    f.Description Frequency,
                    rt.Type ReadingType,
                    l.Name Location
                FROM
                    pm_task pm
                INNER JOIN asset_location al ON al.AssetLocationId = pm.AssetLocationId
                INNER JOIN location l ON l.LocationId = al.LocationId
                INNER JOIN asset a ON a.AssetId = al.AssetId
                LEFT JOIN frequency f ON pm.FrequencyId = f.FrequencyId
                LEFT JOIN reading_type rt ON pm.ReadingTypeId = rt.ReadingTypeId
                WHERE a.AssetId = "#AssetId#"
                AND IsActive = "Yes"
            </cfquery>
            <cfif rt.recordcount eq 0>
                    <tr>
                        <td colspan="6" align="center"> No Pm Task Available</td>
                    </tr>
            <cfelse>
                <cfloop query="qAS">
                    <tr>
                        <td></td>
                        <td width="40px">#PMTaskId#</td>
                        <td width="100px">#Location#</td>
                        <td width="170px"><cfif Description eq "">-<cfelse>#Description#</cfif></td>
                        <td width="80px"><cfif Frequency eq "">-<cfelse>#Frequency#</cfif></td>
                        <td width="80px">#Milestone# #ReadingType#</td>
                    </tr>
                </cfloop>
            </cfif>
        </table>
    </td>
</cfloop>

<!---<cfloop query="qA">
    <cfquery name="qW">
        #application.com.WorkOrder.WORK_ORDER_PM_SQL#
        WHERE wo.DepartmentId = #qD.Departmentid#
        <!--- include unit --->
        <cfif qD.UnitId neq 0>
        	AND wo.UnitId = #val(qD.UnitId)#
        </cfif>
        	AND wo.DateOpened >= <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(sd,'yyyy/mm/dd')#"/>
            AND wo.DateOpened <= <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(ed,'yyyy/mm/dd')#"/>
        ORDER BY wo.DateOpened
    </cfquery>

<tr>
  <td height="19" align="center" valign="middle" style="font-size:10px;">#qD.Department# Department <cfif qD.Unit neq "">(#qD.Unit#)</cfif></td>
</tr>

<tr>
  <td>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl">
  <tr class="hd">
    <td class="left">&nbsp;</td>
    <td nowrap>WO ##</td>
    <td>Task ##</td>
    <td>Asset</td>
    <td>Locations</td>
    <td>Task</td>
    <td nowrap="nowrap">PM date</td>
    <td nowrap="nowrap">Close date</td>
    <td nowrap="nowrap" width="1px">Status</td>
  </tr>
    <cfloop query="qW">
      <tr>
        <td class="left">#qW.currentrow#</td>
        <td nowrap>#qW.WorkOrderId#</td>
        <td><cfif qW.Frequency eq "">#qW.Milestone# #qW.ReadingType#<cfelse>#qW.Frequency#</cfif>/#qW.PMTaskId#</td>
        <td>#qW.Asset#</td>
        <td>
		<cfset qA = application.com.Asset.GetAssetByAssetLocatonIds(qW.AssetLocationIds)/>
		<!---<cfset ast = valueList(qA.Location,'`')/>
        #replace(ast,'`','<br/>','all')#--->
        <cfif qA.ParentLocation neq "">
        	#qA.ParentLocation#/
        </cfif>#qA.Location#
        </td>
        <td>#qW.Description#</td>
        <td nowrap>#dateformat(qW.DateOpened,'dd-mmm-yy')#</td>
        <td nowrap>#dateformat(qW.DateClosed,'dd-mmm-yy')#&nbsp;</td>
        <td>#qW.Status#</td>
      </tr>
    </cfloop>
</table>
  </td>
</tr>

<tr>
  <td>&nbsp;</td>
</tr>
<cfdocumentitem type="pagebreak"/>
</cfloop> --->
<cfdocumentitem type="footer">
<tr><td ><table width="100%" border="0" style="font:7px Tahoma; border-top:1px solid ##ECF4CF; padding-left:15px;">
  <tr>
  <td nowrap="nowrap"><!---#qD.Department# Department--->
  </td>
    <td align="right">Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#</td>
</tr></table></td></tr>
</cfdocumentitem>
</table>
</body>
</html>
</cfdocument>

</cfoutput>jklhkjhk
