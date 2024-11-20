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
  <!---<cfset y = year(now())/>
  <cfif url.m eq 13>
    <cfset url.m = 1/>
    <cfset y = y+1/>
  </cfif>
  <cfset sd = "#y#/#url.m#/1"/>
  <cfset cm_ = DaysInMonth(sd)/>
  <cfset ed = "#y#/#url.m#/#cm_#"/>
  <cfif IsDefined("url.w")>
    <cfset sd = "#y#/1/1"/>
    <cfset sd = DateAdd('ww',url.w,sd)/>
    <cfset sd = DateAdd('d',-7,sd)/>
    <cfset ed = DateAdd('d',7,sd)/>
  </cfif>--->
  <!---'#sd# - #ed#--->
  <cfdocumentitem type = "header">
  <cfset request.letterhead.title="Maintenance Task"/>
  <cfset request.letterhead.Id=""/>
  <cfset request.letterhead.date = "Period: From '#dateformat(form.StartDate,'mmmm yyyy')#' To '#dateformat(form.EndDate,'mmmm yyyy')#'"/>

  <cfinclude template="../../../include/letter_head.cfm"/>
  </cfdocumentitem>
  <cfquery name="qD" cachedwithin="#CreateTime(1,0,0)#">
        SELECT
            d.*, CONCAT(d.Name,"/",u.Name) as DU, d.Name Department, u.UnitId, u.Name Unit
        FROM core_department d
        LEFT JOIN core_unit u ON u.DepartmentId = d.DepartmentId
        <cfif isdefined("form.DepartmentIds")>
			<cfif form.DepartmentIds neq "">
                WHERE d.DepartmentId IN (#form.DepartmentIds#)
            </cfif>
        </cfif>
        GROUP BY DU
  </cfquery>

  <cfloop query="qD">
    <cfquery name="qW">
        #application.com.WorkOrder.WORK_ORDER_SQL#
        WHERE wo.DepartmentId = #qD.Departmentid#
        <!--- include unit --->
        <cfif (qD.UnitId neq '')>
        	AND wo.UnitId = #val(qD.UnitId)#
        </cfif>
        <cfif form.WorkClassId neq "">
        	AND wo.WorkClassId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.WorkClassId#"/>
        </cfif>
        <cfif form.JobType neq "">
        	<cfif form.JobType eq "Unplanned"> AND wo.PMTaskId = 0</cfif>
            <cfif form.JobType eq "Planned"> AND wo.PMTaskId > 0</cfif>
        </cfif>
        <cfif form.Status neq "">
        	AND wo.Status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Status#"/>
        </cfif>
		AND wo.DateOpened BETWEEN '#dateformat(form.StartDate,"yyyy/mm/dd")#' AND '#dateformat(form.EndDate,"yyyy/mm/dd")#'
        ORDER BY wo.DateOpened
    </cfquery>

    <tr>
      <td height="19" align="center" valign="middle" style="font-size:10px;">#qD.Department# Department
        <cfif qD.Unit neq "">
          (#qD.Unit#)
        </cfif>
        <cfif form.WorkClassId neq "">
        	<cfquery name="qM">
            	SELECT * FROM job_class WHERE JobClassId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.WorkClassId#"/>
            </cfquery>
            For #qM.Class#
        </cfif>

      </td>
    </tr>
    <tr>
      <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl">
        <tr class="hd">
          <td class="left">&nbsp;</td>
          <td nowrap>WO ##</td>
          <td nowrap>PM ##</td>

          <td>Asset</td>
          <td>Locations</td>
          <td>Task</td>
          <td nowrap="nowrap">Open date</td>
          <td nowrap="nowrap">Close date</td>
          <td nowrap="nowrap" width="1px">Status</td>
        </tr>
        <cfloop query="qW">
          <tr>
            <td class="left">#qW.currentrow#</td>
            <td nowrap>#qW.WorkOrderId#</td>
            <td nowrap>#qW.PMTaskId# &nbsp</td>

            <td>#qW.Asset#</td>
            <td><cfset qA = application.com.Asset.GetAssetByAssetLocatonIds(qW.AssetLocationIds)/>
              <!---<cfset ast = valueList(qA.Location,'`')/>
        #replace(ast,'`','<br/>','all')#--->
              <cfif qA.ParentLocation neq "">
                #qA.ParentLocation#/
              </cfif>
              #qA.Location# </td>
            <td>#qW.Description#</td>
            <td nowrap>#dateformat(qW.DateOpened,'dd-mmm-yy')#</td>
            <td nowrap>#dateformat(qW.DateClosed,'dd-mmm-yy')#&nbsp;</td>
            <td>#qW.Status#</td>
          </tr>
        </cfloop>
      </table></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
    <cfdocumentitem type="pagebreak"/>
  </cfloop>
  <cfdocumentitem type="footer">
  <tr>
    <td ><table width="100%" border="0" style="font:7px Tahoma; border-top:1px solid ##ECF4CF; padding-left:15px;">
      <tr>
        <td nowrap="nowrap" align="left"></td>
        <td align="right">Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#</td>
      </tr>
    </table></td>
  </tr>
  </cfdocumentitem>
</table>
</body>
</html>
</cfdocument>

</cfoutput>
