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
<cfset request.letterhead.title="Preventive Maintenance Task"/>
<cfset request.letterhead.Id=""/>
<cfset request.letterhead.date = ""/>
<cfinclude template="../../../include/letter_head.cfm"/>
</cfdocumentitem>
<cfset lst = createObject("component","assetgear.com.awaf.util.List").init()/>
<cfquery name="qD" cachedwithin="#CreateTime(1,0,0)#">
	SELECT d.DepartmentId, d.Name Department
    FROM pm_task pm
    INNER JOIN core_department d ON d.DepartmentId = pm.DepartmentId
    <cfif !(request.IsHost or request.IsAdmin)>
    	WHERE pm.DepartmentId = #request.userinfo.departmentid#
    </cfif>
    GROUP BY pm.DepartmentId
</cfquery>
<cfloop query="qD">
<!--- location --->
<cfquery name="qPL" cachedwithin="#CreateTime(1,0,0)#">
	SELECT pm.AssetLocationId
    FROM pm_task pm
    WHERE pm.DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qD.DepartmentId#"/>
    GROUP BY pm.AssetLocationId
</cfquery>
<cfset al = lst.ListDistinct(ValueList(qPL.AssetLocationId))/>
<cfquery name="qL" cachedwithin="#CreateTime(1,0,0)#">
	SELECT
    	l.LocationId, l.Name Location
    FROM asset_location al
    INNER JOIN location l ON l.LocationId = al.LocationId
    WHERE AssetLocationId IN (#al#)
    GROUP BY LocationId
</cfquery>
<cfloop query="qL">
<tr>
  <td height="19" align="center" valign="middle" style="font-size:10px;">#qD.Department# Department (#qL.Location#)</td>
</tr>
<!--- check if assetlocationid is in this location--->
<cfquery name="qP" cachedwithin="#CreateTime(1,0,0)#">
	#application.com.PMTask.PM_TASK_SQL#
    WHERE pm.DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qD.DepartmentId#"/>
</cfquery>

<tr>
  <td>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl">
  <tr class="hd">
    <td class="left">&nbsp;</td>
    <td>Task##</td>
    <td>Asset</td>
    <td>Task</td>
    <td>Details</td>
    <td>Frequency</td>
    <td nowrap="nowrap" width="1px">PM date</td>
  </tr>
  <cfset c=0/>
<cfloop query="qP">
    <cfquery name="qPL">
        SELECT * FROM asset_location
        WHERE LocationId = #qL.LocationId#
        	AND AssetLocationId IN (#qP.AssetLocationId#)
    </cfquery>
	<cfif qPL.recordcount>
    <cfset c++/>
  <tr>
    <td class="left">#c#</td>
    <td>#qP.PMTaskId#</td>
    <td><cfset qA = application.com.Asset.GetAssetByAssetLocatonIds(qP.AssetLocationId)/><cfset ast = valueList(qA.Asset,'`')/>
    #replace(ast,'`','<br/>','all')#
    </td>
    <td>#qP.Description#</td>
    <td>#replace(qP.TaskDetails,chr(10),'<br/>','all')#</td>
    <td><cfif qP.Frequency eq "">#qP.Milestone# #qP.ReadingType#<cfelse>#qP.Frequency#</cfif>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
	</cfif></cfloop>
</table>
  </td>
</tr>

<tr>
  <td>&nbsp;</td>
</tr>
<cfdocumentitem type="pagebreak"/>
</cfloop>
<cfdocumentitem type="pagebreak"/>
</cfloop>
<cfdocumentitem type="footer">
<tr><td ><table width="100%" border="0" style="font:7px Tahoma; border-top:1px solid ##ECF4CF; padding-left:15px;">
  <tr>
  <td nowrap="nowrap">
  </td>
    <td align="right">Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#</td>
</tr></table></td></tr>
</cfdocumentitem>
</table>
</body>
</html>
</cfdocument>

</cfoutput>
