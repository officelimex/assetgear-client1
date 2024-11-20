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
	<cfset request.letterhead.title="MATERIAL RECEIVED"/>
	<cfset request.letterhead.Id=""/>
	<cfset request.letterhead.date = "Period: #dateformat(form.startdate,'dd/mmm/yyyy')# - #dateformat(form.enddate,'dd/mmm/yyyy')#"/>
	<cfinclude template="../../../../include/letter_head.cfm"/>
</cfdocumentitem>

<cfquery name="qI">
	#application.com.Transaction.MATERIAL_RECEIVED_ITEM_SQL#
	WHERE (r.Date >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.StartDate#"/>
		AND r.Date <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.EndDate#"/>)
	ORDER BY r.Date ASC, ri.MaterialReceivedId
</cfquery>

<tr>
  <td>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl">

<tr class="hd">
	<td width="1%" class="left">&nbsp;</td>
	<td width="1%" nowrap>Receipt ##</td>
	<td width="1%" nowrap>Date</td>
	<td>Item Description</td>
	<td>MR ##</td>
	<td>Reference</td> 
	<td width="1%" style="text-align:right;">Qty</td>
	<td width="1%" style="text-align:right;" nowrap>U. Cost</td>
	<td width="1%" style="text-align:right;" nowrap>Total</td>
</tr>
	<cfset tt = tt2 = 0/>
	<cfloop query="qI">
		<tr>
		<td class="left">#qI.currentrow#</td>
		<td nowrap>#qI.MaterialReceivedId#</td>		
		<td nowrap>#DateFormat(qI.Date,"dd/mmm/yy")#</td>
		<td nowrap>#qI.Item#</td>
		<td>#qI.MRId#&nbsp;</td>
		<td>#qI.Reference#&nbsp;</td>
		<cfset qtu  = qI.Quantity * qI.UnitPrice/>
		<cfset cc = "<s>N</s>"/>
		<cfif qI.Currency eq "NGN">
			<cfset tt = qtu + tt/>
		<cfelse>
			<cfset cc = "$"/>
			<cfset tt2 = qtu + tt2/>
		</cfif>
		<td align="right">#qI.Quantity#</td>
		<td align="right" nowrap>#NumberFormat(qI.UnitPrice,'9,999.99')#</td> 
		<td align="right" nowrap>#cc# #NumberFormat(qtu,'9,999.99')#</td>
		</tr>
	</cfloop>


<tr>
	<td class="no-bottom no-right" colspan="9">&nbsp;</td>
</tr>
<tr>
		<td align="right class="no-bottom no-left" colspan="5"><b>Grand Total</b></td>
		<td align="right" colspan="2"><b>$ #NumberFormat(tt2,'9,999.99')#</b></td> 
		<td align="right" colspan="2"><b></b><s>N</s> #NumberFormat(tt,'9,999.99')#</b></td>
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