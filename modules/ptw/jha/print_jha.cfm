<cfoutput> 
<cfset qJ = application.com.Permit.GetJHA(url.id)/>
<cfdocument pagetype="a4" format="pdf" margintop="0" marginbottom="0" marginleft="0" marginright="0" orientation="landscape">
<html>
<head>
<cfset bg = "##d7f6d4"/>
<cfset brd_c = "##b8f0b4"/>
<cfset brd_c2 = "##7ce272"/>
<style type="text/css">	
	html,body{padding:0; margin:0;font: 10px Tahoma;}
	.ths{font-size:7px;}
	.ths th, .ths td{padding:3px; font-weight:normal;}
	.ths th{text-align:left; background-color:#bg#;}
	.ths td{font-size:7px; padding:5px; border-bottom:1px solid #bg#; vertical-align:top;}
	.head_section td{font-size: 11px;padding:5px;}
	.head_section td.left{background-color:#bg#;border-left:#brd_c# 1px solid;}
	.head_section td.left,.head_section td.right{border-top:#brd_c# 1px solid;border-right:#brd_c# 1px solid;}
	.head_section td.bottom{border-bottom:#brd_c# 1px solid;}
	.sub_head{font-size:11px; background-color:#bg#;border-top:#brd_c# 1px solid; padding:5px;}
	.content{padding:5px;}
	.underline{border-bottom:solid 1px ##333;
	padding: 0px; font-style:italic;}
	.left-pad5{}
	.t td{
	padding: 10px 5px 0px;
}
	.c-space{padding: 0px 5px;}
	.boxb{font-size:11px;line-height:16px;
	border: solid 1px ##333;font-style:italic;
	padding: 8px 9px 22px; margin-bottom:5px;
}
.schar{font:"Courier New", Courier, monospace;}
.mk{
	color: ##F30;
	font-weight: bold;
}
.sig{ 
	background:url(../../../doc/photo/core_user/1/8.png);
	<!---background-size:80px 60px;--->
	background-repeat:no-repeat;
}
</style>
</head>
<body>
<table width="100%">
<cfdocumentitem type = "header">
<cfset request.letterhead.title="JOB HAZARD ANALYSIS"/>
<cfset request.letterhead.Id="JHA ## #url.id#"/>
<cfset request.letterhead.logosize=70/>
<cfset request.letterhead.titlesize=9/> 
<cfset request.letterhead.date="Date: #Dateformat(qJ.Date,'dd/mm/yyyy')#"/>
<cfinclude template="../../../include/letter_head.cfm"/>
</cfdocumentitem> 
<tr>
  <td><table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:8px;">
    <tr>
      <td colspan="2">Work Description: &nbsp;&nbsp;<em>#qJ.WorkDescription# on #qJ.Asset#</em></td>
      </tr>
    <tr>
      <td colspan="2" height="3"></td>
      </tr>
    <tr>
      <td width="90%">Equipment/Tools to be used:&nbsp;&nbsp; <em>#qj.EquipmentToUse#</em></td>
      <td width="10%" nowrap>WorkOrder ##: <strong>#qJ.WorkOrderId#</strong>&nbsp;&nbsp;&nbsp;&nbsp;, Permit ##: <strong>#qJ.PermitId#</strong>&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2">&nbsp;</td>
      </tr>
  </table></td>
</tr>
<tr>
  <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="ths">
    <tr>
      <th>&nbsp;</th>
      <th nowrap="nowrap">Job Sequence</th>
      <th>Hazard</th>
      <th align="center">Target</th>
      <th align="center">Risk</th>
      <th>Consequences</th> 
      <th>Control Measure</th>
      <!---th>Responsible Party</th--->      
    </tr>
    <cfset qJL = application.com.Permit.GetJHAList(url.id)/>
    <cfloop query="qJL">
    <tr>
      <td valign="top">#qJL.Currentrow#.</td>
      <td valign="top">#qJL.JobSequence#</td>
      <td valign="top">#qJL.Hazard#</td>
      <td align="left" valign="top" nowrap="nowrap">#ucase(qJL.Target)#</td>
      <td align="left" valign="top" nowrap="nowrap">#ucase(qJL.Risk)#</td>
      <td valign="top">#qJL.Consequences#</td>
      <td valign="top">#qJL.ControlMeasure#</td>
      <!---td valign="top">#qJL.ResponsibleParty#&nbsp;</td--->      
    </tr>
    </cfloop>
  </table></td>
</tr>
<cfdocumentitem type="footer">
<cfquery name="qS">
	SELECT * FROM signature
    WHERE UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qJ.PreparedByUserId#"/> 
</cfquery>
<cfquery name="qP">
	SELECT * FROM `file`
    WHERE `Table` = "core_user"
    	AND `Type` = "P"
    	AND `PK` = <cfqueryparam cfsqltype="cf_sql_integer" value="#qJ.PreparedByUserId#"/> 
</cfquery>
<tr><td >
<!---<table width="100%" border="0" style="font:9px Tahoma;">
  <tr>
    <td width="50%" align="center"><table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr class="nopadding">
        <td align="right">&nbsp;</td>
        <td rowspan="2" valign="top">&nbsp;<img src="../../../doc/photo/core_user/1/#qP.File#" width="#qS.width#" height="#qS.height#" style="position:relative; right:0px;"></td> 
      </tr>
      <tr>
        <td align="right">Sign / Date: </td>
        </tr>
      <tr>
        <td align="right">&nbsp;</td>
        <td><sup style="font-size:7px;">Analysis By:  #qJ.PreparedBy#</sup></td>
      </tr>
    </table></td>
    <td width="50%" align="center"><table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr class="nopadding">
        <td align="right"><br/>
          <br/>
          <br/></td>
        <td valign="top">&nbsp;</td>
      </tr>
      <tr>
        <td align="right">Sign / Date: </td>
        <td>........................................................</td>
      </tr>
      <tr>
        <td align="right">&nbsp;</td>
        <td><sup style="font-size:7px;">HSE Supervisor: </sup></td>
      </tr>
    </table></td>
  </tr>
</table>--->    

  <table width="100%" border="0" style="font:7px Tahoma; border-top:1px solid ##ECF4CF; padding-left:15px;">
<tr>
  <td width="75%" nowrap="nowrap">
<div style="float:left">
	Target: P = Personnel, E = Environment, A = Asset, R = Reputation               	
</div>    
<div style="float:right;">
Risk: L = Low, M = Medium, H = High
</div> 
  </td>
    <td width="25%" align="right" nowrap="nowrap">Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#</td>
</tr></table></td></tr>
</cfdocumentitem>
</table>
</body>
</html>
</cfdocument>

</cfoutput>