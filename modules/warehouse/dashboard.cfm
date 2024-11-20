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
            <cfquery name="qmr"> 
                #application.com.Transaction.MR_SQL#
                WHERE mr.Status = "Open"
                AND DateIssued >= DATE_SUB(CURDATE(), INTERVAL 2 MONTH)
                ORDER BY mr.MRId DESC
            </cfquery>
        	<p>
        	<h4>Open Material Request<small> &mdash; #qmr.recordcount#</small></h4></p>
        	<div class="scrlx3">
                <table border="0" class="table table-condensed table-hover table-striped">
                    <tbody class="scrollContent">
                        <cfloop query="qmr">
                            <tr>
                            <td><!--- TODO fix mr ni --->
                            <cfif qmr.Type eq "SI">
                            	<a href="modules/warehouse/transaction/mr/print_mr.cfm?id=#qmr.MRId#" target="_blank">#qmr.MRId#</a>
                            <cfelse>
                            	<a href="modules/warehouse/transaction/mr/print_mrni.cfm?id=#qmr.MRId#" target="_blank">#qmr.MRId#</a>
                            </cfif></td>
                            <td>#qmr.Note# <span style="color:gray">for</span>
                            <span class="label #getLabelColor(val(qmr.DepartmentId))#">#qmr.Department#</span>
                            <!---<span class="grl">&mdash; #qmr.Status# </span>---></td>
                            <td nowrap="nowrap">#bDt.timeAgo(qmr.DateIssued)#</td>
                            </tr>
                        </cfloop>
                    </tbody>
                </table>
        	</div>

            <div align="right"><small><a href="modules/warehouse/transaction/report/agr_mr_report.cfm" target="_blank">Print Aged MR</a></small></div>

        </div>


        <div class="span6" align="center">

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



<!---cfquery name="qC4">
    SELECT
    	COUNT(is.DateIssued) CDate, SUM(NGNTotal) NT, SUM(USDTotal) DT, DATE_FORMAT(is.DateIssued,'%D') DM, is.DateIssued
    FROM whs_issue `is`
   	WHERE is.DateIssued >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',-30,now())#"/> AND is.DateIssued <=<cfqueryparam cfsqltype="cf_sql_date" value="#now()#"/>
    GROUP BY DM
    ORDER BY is.DateIssued DESC
</cfquery--->

<!---cfquery name="qC4" dbtype="query">
    SELECT * FROM qC4
    ORDER BY DateIssued ASC
</cfquery--->

<!---c:Chart width="510" height="220" type="Column2D" showNames="1" caption="Daily Issue">
	<cfloop query="qC4">
    	<c:Set value="#qC4.NT#" name="#qC4.DM#"/>
    </cfloop>
</c:Chart--->

        </div>
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
