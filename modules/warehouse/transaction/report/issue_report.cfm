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
	font-size: 9px;}
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
	<cfset request.letterhead.title="MATERIALS ISSUED TO OPERATIONAL UNIT"/>
	<cfset request.letterhead.Id=""/>
	<cfset request.letterhead.date = "Period: #dateformat(form.startdate,'dd/mmm/yyyy')# - #dateformat(form.enddate,'dd/mmm/yyyy')#"/>
	<cfinclude template="../../../../include/letter_head.cfm"/>
</cfdocumentitem>
<cfset gtt1 = gtt2 = 0/>
<cfquery name="qSI">
	#application.com.Transaction.MI_ITEM_SQL#
	WHERE (DateIssued >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.StartDate#"/>
		AND DateIssued <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.EndDate#"/>)
	ORDER BY DateIssued ASC
</cfquery>

<cfquery name="qGL" dbtype="query">
	SELECT Department FROM qSI GROUP BY Department
</cfquery>

<tr>
  <td>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl">

<cfloop query="qGL">
	<cfquery name="qI" dbtype="query">
		SELECT * FROM qSI 
		WHERE Department = '#qGL.Department#'
	</cfquery>
<tr>
	<td class="sub_head" colspan="8">#qGL.Department#</td>
</tr>
<tr class="hd">
	<td width="1%" class="left">&nbsp;</td>
	<td width="1%" nowrap>Issue ##</td>
	<td width="1%" nowrap>Issued date</td>
	<td>Item Description</td>
	<td>WO ##</td> 
	<td width="1%" style="text-align:right;">Qty</td>
	<td width="1%" style="text-align:right;" nowrap>U. Cost</td>
	<td width="1%" style="text-align:right;" nowrap>Total</td>
</tr>
	<cfset tt = tt2 = 0/>
	<cfloop query="qI">
		<tr>
		<td class="left">#qI.currentrow#</td>
		<td nowrap>#qI.IssueId#</td>		
		<td nowrap>#DateFormat(qI.DateIssued,"dd/mmm/yy")#</td>
		<td nowrap>#qI.Item#</td>
		<td>#qI.WorkOrderId#&nbsp;</td>
		<cfset qtu  = qI.Quantity * qI.UnitPrice/>
		<cfset cc = "<s>N</s>"/>
		<cfif qI.Currency eq "NGN">
			<cfset tt = qtu + tt/>
			<cfset gtt1 = tt + gtt1/>
		<cfelse>
			<cfset cc = "$"/>
			<cfset tt2 = qtu + tt2/>
			<cfset gtt2 = tt2 + gtt2/>
		</cfif>
		<td align="right">#qI.Quantity#</td>
		<td align="right" nowrap>#NumberFormat(qI.UnitPrice,'9,999.99')#</td> 
		<td align="right" nowrap>#cc# #NumberFormat(qtu,'9,999.99')#</td>
		</tr>
	</cfloop>
 
	<tr>
		<td class="no-bottom no-left" colspan="4">&nbsp;</td>
		<td align="right" colspan="1">Total:</td> 
		<td align="right" colspan="3">$ #NumberFormat(tt2,'9,999.99')#&nbsp;&nbsp;&nbsp;&nbsp;<s>N</s> #NumberFormat(tt,'9,999.99')#</td>
	</tr>  
<tr>
	<td class="no-bottom no-right" colspan="8">&nbsp;</td>
</tr>
</cfloop>
<tr>
	<td class="no-bottom no-right" colspan="8">&nbsp;</td>
</tr>
<tr>
		<td align="right class="no-bottom no-left" colspan="3"><b>Grand Total</b></td>
		<td align="right" colspan="2"><b>$ #NumberFormat(gtt2,'9,999.99')#</b></td> 
		<td align="right" colspan="3"><b></b><s>N</s> #NumberFormat(gtt1,'9,999.99')#</b></td>
</tr>
</table>
  </td>
</tr>

<tr>
  <td>&nbsp;</td>
</tr>



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