<cfoutput>
<cfset qMR = application.com.Transaction.GetMaterialReceived(url.id)/>
<cfdocument pagetype="a4" format="pdf" margintop="0.25" marginbottom="0" marginleft="0.4" marginright="0.4" >
<html>
<head>
<cfset bg = "##fce8e8"/>
<cfset brd_c = "##f8c5c5"/>
<cfset brd_c2 = "##ef7f7f"/>
<style type="text/css">
	html,body{padding:0; margin:0;font: 12px Tahoma;}
	.head_section td{font-size: 11px;padding:5px;}
	.head_section td.left{background-color:#bg#;border-left:#brd_c# 1px solid;}
	.head_section td.left,.head_section td.right{border-top:#brd_c# 1px solid;border-right:#brd_c# 1px solid;}
	.head_section td.bottom{border-bottom:#brd_c# 1px solid;}
	.sub_head{font-size:11px; background-color:#bg#;border-top:#brd_c# 1px solid; padding:5px;}
	.content{font-size:11px;padding:5px;}
	.tbl{
	font-size: 11px;
}
	.tbl th{font-weight: normal;background-color:#bg#;border-top:#brd_c2# 2px solid;border-right:#brd_c# 1px solid; text-align:left; padding:4px;}
	.tbl th.left{border-left:#brd_c# 1px solid;}
	.tbl>tr>td{
	padding: 3px 5px;
border-top:#brd_c# 1px solid;border-right:#brd_c# 1px solid;}
	.tbl td.left{border-left:#brd_c# 1px solid;}
	.tbl tr.bottom td{border-bottom:#brd_c# 1px solid;}
	.tbl td.no-right{border-right:none;}
	.tbl td.cbg{background-color:#bg#;}
	.tbl td.no-bottom{border-bottom:none !important;}
	.a-right{text-align:right !important;}
	.nbg{background-color:white !important;}
	.center{text-align:center !important;}
	.um{
	font-size: 8px;
	color: ##666;
	padding: 6px 0px 0px 2px !important;
}
</style>
</head>
<body>
<table width="100%">
<cfdocumentitem type = "header">
<cfset request.letterhead.title="MATERIAL RECEIVED"/>
<cfset request.letterhead.Id="## #url.id#"/>
<cfset request.letterhead.date="Date: #dateformat(qMR.Date,'dd/mm/yyyy')#"/>
<cfinclude template="../../../../include/letter_head.cfm"/>
</cfdocumentitem>
<tr>
  <td><table width="100%" border="0">
    <tr>
      <td valign="top" width="61%" align="center">&nbsp;</td>
      <td valign="top" width="39%" align="center"><table width="90%" border="0" cellpadding="0" cellspacing="0" class="head_section">
        <tr>
          <td width="24%" valign="top" class="left">M.R. ##</td>
          <td width="76%" valign="top" class="right">#qMR.MRId#&nbsp;</td>
          </tr>
        <tr>
          <td valign="top" nowrap="nowrap" class="left">Reference</td>
          <td valign="top" class="right">#qMR.Reference#&nbsp;</td>
        </tr>
        <tr>
          <td valign="top" nowrap="nowrap" class="left bottom">Date Received</td>
          <td valign="top" class="right bottom"> #Dateformat(qMR.Date,'dd-mmm-yyyy')# </td>
        </tr>
        <!---<tr>
          <td colspan="2" align="center" valign="top" class="left bottom nbg"><cfif qMR.OrderType eq "i">International Requsition<cfelse>Local Requsition</cfif></td>
          </tr>--->
        </table></td>
      </tr>
  </table><BR/><BR/></td>
</tr>
<tr>
  <td>
    <cfset qMRI = application.com.Transaction.GetMaterialReceivedItems(url.id)/>
	<cfquery name="qT">
        SELECT
            sum(ri.Quantity * ri.UnitPrice) Price,ri.Currency
        FROM whs_material_received_item ri
        WHERE ri.MaterialReceivedId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#" />
        GROUP BY ri.Currency
    </cfquery>



    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tbl">
      <tr>
        <th class="left" width="1px">S/N</th>
        <th class="center">Item Description</th>
        <th colspan="2" class="center">Quantity</th>
        <th nowrap="nowrap" class="a-right">Unit Price</th>
        <th nowrap="nowrap" class="a-right">Waybill/Invoice ##</th>
        <th class="a-right">Subtotal</th>
        </tr>
        <cfset gs = 0/>
      <cfloop query="qMRI">
        <tr <cfif qMRI.Currentrow eq qMRI.Recordcount> class="bottom" </cfif>>
          <td valign="top" class="left">#qMRI.Currentrow#</td>
          <td valign="top">#qMRI.Item#</td>
          <td align="right" valign="top" class="no-right" style="padding-right:0px;">#qMRI.Quantity#</td>
          <td valign="top" class="um">#qMRI.UM#</td>
          <td align="right" valign="top" nowrap="nowrap"><!---<cfif qMRI.Currency eq "NGN">&##8358;<cfelse>$</cfif> --->#Numberformat(qMRI.UnitPrice,'9,999.99')#</td>
          <td align="right" valign="top">#qMRI.Reference#</td>
          <td align="right" valign="top" nowrap="nowrap" class="cbg">
          <cfset qu = qMRI.Quantity*qMRI.UnitPrice/>
          <!---<cfif qMRI.Currency eq "NGN">&##8358;<cfelse>$</cfif>--->
          <cfset gsign = getCurrency(qMRI.Currency)/>
          #gsign# #NumberFormat(qMRI.Quantity*qMRI.UnitPrice,'9,999.99')#</td>
          <cfset gs = gs + qu/>
          </tr>
        </cfloop>
      <tr  class="bottom">
        <td colspan="6" valign="top" class="no-bottom">&nbsp;</td>
        <td align="right" class="cbg" valign="top">
            <cfloop query="qT">
               <cfset csign = getCurrency(qT.Currency)/>
               <div align="left">Total in #qT.Currency#</div><b> #Numberformat(qT.Price,'9,999.99')#</b><br/><br/>
            </cfloop>
        	<!---#NumberFormat(gs,'9,999.99')#--->
        </td>
        </tr>

    </table></td>
</tr>
<tr>
  <td>

  </td>
</tr>
<tr>
  <td>&nbsp;</td>
</tr>
<tr>
  <td>&nbsp;</td>
</tr>
<cfdocumentitem type="footer">
<tr><td >
<table width="100%" border="0">
  <tr>
    <td>&nbsp;</td><td width="50%" align="center" style="font:9px Tahoma;padding-bottom:25px;">&nbsp;</td>
    <td width="50%" align="center" style="font:9px Tahoma;padding-bottom:25px;">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr class="nopadding">
    <td width="52%" align="right"><br/><br/><br/></td>
    <td width="48%" valign="top">&nbsp;</td>
  </tr>
  <tr>
    <td align="right">Sign / Date:</td>
    <td>........................................................</td>
  </tr>
  <tr>
    <td align="right">&nbsp;</td>
    <td><sup style="font-size:7px;">Material/Logistics: </sup></td>
  </tr>
</table></td>
  </tr>
</table>

<table width="100%" border="0" style="font:9px Tahoma; border-top:1px solid gray; padding-left:15px;">
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

<cffunction name="getSignature" access="private" returntype="string" hint="Get user signatire">
	<cfargument name="uid" hint="user id" required="yes" type="string"/>

    <cfquery name="qS1" cachedwithin="#CreateTime(1,0,0)#">
        SELECT * FROM `file`
        WHERE `Table` = 'core_user'
            AND `PK` = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.uid)#"/>
        LIMIT 0,1
    </cfquery>

    <cfreturn qS1.File/>
</cffunction>
<cffunction name="getCurrency" returntype="string" access="private">
	<cfargument name="cur" required="yes" type="string"/>
    <cfif cur eq "USD">
        <cfset currencysign = "$"/>
    <cfelse>
        <cfset currencysign = "N"/>
    </cfif>

    <cfreturn currencysign/>
</cffunction>
</cfoutput>
