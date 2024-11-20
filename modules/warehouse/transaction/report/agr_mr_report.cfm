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
	<cfset request.letterhead.title="OPEN AGED MATERIAL REQUEST"/>
	<cfset request.letterhead.Id=""/>
	<cfset request.letterhead.date = "#dateformat(now(),'dd/mmm/yyyy')#"/>
	<cfinclude template="../../../../include/letter_head.cfm"/>
</cfdocumentitem>
<cfquery name="qI">
    #application.com.Transaction.MR_SQL#
    WHERE mr.Status <> "Close"
    ORDER BY mr.MRId DESC
</cfquery>

<tr>
  <td>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl">

    <tr class="hd">
        <td width="1%" class="left">&nbsp;</td>
        <td width="1%" nowrap>MR ##</td>
        <td>Description</td>
        <td nowrap>Status</td>
        <td nowrap>Date Issued</td>
        <td width="1%" style="text-align:right;" nowrap>Value</td>
    </tr>
    <cfloop query="qI">
        <tr>
            <td class="left">#qI.currentrow#</td>
            <td>#qI.MRId#</td>
            <td>#qI.Note#</td>
            <td>#qI.Status#</td>
            <td>#dateformat(qI.DateIssued,'dd-mm-yyyy')#</td>
            <td align="right" nowrap><cfif qI.Currency eq "NGN">N<cfelse>$</cfif> #Numberformat(qI.TotalValue,'9,999.99')#</td> 
        </tr>
    </cfloop> 

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