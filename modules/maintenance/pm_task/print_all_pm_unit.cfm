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

<cfquery name="qPM" cachedwithin="#CreateTime(1,0,0)#">
  #application.com.PMTask.PM_TASK_SQL# 
  WHERE pm.IsActive = "Yes"
  ORDER BY IsActive DESC, Asset, Location
</cfquery>

<cfquery name="qU" dbtype="query">
  SELECT UnitId, Unit
  FROM qPM
  GROUP BY UnitId, Unit
</cfquery>

<cfloop query="qU">

<tr>
  <td height="19" align="center" valign="middle" style="font-size:14px;">#qU.Unit#</td>
</tr>

<cfquery name="qP" dbtype="query">
	SELECT * FROM qPM
  WHERE UnitId = #val(qU.UnitId)# 
</cfquery>

<tr>
  <td>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl">
  <thead>
  <tr class="hd">
    <th class="left">&nbsp;</th>
    <th>Task##</th>
    <th>Asset - Location</th>
    <th>Task</th>
    <th>Frequency</th>
    <th>Active</th>
  </tr>
</thead>
<tbody>
<cfloop query="qP">
  <tr>
    <td class="left">#qP.currentrow#</td>
    <td>#qP.PMTaskId#</td>
    <td>#qP.Asset# @ #qP.Location# <cfif qP.Status != "Online"><span style="color:red">- OFFLINE</span></cfif></td>
    <td>#qP.Description#</td>
    <td><cfif qP.Frequency eq "">#qP.Milestone# #qP.ReadingType#<cfelse>#qP.Frequency#</cfif>&nbsp;</td>
    <td>#qP.IsActive#</td>
  </tr>
</cfloop>
</tbody>
</table>
  </td>
</tr>

<tr>
  <td>&nbsp;</td>
</tr>

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
