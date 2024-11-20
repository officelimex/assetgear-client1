<cfoutput>
<cfset qDN = application.com.Transaction.GetDN(url.id)/>
<cfquery name="qDN">
	SELECT m.*,CONCAT(cu.Surname," ",cu.OtherNames) AS CreatedBy FROM whs_mdn m
	INNER JOIN core_user cu ON cu.UserId = m.CreatedByUserId
	WHERE m.DeliveryNoteId = #url.id#
</cfquery>
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
<cfset request.letterhead.title="MATERIAL DELIVERY NOTE"/>
<cfset request.letterhead.Id="## #url.id#"/>
<cfset request.letterhead.date="Date: #dateformat(qDN.Date,'dd/mm/yyyy')#"/>
<cfinclude template="../../../../include/letter_head.cfm"/>
</cfdocumentitem>
<tr>
  <td>
      <table width="100%" border="0">
        <tr>
            <td valign="top" width="50%" align="left">
            	<table width="90%" border="0" cellpadding="0" cellspacing="0" class="head_section">
                    <tr>
                      <td width="35%" valign="top" class="left">ATTN</td>
                      <td width="65%" valign="top" class="right">#qDN.ATTN#&nbsp;</td>
                    </tr>
                    <tr>
                      <td valign="top" class="left">ITEM FROM</td>
                      <td valign="top" class="right">#qDN.ItemFrom#&nbsp;</td>
                    </tr>
                    <tr>
                      <td  valign="top" class="left">REQUESTED BY</td>
                      <td valign="top" class="right">#qDN.RequestedBy#&nbsp;</td>
                    </tr>
                    <tr>
                      <td valign="top" nowrap="nowrap" class="left bottom">DELIVER TO</td>
                      <td valign="top" class="right bottom">#qDN.DeliverToUser#&nbsp;</td>
                    </tr>
                 </table>
            </td>
            <td valign="top"  align="center">
              <table width="100%" border="0" cellpadding="0" cellspacing="0" class="head_section">
                <tr>
                  <td width="35%" valign="top" class="left">DATE</td>
                  <td width="65%" valign="top" class="right">#DateFormat(qDN.Date,"dd-mmm-yyyy")#&nbsp;</td>
                  </tr>
                    <tr>
                      <td  valign="top" class="left">REQUISITION</td>
                      <td valign="top" class="right">#qDN.Requisition#&nbsp;</td>
                    </tr>
                <tr>
                  <td valign="top" nowrap="nowrap" class="left bottom">REMARK</td>
                  <td valign="top" class="right bottom">#qDN.Remark#&nbsp;</td>
                </tr>
              </table>
            </td>
          </tr>
      </table>
  	  <BR/><BR/><BR/>
  </td>
</tr>
<tr>
  <td>

    <cfquery name="qDNI">
    	SELECT * FROM whs_mdn_item
        WHERE DeliveryNoteId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
    </cfquery>
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tbl">
      <tr>
        <th class="left" width="1">S/N</th>
        <th class="center" width="1px">QTY.</th>
        <th class="left" >UNIT</th>
        <th class="left">ITEM DESCRIPTION</th>
        </tr>
        <cfset gs = 0/>
      <cfloop query="qDNI">
        <tr <cfif qDNI.Currentrow eq qDNI.Recordcount> class="bottom" </cfif>>
          <td valign="top" class="left">#qDNI.Currentrow#</td>
          <td align="center" valign="top" class="right" style="padding-right:0px;">#qDNI.Quantity#</td>
          <td align="left" nowrap valign="top" class="right" style="">#qDNI.Unit#</td>
          <td align="left" valign="top">#qDNI.Description#</td>
          </tr>
      </cfloop>
      </table></td>
      <br><br><br>
</tr>
<tr>
      <table width="100%" border="0">
         <tr>
            <td valign="top"  align="left">
              <table width="46%" border="0" cellpadding="0" cellspacing="0" class="head_section">
                <tr>
                  <td width="30%" valign="top" class="left bottom">VEHICLE NO:</td>
                  <td width="70%" valign="top" class="right bottom">#qDN.VehicleNo#&nbsp;</td>
                  </tr>
              </table>
            </td>
          </tr>
       <tr>
        	<td colspan="2">
            	<table width="100%" cols="2" border="0" cellpadding="0" cellspacing="0" class="head_section">
                	<tr>
                    	<td width="15%" valign="top" class="left">HAULED BY:</td>
                    	<td width="35%" valign="top" class="right">#qDN.HauledBy#&nbsp;</td>
                    	<td width="10%" valign="top" class="left">DATE</td>
                    	<td width="15%" valign="top" class="right ">...../...../........ </td>
                    	<td width="10%" valign="top" class="left">SIGN</td>
                    	<td width="15%" valign="top" class="right ">...........................................</td>
                    </tr>
                	<tr>
                    	<td width="15%" valign="top" class="left">LOADED BY:</td>
                    	<td width="35%" valign="top" class="right bottom">#qDN.LoadedBy#&nbsp;</td>
                    	<td width="10%" valign="top" class="left">DATE</td>
                    	<td width="15%" valign="top" class="right bottom">#DateFormat(qDN.LoadedDate,"dd-mmm-yyyy")#</td>
                    	<td width="10%" valign="top" class="left">SIGN</td>
                    	<td width="15%" valign="top" class="right bottom">...........................................</td>
                    </tr>
                </table>
            </td>

        </tr>
      </table>
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
    <td>&nbsp;</td><td width="50%" align="center" style="font:9px Tahoma;padding-bottom:25px;"><table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr class="nopadding">
        <td width="23%" align="right"><br/>
          <br/>
          <br/></td>
        <td width="77%" valign="top">&nbsp;</td>
      </tr>
      <tr>
        <td align="right">Sign / Date:</td>
        <td>........................................................</td>
      </tr>
      <tr>
        <td align="right">&nbsp;</td>
        <td><sup style="font-size:7px;">Received by: </sup></td>
      </tr>
    </table></td>
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
    <td><sup style="font-size:7px;">Verified By: </sup></td>
  </tr>
</table></td>
  </tr>
</table>

<table width="100%" border="0" style="font:9px Tahoma; border-top:1px solid gray; padding-left:15px;">
<tr>
  <td nowrap="nowrap">

  </td>
    <td align="right">Created By: #qDN.CreatedBy#</td>
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
