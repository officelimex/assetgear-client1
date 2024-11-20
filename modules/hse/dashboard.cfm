<style type="text/css">
	div.scrlx3,div.scrlx4  { height: 500px;overflow-y: auto; }
	div.scrlx4{height: 250px;}
	.grl{color:#603; font-style:italic;}
</style>
<cfoutput>
<cfimport taglib="../../assets/awaf/tags/xChart_1000/" prefix="c" />
<cfset bDt = CreateObject('component','assetgear.com.awaf.util.bDate').init()>
<div class="container-fluid pad-top10">
    <div class="row-fluid">
        <div class="span6">
            <cfquery name="qi"> 
                SELECT * FROM incident_report WHERE
                PerformingAuthorityId IS NULL OR FSAuthorityId IS NULL 
            </cfquery>
        	<p>
        	<h4>Incident Report Waiting For Approval</h4></p>
        	<div class="scrlx3">
                <table border="0" class="table table-condensed table-hover table-striped">
                    <tbody class="scrollContent">
                        <cfloop query="qi">
                            <tr>
                            <td><!--- TODO fix mr ni --->
                            	<a href="modules/hse/incident_report/print_incident.cfm?id=#qi.IncidentId#" target="_blank">#qi.IncidentId#</a>
                            </td>
                            <td>#qi.Title# 
                            <span class="grl">&mdash; 
                            	<cfif PerformingAuthorityId eq "">
                                	<span style="color:red">Waiting For Performing Authority To Approve</span>
                                <cfelse>
                                	<cfif FSAuthorityId eq "">
                                    	<span style="color:##632DFD">Waiting For FS To Approve</span>
                                    </cfif>
                                </cfif>
                            
                             </span></td>
                            </tr>
                        </cfloop>
                    </tbody>
                </table>
        	</div>


        </div>
        <div class="span6">
            <cfquery name="qi"> 
                SELECT * FROM sop_card WHERE
                DATE_FORMAT(SOPDate,'%b - %Y') = '#DateFormat(now(),"mmm - yyyy")#' 
            </cfquery>
        	<p> <h4>SOP Card For This Month</h4></p>
        	<div class="scrlx3">
                <table border="0" class="table table-condensed table-hover table-striped">
                    <tbody class="scrollContent">
                        <cfquery name="qSOP">
                        	SELECT
                            COUNT(s.SOPId) AS Num,s.Acts,DATE_FORMAT(s.SOPDate,'%b-%Y') AS D
                            FROM sop_card AS s
                            WHERE DATE_FORMAT(s.SOPDate,'%b-%Y') = '#DateFormat(now(),'mmm-yyyy')#'
                            GROUP BY s.Acts
                        </cfquery>
                        <cfloop query="qSOP">
                        	<cfif Acts eq "SafeActs">
								Safe Acts
                            <cfelseif Acts eq "UnsafeActs">
                                Unsafe Acts
                            <cfelse>
                                Unsafe Conditions
                            </cfif>
                            : <span class="badge badge-inverse">#Num#</span>&nbsp;&nbsp;&nbsp;
                        </cfloop>
                        <br><br>
                        <p><h5></h5></p>
                        <cfquery name="qD">
                        	SELECT * FROM core_department ORDER BY Name
                        </cfquery>
                        <table width="100%" class="table table-condensed table-hover table-striped">
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
                                    WHERE DepartmentId = #DepartmentId# AND DATE_FORMAT(SOPDate,'%b-%Y') = '#DateFormat(now(),'mmm-yyyy')#'
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
						
						<!---<cfloop query="qi">
                            <tr>
                            <td><!--- TODO fix mr ni --->
                            	<a href="modules/hse/incident_report/print_incident.cfm?id=#qi.IncidentId#" target="_blank">#qi.IncidentId#</a>
                            </td>
                            <td>#qi.Title# 
                            <span class="grl">&mdash; 
                            	<cfif PerformingAuthorityId eq "">
                                	<span style="color:red">Waiting For Performing Authority To Approve</span>
                                <cfelse>
                                	<cfif FSAuthorityId eq "">
                                    	<span style="color:##632DFD">Waiting For FS To Approve</span>
                                    </cfif>
                                </cfif>
                            
                             </span></td>
                            </tr>
                        </cfloop>--->
                    </tbody>
                </table>
        	</div>


        </div>


       <!--- <div class="span6" align="center">

            <cfquery name="rol">
                SELECT * FROM whs_item i
                WHERE
                    (i.MinimumInStore >= i.QOH) AND (i.QOR = 0)
                    AND i.Obsolete = "No"  AND MinimumInStore <> 0 AND i.Status = "Online"
                ORDER BY i.Description
            </cfquery>
            <p>
            <h4 align="left"><small>#rol.recordcount#</small> Items needs to be Ordered</h4></p>
            <div class="scrlx4">
                <table border="0" align="left" class="table table-condensed table-hover table-striped">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Description</th>
                            <th>Order Lv.</th>
                            <th>QOH</th>
                        </tr>
                    </thead>
                    <tbody class="scrollContent">
                        <cfloop query="rol">
                            <tr>
                                <td>#rol.ItemId#</td>
                                <td>
                                    #rol.Description# <small>#rol.VPN#</small>
                                </td>
                                <td nowrap="nowrap">#rol.MinimumInStore#</td>
                                <td nowrap="nowrap">#rol.QOH#</td>
                            </tr>
                        </cfloop>
                    </tbody>
                </table>
            </div>
            <div align="right"><small><a href="modules/warehouse/transaction/report/order_level_report.cfm" target="_blank">print report</a></small></div>

            <cfquery name="qmrd">
                SELECT * FROM whs_material_received mrd
                ORDER BY mrd.Date DESC
                LIMIT 0,10
            </cfquery>
            <p>
            <h4 align="left">Last <small>10</small> Material Received</h4></p>
            <div class="scrlx4">
                <table border="0" align="left" class="table table-condensed table-hover table-striped">
                    <tbody class="scrollContent">
                        <cfloop query="qmrd">
                            <tr>
                            <td><a href="modules/warehouse/transaction/received/print_m_received.cfm?id=#qmrd.MaterialReceivedId#" target="_blank">#qmrd.MaterialReceivedId#</a></td>
                            <td>#qmrd.Reference# <small>#qmrd.MRId#</small>
                            <span class="grl">&mdash; &##8358;#Numberformat(qmrd.NGNTotal,'9,999.99')# | #DollarFormat(qmrd.USDTotal)#</span></td>
                            <td nowrap="nowrap">#bDt.Age(now(),qmrd.Date)#</td>
                            </tr>
                        </cfloop>
                    </tbody>
                </table>
            </div>


        </div>--->
    </div>
</div>
</cfoutput>

<cffunction name="getLabelColor" access="private" returntype="string">
	<cfargument name="id" required="yes" type="numeric"/>

    <cfswitch expression="#arguments.id#">
    	<cfcase value="16"><cfset t = " label-warning"/></cfcase>
        <cfcase value="10"><cfset t = " label-important"/></cfcase>
        <cfcase value="8"><cfset t = " label-info"/></cfcase>
        <cfcase value="1"><cfset t = " label-inverse"/></cfcase>
        <cfcase value="7"><cfset t = " label-success"/></cfcase>
        <cfdefaultcase><cfset t = ""/></cfdefaultcase>
    </cfswitch>

    <cfreturn t/>
</cffunction>
