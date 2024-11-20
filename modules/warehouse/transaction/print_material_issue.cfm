<cfoutput> 
<cfset qMI = application.com.Transaction.GetMI(url.id)/>
<cfdocument pagetype="a4" format="pdf" margintop="0.25" marginbottom="0" marginleft="0.4" marginright="0.4">
<html>
<head>
<cfset bg = "##f7ddf0"/>
<cfset brd_c = "##f0bde2"/>
<cfset brd_c2 = "##e17dc6"/>
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
	.tbl td{
	padding: 3px 5px;
border-top:#brd_c# 1px solid;border-right:#brd_c# 1px solid;}
	.tbl td.left{border-left:#brd_c# 1px solid;}
	.tbl tr.bottom td{border-bottom:#brd_c# 1px solid;}
	.tbl td.no-right{border-right:none;}
	.tbl td.cbg{background-color:#bg#;}
	.tbl td.no-bottom{border-bottom:none !important;}
	.a-right{text-align:right !important;}
	.center{text-align:center !important;}
</style>
</head>
<body>
<table width="100%">
<cfdocumentitem type = "header">
<cfset request.letterhead.title="MATERIAL ISSUE"/>
<cfset request.letterhead.Id="M.I. ## #url.id#"/>
<!---<cfset request.letterhead.date="Date issued: #dateformat(qMI.DateIssued,'dd-mmm-yyyy')#"/>--->
<cfinclude template="../../../../include/letter_head.cfm"/>
</cfdocumentitem> 
<tr>
  <td><table width="100%" border="0">
    <tr>
      <td valign="top" width="65%" align="right"><table width="50%" border="0" cellpadding="0" cellspacing="0" class="head_section">
        <tr>
          <td width="21%" valign="top" class="left bottom">Department</td>
          <td width="79%" valign="top" nowrap="nowrap" class="right bottom">#qMI.Department#</td>
        </tr>
        </table></td>
      <td valign="top" width="35%" align="center"><table width="90%" border="0" cellpadding="0" cellspacing="0" class="head_section">
        <tr>
          <td width="40%" valign="top" class="left">Date issued</td>
          <td width="60%" valign="top" class="right">#Dateformat(qMI.DateIssued,'dd-mmm-yyyy')#</td>
        </tr>
        <tr>
          <td valign="top" nowrap="nowrap" class="left bottom">Worder Order ##</td>
          <td valign="top" class="right bottom">#qMI.WorkOrderId#&nbsp;</td>
        </tr>
        </table></td>
      </tr>
  </table><BR/><BR/></td>
</tr>
<tr>
  <td>
    <cfset qMII = application.com.Transaction.GetMIItems(url.id)/>
    <div class="sub_head">MATERIALS ISSUED</div>
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tbl">
      <tr>
        <th class="left" width="1">S/N</th>
        <th width="826">Item Description</th>
        <th colspan="2" class="center">Quantity</th>
        <th width="53" nowrap="nowrap" class="a-right">Unit Price</th>
        <th width="172" class="a-right">Subtotal</th>
        </tr>
      <cfset ts=0/>
      <cfloop query="qMII">
        <tr <cfif qMII.Currentrow eq qMII.Recordcount> class="bottom" </cfif>>
          <td valign="top" class="left">#qMII.Currentrow#</td>
          <td valign="top">#qMII.Item#</td>
          <td width="88" align="right" valign="top" class="no-right">#qMII.Quantity#</td>
          <td width="61" valign="top">#qMII.UM#</td>
          <td align="right" valign="top">#Numberformat(val(qMII.UnitPrice),'9,999.99')#</td>
          <td align="right" valign="top" nowrap="nowrap" class="cbg">
          <cfset ctv = qMII.Quantity*val(qMII.UnitPrice)/>
          <cfset ts=ts+ctv/>
          #NumberFormat(ctv,'9,999.99')#</td>
          </tr>
        </cfloop>
      <tr  class="bottom">
        <td colspan="5" valign="top" class="no-bottom">&nbsp;</td> 
        <td align="right" class="cbg" valign="top">#Numberformat(ts,'9,999.99')#</td>
        </tr>
      
      </table></td>
</tr>
<tr>
  <td>&nbsp;</td>
</tr>
<tr>
  <td>&nbsp;</td>
</tr>
<tr>
  <td>&nbsp;</td>
</tr>
<cfdocumentitem type="footer">
<tr><td ><table width="100%" border="0" style="font:9px Tahoma;">
  <tr> 
    <td width="50%" align="center" style="padding-bottom:15px;"><table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr class="nopadding">
        <td width="18%" align="right"><br/>
          <br/>
          <br/></td>
          <cfset fl = getSignature(qMI.IssuedToUserId)/>
        <td width="82%" rowspan="2" valign="bottom">&nbsp;&nbsp;&nbsp;<img src="../../../doc/photo/core_user/#qMI.IssuedToUserId#/#fl#" height="30"></td>
      </tr>
      <tr>
        <td align="right">Sign:</td>
        </tr>
      <tr>
        <td align="right">&nbsp;</td>
        <td><sup style="font-size:7px;">Received by: #qMI.IssuedTo#</sup></td>
      </tr>
    </table></td>
    <td width="50%" align="center" style="padding-bottom:15px;"><table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr class="nopadding">
        <td width="51%" align="right"><br/>
          <br/>
          <br/></td>
          <cfset fl = getSignature(qMI.IssuedByUserId)/>
        <td width="49%" rowspan="2" valign="bottom">&nbsp;&nbsp;&nbsp;<img src="../../../doc/photo/core_user/#qMI.IssuedByUserId#/#fl#" height="30"></td>
      </tr>
      <tr>
        <td align="right">Sign:</td>
        </tr>
      <tr>
        <td align="right">&nbsp;</td>
        <td><sup style="font-size:7px;">Issued by: #qMI.IssuedBy#</sup></td>
      </tr>
    </table></td>
  </tr>
</table>
  <table width="100%" border="0" style="font:9px Tahoma; border-top:1px solid ##ECF4CF; padding-left:15px;">
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