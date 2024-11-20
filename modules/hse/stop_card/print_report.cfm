 <cfoutput>

<cfdocument pagetype="a4" format="pdf" margintop="0" marginbottom="0" marginleft="0" marginright="0" orientation="portrait">
<html>
    <head>
        <cfset bg = "##f0f2f8"/>
        <cfset brd_c = "##d6daeb"/>
        <cfset brd_c2 = "##5364a9"/>
        <style type="text/css">	
            body{background: ##FFF;} body,table{ font:12px Arial;  line-height:19px; } th{text-align: center;background:##eee;border-bottom:2px ##333 solid;padding-left:1px;} td{ border-bottom:1px solid ##CCC; padding:0px; } th,td{ padding-left:2px;  } .header{text-decoration:underline;text-align:center;font-weight:bold;font-size:13px;padding-bottom:10px;display:block;text-transform:uppercase;} td.noline	{ border: none; } h2 div{font-size:14px; text-align:center; display:block;} .ftr{padding:2px; margin-right:10px;} .ftr span{padding:0px 10px;} .gr{color:gray;} h2{margin:0px;}
        </style>
    </head>
    <body>
    <table width="100%">
    
      <cfdocumentitem type = "header">
      <cfset request.letterhead.title="SOP Tracking Report"/>
      <cfset request.letterhead.Id=""/>
      <cfset request.letterhead.date = "Period: From '#dateformat(form.StartDate,'dd-mmm-yyyy')#' To '#dateformat(form.EndDate,'dd-mmm-yyyy')#'"/>
    
      <cfinclude template="../../../include/letter_head.cfm"/>
      </cfdocumentitem>
      <cfquery name="qB" cachedwithin="#CreateTime(1,0,0)#">
            SELECT
            sum(if(acts = "SafeActs",1,0)) AS SafeActs,
            sum(if(acts = "UnsafeActs",1,0)) AS UnsafeActs,
            sum(if(acts = "UnsafeConditions",1,0)) AS UnsafeConditions,
            count(SOPId) AS TotalCard
            FROM sop_card
            WHERE SOPDate BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#form.StartDate#"/> AND <cfqueryparam cfsqltype="cf_sql_date" value="#form.EndDate#"/>
      </cfquery>
      <tr>
        <td class="noline">
            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr valign="top">
                    <td width="35%">
                        
                        <table width="100%">
                            <tr><th>SOP BRIEF</th><th>&nbsp;</th></tr>
                            <tr>
                                <td>Safe Acts</td><td>#val(qB.SafeActs)#</td>
                            </tr>
                            <tr>
                                <td>Unsafe Acts</td><td>#val(qB.UnsafeActs)#</td>
                            </tr>
                            <tr>
                                <td>Unsafe Conditions</td><td>#val(qB.UnsafeConditions)#</td>
                            </tr>
                            <tr>
                                <td>Total SOPs</td><td>#val(qB.TotalCard)#</td>
                            </tr>
                        </table>	
                        <br>
                        <cfquery name="qCt">
                        	SELECT * FROM sop_act ORDER BY Category
                        </cfquery>
                        <cfset p = "Correct use of Tools/Equipment,Good procedure,Good behaviour/responsible actions,HSE milestones,Improper use of tools/equipment,Improper lifting/stacking/loading,Improper position or posture,Failure to use safe system of work/PTW,Failure to use safety devices,Failure to report incidents,Failure to use the right PPE,Rendering PPE ineffective,Rendering equipment defective,Houseplay,Operating without authorization,Operating at unsafe speed,Under the influence of alcohol or drugs,Unguarded mechinery,Unsafe floor/working surfaces,Fire or explosion hazards,Inadequate housekeeping,Workplace Congestion,Hazardous environment conditions,Spillage,Poor or ecessive illumination,Temperature extremes,Excessive noise,Broken chairs/damaged/faulty equipment"/>
                        <table width="100%" cellpadding="0" cellspacing="0" >
                        	<tr>
                            	<th style="text-align:left">Acts Categories</th>
                            	<th>Count</th>
                            </tr>
                            <cfloop query="qCt">
                                <cfquery name="qL">
                                    SELECT COUNT(SOPId) As CONT FROM `sop_card` 
                                    WHERE `ActDetails` LIKE '%#ActName#%' AND SOPDate BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#form.StartDate#"/> AND <cfqueryparam cfsqltype="cf_sql_date" value="#form.EndDate#"/>
                                </cfquery>
                                <cfif category eq 1>
                                	<cfset c = "D4F5F0"/>
                                <cfelseif category eq 2>
                                	<cfset c = "94F193"/>
                                <cfelse>
                                	<cfset c = "D3BEE5"/>
                                </cfif>
                                <tr style="font-size:10px; background-color:###c#">
                                    <td height="9px">#ActName#</td>
                                    <td style="text-align:center">#qL.CONT#</td>
                                </tr>
                            </cfloop>
                        </table>
                        
                    </td>
                    <td colspan="2" rowspan="5" class="noline" align="right">
                        <cfquery name="qD">
                        	SELECT * FROM core_department ORDER BY Name
                        </cfquery>
                        <table width="95%">
                        	<tr>
                            	<th style="text-align:left">Department</th>
                            	<th style="text-align:center">Safe</th>
                            	<th style="text-align:center">Unsafe</th>
                            	<th style="text-align:center">Unsafe Conditions</th>
                                <th style="text-align:center">Total</th>
                            </tr>
                            <cfset p = 0/>
                            <cfloop query="qD">
                            	<cfquery name="qSO">
                                    SELECT
                                    sum(if(acts = "SafeActs",1,0)) AS SafeActs,
                                    sum(if(acts = "UnsafeActs",1,0)) AS UnsafeActs,
                                    sum(if(acts = "UnsafeConditions",1,0)) AS UnsafeConditions,
                                    DATE_FORMAT(SOPDate,'%b-%Y') AS D
                                    FROM sop_card
                                    WHERE DepartmentId = #DepartmentId# AND SOPDate BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#form.StartDate#"/> AND <cfqueryparam cfsqltype="cf_sql_date" value="#form.EndDate#"/>
                            	</cfquery>
                                <tr>
                                	<td align="left">#Name#</td>
                                	<td style="text-align:center" align="center">#val(qSO.SafeActs)#</td>
                                	<td style="text-align:center">#val(qSO.UnsafeActs)#</td>
                                	<td style="text-align:center">#val(qSO.UnsafeConditions)#</td>
                                    <td style="text-align:center"><cfset i = val(qSO.SafeActs)+val(qSO.UnsafeActs)+val(qSO.UnsafeConditions)/> <strong>#i#</strong></td>
                                	<cfset p = p + i/>
                                </tr>
                            </cfloop>
                                <tr>
                                	<td colspan="4" style="text-align:right">Total</td>
                                    <td style="text-align:center"><strong>#p#</strong></td>
                                </tr>
                        </table>
                    
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                    <td colspan="2"> 
                    </td>
                </tr>
            </table>
        </td>
      </tr>
    
    
      <cfdocumentitem type="footer">
      <tr>
        <td ><table width="100%" border="0" style="font:7px Tahoma; border-top:1px solid ##ECF4CF; padding-left:15px;">
          <tr>
            <td nowrap="nowrap" align="left"></td>
            <td align="right">Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#</td>
          </tr>
        </table></td>
      </tr>
      </cfdocumentitem>
    </table>
    </body>
</html>
</cfdocument>

</cfoutput>
