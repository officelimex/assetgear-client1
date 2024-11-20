<cfoutput>
<cfset qWO = application.com.WorkOrder.GetWorkOrder(url.id)/>
<cfquery name="qF" >
	SELECT * FROM failure_report_integration 
	WHERE `PK` = <cfqueryparam cfsqltype="cf_sql_int" value="#url.id#" /> AND `IntegrateTable` = "Work Order"
</cfquery>
<cfset tsum2 = tsum = tsum3 = 0/>
<cfdocument pagetype="a4" format="pdf" margintop="0.25" marginbottom="0" marginleft="0.4" marginright="0.4">
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
	.gray{color:gray;}
	th{text-align:left !important;}
</style>
</head>
<body>
<table width="100%">
<cfdocumentitem type = "header">
<!--- check if the work order has parts, if then change it to w/m order --->
<cfset qWOI = application.com.WorkOrder.GetWorkOrderItems(url.id)/>
<cfset request.letterhead.title="WORK ORDER"/>
<CFIF qWOI.recordcount>
	<cfset request.letterhead.title="WORK/MATERIAL ORDER"/>
</CFIF>
<cfswitch expression="#qWO.Status#">
	<cfcase value="open"><cfset sts = "<span style='color:green;'>OPEN</span>"/></cfcase>
    <cfcase value="close"><cfset sts = "<span style='color:red;'>CLOSE</span>"/></cfcase>
    <cfcase value="Suspended"><cfset sts = "<span style='color:red;'>SUSPENDED</span>"/></cfcase>
    <cfdefaultcase><cfset sts = "<span style='color:gray;'>AWAITING PARTS</span>"/></cfdefaultcase>
</cfswitch>
<cfset request.letterhead.Id="W.O. ## #url.id#"/>
<cfset request.letterhead.date = "Date : #dateformat(qWO.DateOpened,'dd/mm/yyyy')#&nbsp;&nbsp;&nbsp;Status: #sts#"/>
<cfinclude template="../../../include/letter_head.cfm"/>
</cfdocumentitem>
<tr>
<td><table width="100%" border="0">
  <tr>
    <td valign="top" width="60%" align="center"><table width="90%" border="0" cellpadding="0" cellspacing="0" class="head_section">
      <tr>
        <td width="13%" valign="top" class="left">Asset</td>
        <td width="87%" valign="top" class="right">#qWO.Asset#</td>
      </tr>
      <tr>
        <td valign="top" class="left">Category</td>
        <td valign="top" class="right">#qWO.AssetCategory#&nbsp;</td>
      </tr>
      <tr>
        <td valign="top" class="left bottom">Location</td>
        <td valign="top" class="right bottom">
<!---        <cfset qAL = application.com.Asset.GetAssetLocationInWorkOrder(qWO.AssetLocationIds)/>
        #replace(ValueList(qAL.Location),',',', ','all')#--->
		<cfset qAL = application.com.Asset.GetAssetByAssetLocatonIds(qWO.AssetLocationIds)/>
        #qAL.Location#<cfif qAL.ParentLocation neq ""> @ #qAL.ParentLocation# </cfif>  #qAL.LocDescription#
        </td>
      </tr>
    </table></td>
    <td valign="top" width="40%" align="center"><table width="90%" border="0" cellpadding="0" cellspacing="0" class="head_section">
      <tr>
        <td width="22%" valign="top" nowrap="nowrap" class="left">Department</td>
        <td width="78%" valign="top" class="right" nowrap><span class="right bottom">#qWO.Department#&nbsp;<cfif qWO.Unit neq ""><span class="gray">(#qWO.Unit#)</span></cfif></span></td>
      </tr>
      <tr>
        <td valign="top" class="left">W.O. Type</td>
        <td valign="top" class="right">#qWO.JobClass#</td>
      </tr>
      <cfif val(qWO.MRId)>
          <tr>
            <td valign="top" class="left bottom">M. R ##</td>
            <td valign="top" class="right bottom"><cfif qWO.MRId neq 0>#qWO.MRId#</cfif>&nbsp;</td>
          </tr>
      </cfif>
      <cfloop query="qF" > 
          <tr>
            <td valign="top" class="left bottom">Failure R.##</td>
            <td valign="top" class="right bottom"><a style="text-decoration:none" href="http://192.168.2.13:8888/assetgear/modules/maintenance/asset/print_failure_report.cfm?id=#qF.AssetFailureReportId#" target="_blank">#qF.AssetFailureReportId#&nbsp;</a></td>
          </tr>
      </cfloop>
    </table></td>
  </tr>
</table><BR/><BR/></td>
</tr>
<tr>
  <td>
  <div class="sub_head">SCOPE OF WORK</div>
  <div class="content">
  <cfif qWO.Description eq qWO.WorkDetails>
  #qWO.WorkDetails#
  <cfelse>
  <p>#qWO.Description#<p>
  #qWO.WorkDetails#
  </cfif>
  </div><br/><br/><br/>
</td>
</tr>


<cfif qWOI.recordcount>
<tr>
  <td>
  <div class="sub_head">MATERIALS NEEDED</div>
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tbl">
    <tr>
      <th class="left" width="1px">S/N</th>
      <th>Spare parts</th>
      <th>Purpose</th>
      <th colspan="2">Quantity</th>
      <th class="a-right">Unit Price</th>
      <th class="a-right">Subtotal</th>
    </tr>
    <cfset nstock =false/>
    <cfloop query="qWOI">
    <tr <cfif qWOI.Currentrow eq qWOI.Recordcount> class="bottom" </cfif>>
      <td valign="top" class="left">#qWOI.Currentrow#</td>
      <td valign="top"><cfif qWOI.Item eq "">* #qWOI.Description#<cfelse>[#qWOI.Code#] #qWOI.Item# #qWOI.VPN#</cfif></td>
      <td valign="top">#qWOI.Purpose#</td>
      <td align="right" valign="top" class="no-right">#qWOI.Quantity#</td>
      <td valign="top">#qWOI.UM#&nbsp;</td>
      <td align="right" valign="top">#Numberformat(qWOI.UnitPrice,'9,999.99')#</td>
      <td align="right" class="cbg" valign="top">
      <cfset qu = qWOI.Quantity*qWOI.UnitPrice/>
	  <cfif qWOI.Item eq "">
      	<cfset nstock =true/>
      	<cfset tsum2 = tsum2 + qu/>
      </cfif>

        <cfset tsum = tsum + qu/>
        #NumberFormat(qu, '9,999.99')#</td>
    </tr>
    </cfloop>
    <tr class="bottom">
      <td colspan="6" valign="middle" class="no-bottom" style="font-size:8px;"><cfif nstock>Item(s) marked with * are non stocked items : total value #Numberformat(tsum2,'9,999.99')#</cfif></td>
      <td align="right" class="cbg" valign="top">#NumberFormat(tsum, '9,999.99')#</td>
    </tr>
  </table><br><br>

  </td>
</tr> </cfif>
<tr>
  <td>
  <cfset qL = application.com.WorkOrder.GetLabourers(url.id)/>
<div class="sub_head">MAN POWER</div>
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tbl">
  <tr>
      <th class="left"  width="1">S/N</th>
      <th>Staff</th>
      <th>Function</th>
      <th class="a-right">Hours</th>
      </tr>

    <cfloop query="qL">
      <tr <cfif qL.Currentrow eq qL.Recordcount> class="bottom" </cfif>>
        <td valign="top" class="left">#qL.Currentrow#</td>
        <td valign="top">#qL.Labourer#</td>
        <td valign="top">#qL.Function#</td>
        <td align="right" valign="top">#qL.Hours#</td>
        </tr>
    </cfloop>
    </table><br><br>
</td>
</tr>
  <cfset qWOC = application.com.WorkOrder.GetContractors(url.id)/>
  <cfif qWOC.recordcount>
<tr>
  <td>

  <div class="sub_head">CONTRACTORS</div>
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tbl">
    <tr>
      <th class="left" width="1px">S/N</th>
      <th>Company/Individual</th>
      <th>Work scope</th>
      <th class="a-right">Cost</th>
    </tr>
    <cfset tsum3 = 0/>
    <cfloop query="qWOC">
    <tr <cfif qWOC.Currentrow eq qWOC.Recordcount> class="bottom" </cfif>>
      <td valign="top" class="left">#qWOC.Currentrow#</td>
      <td valign="top">#qWOC.Contractor#</td>
      <td valign="top">#qWOC.Description#</td>
      <td align="right" class="cbg" valign="top"> <cfset tsum3 = tsum3 + qWOC.Cost/>#Numberformat(qWOC.Cost,'9,999.99')#</td>
    </tr>
    </cfloop>
    <tr class="bottom">
      <td colspan="3" valign="top" class="no-bottom">&nbsp;</td>
      <td align="right" class="cbg" valign="top">#NumberFormat(tsum3, '9,999.99')#</td>
    </tr>
  </table>

  </td>
</tr>
  </cfif>

<cfset gtotal = tsum3+tsum/>
<cfif gtotal gt 0>
<tr>
  <td><br/>
  <div style="text-align:right; text-decoration:underline; font-style:italic;font-size:11px;">GRAND TOTAL: #NumberFormat(gtotal,'9,999.99')#</div>
 <div style="text-align:center; font-style:italic; padding-top:8px; font-size:11px;">AMOUNT IN WORDS:
        <CFSET num = CreateObject("component","assetgear.com.adexfe.util.Finance.NumberToWords").init(NumberFormat(gtotal,'999.99'),'Naira','kobo')/>
        #ucase(num.Convert())# ONLY</div></td>
</tr>
</cfif>
<cfif qWO.Status neq "open">
<tr>
  <td>

    <BR/>
  <div class="sub_head">WORK DONE</div>
  <div class="content">
    #replace(qWO.WorkDone,chr(10),'<br/>','all')#
  </div>

    </td>
</tr>
</cfif>
<tr>
  <td>&nbsp;</td>
</tr>
<cfdocumentitem type="footer">
<tr><td ><table width="100%" border="0" style="font:9px Tahoma;">
  <tr>
    <td width="33%" align="center" style="padding-bottom:15px;"><table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr class="nopadding">
        <td width="13%" align="right"><br/>
          <br/>
          <br/></td>
        <td width="87%" rowspan="2" valign="bottom">
        <cfset fl = getSignature(qWO.SupervisedByUserId)/>
        &nbsp;&nbsp;&nbsp;<img src="../../../doc/photo/core_user/#qWO.SupervisedByUserId#/#fl#" height="30"> <span style="font-size:7px;">#dateformat(qWO.DateOpened,'dd/mm/yyyy')#</span></td>
      </tr>
      <tr>
        <td align="right" nowrap="nowrap">Sign / Date:</td>
        </tr>
      <tr>
        <td align="right">&nbsp;</td>
        <td><sup style="font-size:7px;">&nbsp;&nbsp;For #qWO.Department#: #qWO.SupervisedBy#</sup></td>
      </tr>
    </table></td>
    <td width="33%" align="center" style="padding-bottom:15px;">
    <cfif (gtotal) neq 0>
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr class="nopadding">
        <td width="53%" align="right"><br/>
          <br/>
          <br/></td>
        <td width="47%" valign="top">&nbsp;</td>
      </tr>
      <tr>
        <td align="right">Sign / Date:</td>
        <td>................................................</td>
      </tr>
      <tr>
        <td align="right">&nbsp;</td>
        <td><sup style="font-size:7px;">Material/Logistics: </sup></td>
      </tr>
    </table>
    </cfif>
    </td>
    <td width="33%" align="center" style="padding-bottom:15px;"><table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr class="nopadding">
        <td width="53%" align="right"><br/>
          <br/>
          <br/></td>
        <td width="47%" valign="top">&nbsp;</td>
      </tr>
      <tr>
        <td align="right">Sign / Date:</td>
        <td>................................................</td>
      </tr>
      <tr>
        <td align="right">&nbsp;</td>
        <td><sup style="font-size:7px;">Field Superintendent: </sup></td>
      </tr>
    </table></td>
  </tr>
</table>
  <table width="100%" border="0" style="font:9px Tahoma; border-top:1px solid ##ECF4CF; padding-left:15px;">
<tr>
  <td nowrap="nowrap">
  <cfif qWO.CreatedByUserId neq 0>
    <cfset cb = application.com.User.getUser(val(qWO.CreatedByUserId))/>
    <cfif cb.UserName neq "">
				Created by #cb.UserName#
		<cfelse>
				System Generated
		</cfif>
  </cfif>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<cfif qWO.Status eq "close">
  <cfif qWO.SupervisedBy eq qWO.ClosedBy>
    Supervised and Closed by #qWO.SupervisedBy# on #dateformat(qWO.DateClosed,'dd-mmm-yyyy')#
  <cfelse>
    Supervised by #qWO.SupervisedBy# and Closed by #qWO.ClosedBy# on #dateformat(qWO.DateClosed,'dd-mmm-yyyy')#
  </cfif>
</cfif>
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
