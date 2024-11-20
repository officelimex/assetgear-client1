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
	<cfset request.letterhead.title="MATERIAL INVENTORY LISTS"/>
	<cfset request.letterhead.Id=""/>
	<cfset request.letterhead.date = "#dateformat(now(),'dd/mmm/yyyy')#"/>
	<cfinclude template="../../../../include/letter_head.cfm"/>
</cfdocumentitem>
<cfquery name="qI">
    SELECT * FROM whs_item i
    WHERE
        i.Obsolete = "No" AND i.Status = "Online"
    ORDER BY i.Description
</cfquery>

<tr>
  <td>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl">

    <tr class="hd">
        <td width="1%" class="left">&nbsp;</td>
        <td width="1%" nowrap>Item ##</td>
        <td>Item Description</td>
        <td>VPN</td>
        <td width="1%" style="text-align:right;" nowrap>Cost (NGN)</td>
        <td width="1%" style="text-align:right;" nowrap>Cost (USD)</td>
        <td width="1%" style="text-align:right;" nowrap>Qty on Hand</td>
        <td width="1%" style="text-align:right;" nowrap>Order Level</td>
    </tr>
    <cfif totalngn = 0/>
    <cfif totalusd = 0/>
    <cfloop query="qI">
        <tr>
            <td class="left">#qI.currentrow#</td>
            <td>#qI.ItemId#</td>
            <td >#qI.Code#: #qI.Description#</td>
            <td >#qI.VPN#&nbsp;</td>
            <td align="right"><cfif qI.Currency eq "NGN">#numberformat(qI.UnitPrice,"9,999.99")#<cfelse>0</cfif></td>
            <td align="right"><cfif qI.Currency eq "USD">#numberformat(qI.UnitPrice,"9,999.99")#<cfelse>0</cfif></td>
            <td align="right">#qI.QOH#</td>
            <cfif qI.Currency eq "NGN">
            	<cfset totalngn = totalngn + (qI.UnitPrice * qI.QOH)/>
            <cfelse>
            	<cfset totalusd = totalusd + (qI.UnitPrice * qI.QOH)/>
            </cfif>
            <td align="right">#qI.MinimumInStore#</td>
        </tr>
    </cfloop>
    <tr>
    	<td colspan="4" align="right"><strong>Total in NGN:</strong> #numberformat(totalngn,"9,999.99")#</td>
        <td colspan="4" align="right"><strong>Total in USD:</strong> #numberformat(totalusd,"9,999.99")#</td>
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
