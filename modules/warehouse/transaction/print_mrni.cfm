<cfoutput> 
<cfset qMR = application.com.Transaction.GetMR(url.id)/>
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
<cfset request.letterhead.title="MATERIAL REQUISITION"/>
<cfset request.letterhead.Id="M.R. ## #url.id#"/>
<cfset request.letterhead.date="Date: #dateformat(qMR.Date,'dd/mm/yyyy')#"/>
<cfinclude template="../../../include/letter_head.cfm"/>
</cfdocumentitem> 
<tr>
  <td><table width="100%" border="0">
    <tr>
      <td valign="top" width="70%" align="center"><table width="90%" border="0" cellspacing="0" cellpadding="0" style="font-size:11px;">
        <tr>
          <td width="30px" valign="top">TO:</td><td valign="top">#application.companyName#<br/>#application.companyAddress#</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2"><em>#qMR.Note#</em></td>
          </tr>
      </table></td>
      <td valign="top" width="30%" align="center"><table width="90%" border="0" cellpadding="0" cellspacing="0" class="head_section">
        <tr>
          <td width="24%" valign="top" class="left">Currency</td>
          <td width="76%" valign="top" class="right"><cfif qMR.Currency eq "NGN">Naira (NGN)<cfelse>Dollar (USD)</cfif></td>
          </tr>
        <tr>
          <td valign="top" nowrap="nowrap" class="left">Work Order ##</td>
          <td valign="top" class="right">#qMR.WorkOrderId#&nbsp;</td>
        </tr>
        <tr>
          <td valign="top" nowrap="nowrap" class="left">Department</td>
          <td valign="top" nowrap="nowrap" class="right">#qMR.Department#</td>
        </tr>
        <tr>
          <td valign="top" nowrap="nowrap" class="left">Date Required</td>
          <td valign="top" class="right"><cfif isdate(qMR.DateRequired)>#Dateformat(qMR.DateRequired,'dd-mmm-yyyy')#</cfif></td>
          </tr>
        <tr>
          <td colspan="2" align="center" valign="top" class="left bottom nbg"><cfif qMR.OrderType eq "i">International Requsition<cfelse>Local Requsition</cfif></td>
          </tr>
        </table></td>
      </tr>
  </table><BR/><BR/></td>
</tr>
<tr>
  <td> 
  
    <cfset qMRI = application.com.Transaction.GetMRNIItems(url.id)/>
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tbl">
      <tr>
        <th class="left" width="1">S/N</th>
        <th class="center">Item Description</th>
        <th class="center">Quantity</th>
        <th class="a-right">Unit Price</th>
        <th class="a-right">Subtotal</th>
        </tr>
        <cfset gs = 0/>
      <cfloop query="qMRI">
        <tr <cfif qMRI.Currentrow eq qMRI.Recordcount> class="bottom" </cfif>>
          <td valign="top" class="left">#qMRI.Currentrow#</td>
          <td valign="top">#qMRI.Item#</td>
          <td align="right" valign="top">#qMRI.Quantity#</td>
          <td align="right" valign="top">#Numberformat(qMRI.UnitPrice,'9,999.99')#</td>
          <td align="right" class="cbg" valign="top">
          <cfset qu = qMRI.Quantity*qMRI.UnitPrice/>
          #NumberFormat(qMRI.Quantity*qMRI.UnitPrice,'9,999.99')#</td>
          <cfset gs = gs + qu/>
          </tr>
        </cfloop>
      <tr  class="bottom">
        <td colspan="4" valign="top" class="no-bottom">&nbsp;</td> 
        <td align="right" class="cbg" valign="top">#numberformat(gs,'9,999.99')#</td>
        </tr>
      
    </table></td>
</tr>
<tr>
  <td>

<cfif gs neq 0>  
<div style="text-align:left; font-style:italic; padding-top:8px; font-size:11px;">AMOUNT IN WORDS: 
        <CFSET num = CreateObject("component","assetgear.com.adexfe.util.Finance.NumberToWords").init(NumberFormat(gs,'999.99'),'Naira','kobo')/>
        #ucase(num.Convert())# ONLY</div>
</cfif>
  
  
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
    <td>&nbsp;</td><td width="50%" align="center" style="font:9px Tahoma;padding-bottom:25px;">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr class="nopadding">
    <td width="22%" align="right"><br/><br/><br/></td>
    <td width="78%" rowspan="2" valign="bottom">
        <cfset fl = getSignature(qMR.CreatedByUserId)/>
        &nbsp;&nbsp;&nbsp;<img src="../../../doc/photo/core_user/#qMR.CreatedByUserId#/#fl#" height="30">
    </td>
  </tr>
  <tr>
    <td align="right" nowrap="nowrap">Sign / Date:</td>
    </tr>
  <tr>
    <td align="right">&nbsp;</td>
    <td><sup style="font-size:7px;">Material/Logistics Officer: </sup></td>
  </tr>
</table></td>    
    <td width="50%" align="center" style="font:9px Tahoma;padding-bottom:25px;">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr class="nopadding">
    <td width="55%" align="right"><br/><br/><br/></td>
    <td width="45%" valign="top">&nbsp;</td>
  </tr>
  <tr>
    <td align="right">Sign / Date:</td>
    <td>........................................................</td>
  </tr>
  <tr>
    <td align="right">&nbsp;</td>
    <td><sup style="font-size:7px;">Field Superintendent: </sup></td>
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

</cfoutput>