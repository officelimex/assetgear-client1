<cfoutput>
<cfset qSR = application.com.WorkOrder.GetServiceRequest(url.id)/>
<cfdocument pagetype="a4" format="pdf" margintop="0.25" marginbottom="0" marginleft="0.5" marginright="0.5">
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
	.content{padding:5px;}
	.underline{border-bottom:solid 1px ##333;
	padding: 0px; font-style:italic;}
	.left-pad5{}
	.t td{
	padding: 10px 5px 0px;
}
	.c-space{padding: 0px 5px;}
	.boxb{font-size:12px;line-height:16px;
	border: solid 1px ##333;font-style:italic;
	padding: 8px 9px 22px; margin-bottom:5px;
}
.schar{font:"Courier New", Courier, monospace;}
.mk{
	color: ##F30;
	font-weight: bold;
}
</style>
</head>
<body>
<table width="100%">
<cfdocumentitem type = "header">
<cfset request.letterhead.title="SERVICE REQUEST"/>
<cfset request.letterhead.Id="S.R. ## #url.id#"/>
<cfinclude template="../../../include/letter_head.cfm"/>
</cfdocumentitem>
<tr>
  <td>
  <br/><table width="100%" border="0" cellspacing="0" cellpadding="0" class="t">
    <tr>
      <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td width="5%" nowrap="nowrap">Date of Request: </td>
          <td width="5%" nowrap="nowrap" class="underline"><div class="c-space">#dateformat(qSR.Date,' dd / mm / yyyy ')#&nbsp;</div></td>
          <td width="9%" nowrap="nowrap"> Requesting Party:</td>
          <td width="81%" class="underline"><div class="c-space">#qSR.Department# (#qSR.RequestBy#)</div></td>
        </tr>
      </table></td>
      </tr>
    <tr>
      <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <cfif qSR.ServiceType eq "JR">
        <tr>
          <td width="4" nowrap="nowrap">Asset/Equipment:</td>
          <td class="underline">#qSR.Asset#</td>
        </tr>
        <tr>
          <td width="9%" nowrap="nowrap">Work Location:</td>
          <td class="underline">
          <cfif trim(qSR.LocationIds) neq "">
            <cfquery name="qL" cachedwithin="#createTime(1,0,0)#">
              SELECT * FROM `location`
              WHERE `LocationId` IN (#qSR.LocationIds#)
            </cfquery>
            #replace(valuelist(qL.Name),',',', ','all')#
          </cfif>
            </td>
          </tr>
        <cfelse>
        <tr>
          <td width="4" valign="top" nowrap="nowrap">Material Request:</td>
          <td><table width="100%" border="0">
            <tr>
              <td class="underline">S/N</td>
              <td class="underline">Description</td>
              <td align="right" class="underline">Quantity</td>
              <td align="right" class="underline">Unit Price</td>
	      <td align="right" class="underline">Sub Total</td>
            </tr>
            <cfquery name="qSI" cachedwithin="#CreateTime(1,0,0)#">
            	SELECT * FROM service_request_item
                WHERE ServiceRequestId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
            </cfquery>
	    <cfset gs = 0/>
            <cfloop query="qSI">
            <tr class="Bottom">
              <td>#qSI.Currentrow#</td>
              <td>#qSI.Description#</td>
              <td align="right">#qSI.Quantity#</td>
              <td align="right">#qSI.UnitPrice#</td>
	      <cfset qu=qSI.UnitPrice * qSI.Quantity/>
	      <cfset gs = gs + qu/>
	      <td align="right">#NumberFormat(qu,"9,999.99")#</td>
            </tr>
            </cfloop>
            <tr>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
	      <td colspan="2" align="right"><b>#NumberFormat(gs,"9,999.99")#</b></td>
            </tr>
<tr>
<td colspan="5">
<cfif gs neq 0>
<div style="text-align:left; font-style:italic; padding-top:8px; font-size:11px;">AMOUNT IN WORDS:
        <CFSET num = CreateObject("component","assetgear.com.adexfe.util.Finance.NumberToWords").init(NumberFormat(gs,'999.99'),'Naira','kobo')/>
        #ucase(num.Convert())# ONLY</div>
</cfif>
</td>

</tr>
          </table></td>
        </tr>
        </cfif>
      </table></td>
    </tr>
    <tr>
      <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><cfif qSR.ServiceType eq "JR">Description of work/repair<cfelse>Reason for request</cfif>:</td>
          </tr>
        <tr>
          <td><div class="boxb">
          	<cfif qSR.ServiceType eq "JR">
            #replace(qSR.Description,chr(10),'<br/>','all')#
            <cfelse>
            #replace(qSR.ReasonForRequest,chr(10),'<br/>','all')#
            </cfif>
           </div></td>
        </tr>
      </table></td>
    </tr>
    <tr>
      <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr class="t">
          <td>Requested Priority:</td>
        </tr>
        <tr class="t">
          <td><span class="schar">[
            <cfif qSR.Priority eq "h">
              <span class="mk">x</span>
<cfelse>
              &nbsp;
            </cfif>
            ]</span> High - Must be done within 48 hours.</td>
        </tr>
        <tr class="t">
          <td><span class="schar">[
            <cfif qSR.Priority eq "m">
              <span class="mk">x</span>
<cfelse>
              &nbsp;
            </cfif>
            ]</span> Medium - Within the week.</td>
        </tr>
        <tr class="t">
          <td><span class="schar">[
            <cfif qSR.Priority eq "l">
              <span class="mk">x</span><cfelse>              &nbsp;
            </cfif>
            ]</span> Low - When you get a chance.</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
      </table></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
  </table>

  </td>
</tr>
<cfdocumentitem type="footer">
<tr><td >
<table width="100%" border="0" padding="0"  style="font:9px Tahoma;">
  <tr>
		<td align="left">
			<table width="100%" border="0">
			  <tr>
			    <td align="right">Sign / Date:</td>
			    <td align="left" valign="bottom">
						<cfset fl = getSignature(qSR.RequestByUserId)/>
						&nbsp;&nbsp;&nbsp;<img src="../../../doc/photo/core_user/#qSR.RequestByUserId#/#fl#" height="30px">
						#DateFormat(qSR.Date,"dd-mmm-yyyy")#
					</td>
			  </tr>
			  <tr>
			    <td align="right">&nbsp;</td>
			    <td><sup style="font-size:7px;">Department: #qSR.Department#</sub></td>
			  </tr>
			</table>
    </td>
    <td width="33%" align="left">
			<cfif qSR.Category eq "s">
				<table>
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
    <td width="33%"  align="left">
			<cfif qSR.Category eq "s">
			<table>
				<tr>
	        <td align="right">Sign / Date:</td>
	        <td>................................................</td>
	      </tr>
	      <tr>
	        <td align="right">&nbsp;</td>
	        <td><sup style="font-size:7px;">Field Superintendent: </sup></td>
	      </tr>
			</table>
		</cfif>
		</td>
  </tr>
</table>

<table width="100%" border="0" style="font:9px Tahoma; border-top:1px solid gray; padding-left:15px;">
	<tr>
	  <td nowrap="nowrap">
				Created By: #qSR.RequestBy#
	  </td>
	    <td align="right">Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#</td>
	</tr>
</table></td></tr>
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
