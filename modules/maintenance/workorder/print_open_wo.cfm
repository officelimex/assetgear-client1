<cfoutput>
<cfparam name="url.userid" default="0"/>
<cfparam name="url.departmentid" default="0"/>
<cfparam name="url.unitid" default="0"/>
<cfparam name="url.status" default=""/>
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
    <cfquery name="qW" result="rt">
        SELECT wo.*, jc.Class JobClass, 
        d.Name Department, ut.Name Unit,  
        IF(wo.CreatedByUserId IS NULL,"System Generated",CONCAT(rb.Surname," ",rb.OtherNames)) RequestBy 
        FROM work_order wo
        INNER JOIN `core_department` d ON d.DepartmentId = wo.DepartmentId
        LEFT JOIN `core_unit` ut ON ut.UnitId = wo.UnitId
        INNER JOIN `job_class` jc ON jc.JobClassId = wo.WorkClassId
        LEFT JOIN `core_user` rb ON rb.UserId = wo.CreatedByUserId
        WHERE wo.WorkOrderId <> ""
		<!--- include unit --->
        <cfif url.unitid neq "0">
            AND wo.UnitId = #val(url.unitid)#
        </cfif>
		<cfif url.departmentid neq "0">
        	AND wo.DepartmentId = #val(url.departmentid)#
        </cfif>
		<cfif url.userid neq "0">
        	AND wo.CreatedByUserId = #val(url.userid)#
        </cfif>
		<cfif url.status neq "">
        	AND wo.Status NOT IN ("Close","Declined")
        </cfif>
        
        ORDER BY wo.DateOpened
    </cfquery>
    
    <cfif url.userid neq "0">
    	<cfquery name="qV">
        	SELECT CONCAT(Surname," ",OtherNames) AS Msg FROM core_user WHERE UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.userid#"/>
        </cfquery>
        <cfset msgvalue = "#qV.Msg#"/>
    <cfelseif url.departmentid neq "0">
    	<cfquery name="qV">
        	SELECT Name AS Msg FROM core_department WHERE DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.departmentid#"/>
        </cfquery>
        <cfset msgvalue = "#qV.Msg# Department"/>
    <cfelse>
    	<cfquery name="qV">
        	SELECT Name AS Msg FROM core_unit WHERE UnitId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.unitid#"/>
        </cfquery>
        <cfset msgvalue = "#qV.Msg#"/>
    </cfif>
    <cfset msgvalue = "#qV.Msg#"/>

<!---'#sd# - #ed#--->
<cfdocumentitem type = "header">
<cfset request.letterhead.title="OPEN WORKORDER"/>
<cfset request.letterhead.Id=""/>
<cfset request.letterhead.date = "For #msgvalue#"/>
<cfinclude template="../../../include/letter_head.cfm"/>
</cfdocumentitem>


        
        <cfif rt.RecordCount gt 0>
            <tr>
              <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl">
              <tr class="hd">
                <td class="left">&nbsp;</td>
                <td nowrap>WO ##</td>
                <td>Task</td>
                <td nowrap="nowrap">Open Date</td>
                <td nowrap="nowrap">Created By</td>
                <td nowrap="nowrap" width="1px">Status&nbsp;</td>
              </tr>
                <cfloop query="qW">
                  <tr>
                    <td class="left">#qW.currentrow#</td>
                    <td nowrap><a href="print_workorder.cfm?id=#qW.WorkOrderId#" target="_blank">#qW.WorkOrderId#</a></td>
                    <td>#qW.Description#</td>
                    <td nowrap>#dateformat(qW.DateOpened,'dd-mmm-yy')#&nbsp;</td>
                    <td>#RequestBy#&nbsp;</td>
                    <td nowrap>#Status#&nbsp;</td>
                  </tr>
            
            
                </cfloop>
            </table>
              </td>
            </tr>
            
            <tr>
              <td>&nbsp;</td>
            </tr>
            <cfdocumentitem type="pagebreak"/>
        
        </cfif>
    

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

</cfoutput>
