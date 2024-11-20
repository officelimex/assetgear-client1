<cfoutput>
<cfquery name="qMI">
	SELECT dr.*,CONCAT(cu.Surname, " ",cu.OtherNames) AS CreatedBy FROM drilling_return dr
    LEFT JOIN core_user cu ON cu.UserId = dr.CreatedById
    WHERE DReturnedId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>
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
	.underline{border-bottom:##666 1px dotted; font-style:italic;}
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
<cfset request.letterhead.title="PROJECT/DRILLING RETURN"/>
<cfset request.letterhead.Id=" ## #url.id#"/>
<!---<cfset request.letterhead.date="Date issued: #dateformat(qMI.DateIssued,'dd-mmm-yyyy')#"/>--->
<cfinclude template="../../../include/letter_head.cfm"/>
</cfdocumentitem>
<tr>
  <td><table width="100%" border="0">
    <tr>
      <td valign="top" width="35%" align="center"><table width="90%" border="0" cellpadding="0" cellspacing="0" class="head_section">
        <tr>
          <td width="40%" valign="top" class="left">Delivery Date</td>
          <td width="60%" valign="top" class="right">#Dateformat(qMI.ReturedDate,'dd-mmm-yyyy')#</td>
        </tr>
        <tr>
          <td valign="top" nowrap="nowrap" class="left bottom">Delivered By ##</td>
          <td valign="top" class="right bottom">#qMI.ReturedBy#&nbsp;</td>
        </tr>
        </table>
       </td>    
      <td valign="top" width="65%" align="right"><table width="80%" border="0" cellpadding="0" cellspacing="0" class="head_section">
        <tr>
          <td width="21%" valign="top" class="left bottom">Comment</td>
          <td width="79%" valign="top" class="right bottom">#qMI.Comment# &nbsp;</td>
        </tr>
        </table></td>

      </tr>
  </table><BR/><BR/></td>
</tr>
<tr>
  <td>
    <cfquery name="qMII">
        SELECT * FROM drilling_returned_item
        WHERE DReturnedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Id#"/>
    </cfquery>
    <div class="sub_head">ITEMS RETURNED</div>
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tbl">
      <tr>
        <th class="left" width="1">S/N</th>
        <th width="826">Item Description</th>
        <th class="center">Quantity</th>
        <th width="83" nowrap="nowrap" align="left" class="a-left">Status</th>
        </tr>
      <cfset ts=0/>
      <cfloop query="qMII">
        <tr <cfif qMII.Currentrow eq qMII.Recordcount> class="bottom" </cfif>>
          <td valign="top" class="left">#qMII.Currentrow#</td>
          <td valign="top"> #qMII.ItemDescription# </td>
          <td width="80" align="center" valign="top" >#qMII.Qty#</td>
          <td width="61" valign="top" >#qMII.Status#</td>
        </tr>
        </cfloop>
        <!---<tr class="bottom">
        	<td colspan="5" valign="top" class="no-bottom">&nbsp;</td>
        	<td  align="right" class="cbg" valign="top">
                <cfloop query="qT">
                   <cfset csign = getCurrency(qT.Currency)/>
				   <div align="left">Total in #qT.Currency#</div><b> #Numberformat(qT.UnitPrice,'9,999.99')#</b><br/><br/>
                </cfloop>
            </td>
        </tr>--->

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
          <cfset fl = getSignature(qMI.CreatedById)/>
        <td width="82%" rowspan="2" valign="bottom"><div class="underline">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div></td>
      </tr>
      <tr>
        <td align="right">Sign/Date:</td>
        </tr>
      <tr>
        <td align="right">&nbsp;</td>
        <td><sup style="font-size:7px;">Devlivered by: #qMI.ReturedBy#</sup></td>
      </tr>
    </table></td>
    <td width="50%" align="center" style="padding-bottom:15px;"><table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr class="nopadding">
        <td width="51%" align="right"><br/>
          <br/>
          <br/></td>
          <cfset fl = getSignature(qMI.RecievedById)/>
        <td width="49%" rowspan="2" valign="bottom">&nbsp;&nbsp;&nbsp;<img src="../../../doc/photo/core_user/#qMI.RecievedById#/#fl#" height="30"></td>
      </tr>
      <tr>
        <td align="right">Sign:</td>
        </tr>
      <tr>
        <td align="right">&nbsp;</td>
        <cfquery name="q">
        	SELECT CONCAT(Surname, " ",OtherNames) As Names FROM core_user WHERE UserId = #qMI.RecievedById#
        </cfquery>
        <td><sup style="font-size:7px;">Recieved by: #q.Names#</sup></td>
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
