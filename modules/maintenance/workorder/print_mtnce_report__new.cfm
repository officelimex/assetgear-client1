<cfoutput>
<cfimport taglib="../../../assets/awaf/tags/xChart_1000/" prefix="c" />
<cfset EXCHANGE_RATE = #Form.ExchangeRate#/>
<cfset HOURLY_RATE = 50/>
<cfparam name="url.unitid" default="1,2,3,5" />

<cfif month(now()) eq 1>
	<cfparam name="url.m" default="12"/>
<cfelse>
	<cfparam name="url.m" default="#month(now())-1#"/>
</cfif>

<cfset dmonth = url.m/>

<cfif month(now()) eq 1>
	<cfset dyear = year(now()) - 1 />
<cfelse>
	<cfset dyear = year(now()) />
</cfif>

<cfset dpart = dyear & "/" & dmonth/>
<cfset startd =  "#DateFormat(form.StartDate,'yyyy-mm-dd')#">
<cfset dinmonth = DaysInMonth(startd)/>
<cfset endd =  "#DateFormat(form.EndDate,'yyyy-mm-dd')#">
		  
<cfset ystart = year(startd) & "/01/01"/>
<cfset mtnid = url.unitid /> 
<!---- ---->
<cfquery name="qWO">
	#application.com.WorkOrder.WORK_ORDER_SQL#
    WHERE wo.UnitId IN (#mtnid#) AND wo.Status <> "Decline"
    AND DateOpened >= <cfqueryparam cfsqltype="cf_sql_date" value="#startd#"/>
    AND DateOpened <= <cfqueryparam cfsqltype="cf_sql_date" value="#endd#"/>
</cfquery>
<!---<cfdump var="#qWO#"/>
<cfabort/>--->

<cfset dept = qWO.Unit/>
<cfset pm_count = m_count = open_pm_count = open_m_count = close_pm_count = close_m_count = cr_pm_o_count = mi_pm_o_count = ma_pm_o_count = 0/>
<!---<cfset mech_c1 = elect_c1 = ins_c1 = ra_c1 = prod_c1 = fm_c1 = 0/>
<cfset mech_c2 = elect_c2 = ins_c2 = ra_c2 = prod_c2 = fm_c2 = 0/>
<cfset mech_c3 = elect_c3 = ins_c3 = ra_c3 = prod_c3 = fm_c3 = 0/>

<cfset mech_c11 = elect_c11 = ins_c11 = ra_c11 = prod_c11 = fm_c11 = 0/>
<cfset mech_c21 = elect_c21 = ins_c21 = ra_c21 = prod_c21 = fm_c21 = 0/>
<cfset mech_c31 = elect_c31 = ins_c31 = ra_c31 = prod_c31 = fm_c31 = 0/>--->
	
<cfset mech_c1 = elect_c1 = ins_c1 = prod_c1 = fm_c1 = 0/>
<cfset mech_c2 = elect_c2 = ins_c2 = prod_c2 = fm_c2 = 0/>
<cfset mech_c3 = elect_c3 = ins_c3 = prod_c3 = fm_c3 = 0/>

<cfset mech_c11 = elect_c11 = ins_c11 = prod_c11 = fm_c11 = 0/>
<cfset mech_c21 = elect_c21 = ins_c21 = prod_c21 = fm_c21 = 0/>
<cfset mech_c31 = elect_c31 = ins_c31 = prod_c31 = fm_c31 = 0/>

<cfset pm_woid = m_woid = ""/>

<cfloop query="qWO">
	
	<cfif qWO.WorkClassId eq 10>
   		<cfset pm_woid = ListAppend(pm_woid,qWO.WorkOrderId)/>
    	<cfset pm_count++/>

        <cfswitch expression="#qWO.Status#">
        	<cfcase value="Open">
				<cfset open_pm_count++/>
                <cfswitch expression="#qWO.UnitId#">
                    <cfcase value="1"><cfset mech_c2++/></cfcase>
                    <cfcase value="2"><cfset ins_c2++/></cfcase>
                    <cfcase value="3"><cfset elect_c2++/></cfcase> 
                    <!---<cfcase value="4"><cfset ra_c2++/></cfcase> --->
                    <cfcase value="5"><cfset fm_c2++/></cfcase> 
                </cfswitch>
            </cfcase>
            <cfcase value="Close">
				<cfset close_pm_count++/>
                <cfswitch expression="#qWO.UnitId#">
                    <cfcase value="1"><cfset mech_c3++/></cfcase>
                    <cfcase value="2"><cfset ins_c3++/></cfcase>
                    <cfcase value="3"><cfset elect_c3++/></cfcase> 
                    <!---<cfcase value="4"><cfset ra_c3++/></cfcase> --->
                    <cfcase value="5"><cfset fm_c3++/></cfcase> 
                </cfswitch>
            </cfcase>
        </cfswitch>
        <cfswitch expression="#qWO.UnitId#">
        	<cfcase value="1"><cfset mech_c1++/></cfcase>
            <cfcase value="2"><cfset ins_c1++/></cfcase>
            <cfcase value="3"><cfset elect_c1++/></cfcase> 
            <!---<cfcase value="4"><cfset ra_c1++/></cfcase> --->
            <cfcase value="5"><cfset fm_c1++/></cfcase> 
        </cfswitch>
     
    <cfelseif (((qWO.WorkClassId eq 3)||(qWO.WorkClassId eq 13)||(qWO.WorkClassId eq 4)||(qWO.WorkClassId eq 7)||(qWO.WorkClassId eq 15)||(qWO.WorkClassId eq 17))&&(qWO.AssetClass eq "Critical"))>
    	
        <cfset m_woid = ListAppend(m_woid,qWO.WorkOrderId)/>
        <cfset m_count++/>
         
        <cfswitch expression="#qWO.Status#">
        	<cfcase value="Open">
				<cfset open_m_count++/>
                <cfswitch expression="#qWO.UnitId#">
                    <cfcase value="1"><cfset mech_c21++/></cfcase>
                    <cfcase value="2"><cfset ins_c21++/></cfcase>
                    <cfcase value="3"><cfset elect_c21++/></cfcase> 
                    <!---<cfcase value="4"><cfset ra_c21++/></cfcase> --->
                    <cfcase value="5"><cfset fm_c21++/></cfcase> 
                </cfswitch>
            </cfcase>
            <cfcase value="Close">
				<cfset close_m_count++/>
                <cfswitch expression="#qWO.UnitId#">
                    <cfcase value="1"><cfset mech_c31++/></cfcase>
                    <cfcase value="2"><cfset ins_c31++/></cfcase>
                    <cfcase value="3"><cfset elect_c31++/></cfcase> 
                    <!---<cfcase value="4"><cfset ra_c31++/></cfcase> --->
                    <cfcase value="5"><cfset fm_c31++/></cfcase> 
                </cfswitch>
            </cfcase>
        </cfswitch>
        <cfswitch expression="#qWO.UnitId#">
        	<cfcase value="1"><cfset mech_c11++/></cfcase>
            <cfcase value="2"><cfset ins_c11++/></cfcase>
            <cfcase value="3"><cfset elect_c11++/></cfcase> 
            <!---<cfcase value="4"><cfset ra_c11++/></cfcase> --->
            <cfcase value="5"><cfset fm_c11++/></cfcase> 
        </cfswitch> 
         
    </cfif>
    
</cfloop>

<cfset mech_t1 = ra_t1 = ins_t1 = elect_t1 = fm_t1 = 0/>
<cfif mech_c3 neq 0><cfset mech_t1 = numberformat(mech_c3/mech_c1*100,'999')/></cfif> 
<cfif ins_c3 neq 0><cfset ins_t1 = numberformat(ins_c3/ins_c1*100,'999')/></cfif>
<cfif elect_c3 neq 0><cfset elect_t1 = numberformat(elect_c3/elect_c1*100,'999')/></cfif>
<!---<cfif ra_c3 neq 0><cfset ra_t1 = numberformat(ra_c3/ra_c1*100,'999')/></cfif>--->
<cfif fm_c3 neq 0><cfset fm_t1 = numberformat(fm_c3/fm_c1*100,'999')/></cfif>

<cfset mech_t2 = prod_t2 = ra_t2 = ins_t2 = elect_t2 = fm_t2 = 0/>
<cfif mech_c31 neq 0><cfset mech_t2 = numberformat(mech_c31/mech_c11*100,'999')/></cfif> 
<cfif ins_c31 neq 0><cfset ins_t2 = numberformat(ins_c31/ins_c11*100,'999')/></cfif>
<cfif elect_c31 neq 0><cfset elect_t2 = numberformat(elect_c31/elect_c11*100,'999')/></cfif>
<!---<cfif ra_c31 neq 0><cfset ra_t2 = numberformat(ra_c31/ra_c11*100,'999')/></cfif>--->
<cfif fm_c31 neq 0><cfset fm_t2 = numberformat(fm_c31/fm_c11*100,'999')/></cfif>

<html> 
<head>
<cfset bg = "##f0f2f8"/>
<cfset brd_c = "##d6daeb"/>
<cfset brd_c2 = "##5364a9"/>
<style type="text/css">	
	body{background: ##FFF; width:860; margin:0 auto; border-left:solid 1px;border-right:solid 1px;} body,table{ font:12px Arial;  line-height:22px; } th{text-align: center;background:##eee;border-bottom:1px ##aaa solid;padding-left:1px;} td{ border-bottom:1px solid ##ddd; padding:1px; } th,td{ padding-left:2px;  } .header{text-decoration:underline;text-align:center;font-weight:bold;font-size:13px;padding-bottom:10px;display:block;text-transform:uppercase;} td.noline	{ border: none; } h2 div{font-size:14px; text-align:center; display:block;} .ftr{padding:2px; margin-right:10px;} .ftr span{padding:0px 10px;} .gr{color:gray;} h2{margin:0px;}
     .page_break {page-break-before: always} .red{color:red;} .green {color:green;} .orange{color:orange;}
</style>
</head>
<body> 
<table width="100%">

<!---cfset request.letterhead.title="MONTHLY MAINTENANCE REPORT"/--->
<cfset request.letterhead.title="MAINTENANCE REPORT"/>
<cfset request.letterhead.Id=""/>
<!---cfset request.letterhead.date = "Period : #MonthAsString(dmonth)# - #dyear#"/--->
<cfset request.letterhead.date = "Period : #dateformat(startd,"dd-mmm-yyyy")# To #dateformat(endd,"dd-mmm-yyyy")#"/>
<cfset request.letterhead.noline = true/>
<cfinclude template="../../../include/letter_head.cfm"/>

<tr>
  <td class="noline"><br/><h2 align="center">Executive Summary</h2></td>
</tr>
<tr>
  <td class="noline">
<c:Chart caption="" width="855" height="250" type="MSColumn2DLineDY" PYAxisName="Completed Jobs (%25)" SYAxisName="Cost of Maintenance ($)">
	<c:Categories>
        <c:category name="Mechanical"/>
        <c:category name="Instrumentation"/>
        <c:category name="Electrical"/>
        <!---<c:category name="R and A"/> --->
        <c:category name="F.M."/> 
    </c:Categories> 
    <c:dataset seriesName="Non-Planned Maintenance" color="AFD8F8" showValues="1" numberSuffix="%25">
        <c:set value="#mech_t2#"/>
        <c:set value="#ins_t2#"/>
        <c:set value="#elect_t2#"/>
        <!---<c:set value="#ra_t2#"/> --->
        <c:set value="#fm_t2#"/> 
    </c:dataset>
    <c:dataset seriesName="Planned Maintenance" color="F6BD0F" showValues="1" numberSuffix="%25">
        <c:set value="#mech_t1#"/>
        <c:set value="#ins_t1#"/>
        <c:set value="#elect_t1#"/>
        <!---<c:set value="#ra_t1#"/> --->
        <c:set value="#fm_t1#"/> 
    </c:dataset>
<cfquery name="qTC">
    SELECT 
        SUM(i.UnitPrice*wi.Quantity) T, i.Currency, w.DepartmentId, w.UnitId
    FROM work_order_item wi
    INNER JOIN whs_item i ON i.ItemId = wi.ItemId
    INNER JOIN work_order w ON w.WorkOrderId = wi.WorkOrderId
    WHERE w.DateOpened >= <cfqueryparam cfsqltype="cf_sql_date" value="#startd#"/>
    	AND w.DateOpened <= <cfqueryparam cfsqltype="cf_sql_date" value="#endd#"/>
		AND w.UnitId IN (#mtnid#)
    GROUP BY i.Currency
</cfquery>
 
<c:dataset seriesName="Cost of Maintenance" color="8BBA00" parentYAxis="S" numberPrefix="$">
<cfloop list="#mtnid#" index="dpt">
    <cfquery name="qW1" dbtype="query">
        SELECT * FROM qTC WHERE UnitId = #dpt#
    </cfquery>
    <cfquery name="qW11">
        <!---SELECT
            SUM(if(w.Currency = "USD",wi.Quantity*w.UnitPrice,0)) AS USD,
            SUM(if(w.Currency = "NGN",wi.Quantity*w.UnitPrice,0)) AS NGN1,
            SUM(if(wi.ItemId IS NULL,wi.Quantity*wi.UnitPrice,0)) AS NGN2
        FROM
        	work_order_item AS wi
        LEFT JOIN whs_item AS w ON wi.ItemId = w.ItemId
        INNER JOIN work_order AS wo ON wi.WorkOrderId = wo.WorkOrderId
        WHERE wo.UnitId = #dpt# AND wo.DateOpened BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#startd#"/>
    	AND <cfqueryparam cfsqltype="cf_sql_date" value="#endd#"/> --->  
        
        SELECT
        Sum(if(w.Currency = "USD",wi.Quantity*w.UnitPrice,0)) AS USD,
        Sum(if(w.Currency = "NGN",wi.Quantity*w.UnitPrice,0)) AS NGN1,
        Sum(if(wi.ItemId IS NULL,wi.Quantity*wi.UnitPrice,0)) AS NGN2,
        Sum(if(c.Currency = "USD",c.Cost,0)) AS ContractINUSD,
        Sum(if(c.Currency = "NGN",c.Cost,0)) AS ContractINNGN
        FROM
        work_order_item AS wi
        LEFT JOIN whs_item AS w ON wi.ItemId = w.ItemId
        LEFT JOIN work_order AS wo ON wi.WorkOrderId = wo.WorkOrderId
        LEFT JOIN contract AS c ON c.WorkOrderId = wi.WorkOrderId
        WHERE wo.UnitId = #dpt# AND wo.DateOpened BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#startd#"/>
    	AND <cfqueryparam cfsqltype="cf_sql_date" value="#endd#"/> 
        AND wo.Status = 'Close'  
        
    </cfquery>
    <cfset usd = val(qw11.USD) + val(qw11.ContractINUSD)>
    <cfset ngn1 = val(qw11.NGN1) + val(qw11.NGN2) + val(qw11.ContractINNGN)>
    <cfset ngn2 = 0>
	<cfif usd eq ""><cfset usd = 0></cfif>
	<cfif ngn1 eq ""><cfset ngn1 = 0></cfif>
	<cfif ngn2 eq ""><cfset ngn2 = 0></cfif>
    <cfset cmtn["m#dpt#"] = 0/>
    <cfset cmtn["m#dpt#"] = usd + (ngn1 / EXCHANGE_RATE)/>
    <!---<cfloop query="qW1">
        <cfif qW1.Currency eq "NGN">
            <cfset cmtn["m#dpt#"] = cmtn["m#dpt#"] + (qW1.T / EXCHANGE_RATE)/>
        <cfelse>
            <cfset cmtn["m#dpt#"] = cmtn["m#dpt#"] + qW1.T/>
        </cfif>
    </cfloop>--->
    <!--- get the labor hours --->
    <!---<cfquery name="qLbr">
    	SELECT
        	SUM(l.Hours) Hr 
        FROM labour l
        INNER JOIN work_order w ON w.WorkOrderId = l.WorkOrderId
        WHERE w.UnitId = #dpt#
    		AND w.DateOpened >= <cfqueryparam cfsqltype="cf_sql_date" value="#startd#"/>
    		AND w.DateOpened <= <cfqueryparam cfsqltype="cf_sql_date" value="#endd#"/>
    </cfquery>--->
    <!---<cfset cmtn["m#dpt#"] = cmtn["m#dpt#"]+(val(qLbr.Hr)*HOURLY_RATE)/>--->
    <!--- get the contractor --->
    <!---<cfquery name="qCont">
    	SELECT
        	SUM(c.Cost/#EXCHANGE_RATE#) Total 
        FROM contract c
        INNER JOIN work_order w ON w.WorkOrderId = c.WorkOrderId
        WHERE w.UnitId = #dpt#
    		AND w.DateOpened >= <cfqueryparam cfsqltype="cf_sql_date" value="#startd#"/>
    		AND w.DateOpened <= <cfqueryparam cfsqltype="cf_sql_date" value="#endd#"/>
    </cfquery>--->
    <cfset d = cmtn["m#dpt#"]/>
    <c:set value="#d#"/> 
</cfloop>  
    </c:dataset>
</c:Chart>  </td>
</tr>
<tr>
  <td class="noline"> 
  
<table width="100%" border="0" cellpadding="10" cellspacing="10">
  <tr>
  	<td colspan="6"><strong>EXCHANGE RATE: &##8358;#form.ExchangeRate#  TO  &##36;1</strong></td>
  </tr>
  <tr>
    <td valign="top" class="noline"><table width="100%" border="0" cellpadding="0" cellspacing="0" >
      <tr>
        <th colspan="7" align="center">Planned Maintenance</th>
        <td class="noline"> </td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td align="center" valign="top">Mech</td>
        <td align="center" valign="top">Inst.</td>
        <td align="center" valign="top">Elec.</td>
        <!---<td align="center" valign="top">R &amp; A</td>--->
        <td align="center" valign="top">F.M.</td>
        <td align="center" valign="top">&nbsp;</td>
        <td align="center" class="noline">&nbsp;</td>
        </tr>
      <tr>
        <td align="right" valign="top">PM task planned:&nbsp;&nbsp;&nbsp;</td>
        <td align="center" valign="top">#mech_c1#</td>
        <td align="center" valign="top">#ins_c1#</td>
        <td align="center" valign="top">#elect_c1#</td>
        <!---<td align="center" valign="top">#ra_c1#</td>--->
        <td align="center" valign="top">#fm_c1#</td>
        <td align="center" valign="top">#pm_count#</td>
        <td align="center" class="noline">&nbsp;</td>
        </tr>
      <tr>
        <td align="right" valign="top">PM task still open:&nbsp;&nbsp;&nbsp;</td>
        <td align="center" valign="top">#mech_c2#</td>
        <td align="center" valign="top">#ins_c2#</td>
        <td align="center" valign="top">#elect_c2#</td>
        <!---<td align="center" valign="top">#ra_c2#</td>--->
        <td align="center" valign="top">#fm_c2#</td>
        <td align="center" valign="top">#open_pm_count# </td>
        <td align="center" class="noline">&nbsp;</td>
        </tr>
      <tr>
        <td align="right" valign="top">PM task closed out:&nbsp;&nbsp;&nbsp;</td>
        <td align="center" valign="top">#mech_c3#</td>
        <td align="center" valign="top">#ins_c3#</td>
        <td align="center" valign="top">#elect_c3#</td>
        <!---<td align="center" valign="top">#ra_c3#</td>--->
        <td align="center" valign="top">#fm_c3#</td>
        <td align="center" valign="top">#close_pm_count# </td>
        <td align="center" class="noline">&nbsp;</td>
        </tr>
      <tr>
        <td align="right" valign="top">% Completed:&nbsp;&nbsp;&nbsp;</td>        
        <td align="center" valign="top">#mech_t1#%</td>
        <td align="center" valign="top">#ins_t1#%</td>
        <td align="center" valign="top">#elect_t1#%</td>
        <!---<td align="center" valign="top">#ra_t1#%</td>--->
        <td align="center" valign="top">#fm_t1#%</td>
        <td align="center" valign="top"><cfif close_pm_count neq 0>#NumberFormat(close_pm_count/pm_count*100,'999.9')#%</cfif></td>
        <td align="center" class="noline">&nbsp;</td>
        </tr> 
    </table>
    </td>
 
    <td valign="top" class="noline"><table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <th colspan="2" align="center">Current Status</th>
        </tr>
      <tr>
        <td align="right" valign="top">Suspended jobs:&nbsp;&nbsp;&nbsp;</td>
        <td align="center" valign="top">
	    <cfquery name="qS" dbtype="query">
        	SELECT WorkOrderId FROM qWO
            WHERE Status = 'Suspended'
        </cfquery>
        #qS.Recordcount#     
        </td>
      </tr>
      <tr>
        <td align="right" valign="top">On going Jobs:&nbsp;&nbsp;&nbsp;</td>
        <td align="center" valign="top">
	    <cfquery name="qO" dbtype="query">
        	SELECT WorkOrderId FROM qWO
            WHERE Status = 'Open'
        </cfquery>#qO.Recordcount#
        </td>
      </tr>
      <tr>
        <td align="right" valign="top">Job awiting parts:&nbsp;&nbsp;&nbsp;</td>
        <td align="center" valign="top">
	    <cfquery name="qP" dbtype="query">
        	SELECT WorkOrderId FROM qWO
            WHERE Status = 'Part on hold'
        </cfquery>#qP.Recordcount#        
        </td>
      </tr>
      <tr>
        <td align="right" valign="top">Total:&nbsp;&nbsp;&nbsp;</td>
        <td align="center" valign="top">#qP.Recordcount+qO.Recordcount+qS.Recordcount#</td>
      </tr>
      </table></td>
  </tr>
</table>
<table width="100%" border="0" cellpadding="10" cellspacing="10">
  <tr>
    <td valign="top" class="noline"><table width="100%" border="0" cellpadding="0" cellspacing="0" >
      <tr>
        <th colspan="7" align="center">Non-Planned Maintenance</th>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td align="center" valign="top">Mech</td>
        <td align="center" valign="top">Elec.</td>
        <td align="center" valign="top">Inst.</td>
        <!---<td align="center" valign="top">R &amp; A</td>--->
        <td align="center" valign="top">F.M.</td>
        <td align="center" valign="top">&nbsp;</td>
        </tr>
      <tr>
        <td align="right" valign="top">Total Jobs:&nbsp;&nbsp;&nbsp;</td>
        <td align="center" valign="top">#mech_c11#</td>
        <td align="center" valign="top">#elect_c11#</td>
        <td align="center" valign="top">#ins_c11#</td>
        <!---<td align="center" valign="top">#ra_c11#</td>--->
        <td align="center" valign="top">#fm_c11#</td>
        <td align="center" valign="top">#m_count#</td>
        </tr>
      <tr>
        <td align="right" valign="top">Jobs still open:&nbsp;&nbsp;&nbsp;</td>
        <td align="center" valign="top">#mech_c21#</td>
        <td align="center" valign="top">#elect_c21#</td>
        <td align="center" valign="top">#ins_c21#</td>
        <!---<td align="center" valign="top">#ra_c21#</td>--->
        <td align="center" valign="top">#fm_c21#</td>
        <td align="center" valign="top">#open_m_count# </td>
        </tr>
      <tr>
        <td align="right" valign="top">Jobs closed out:&nbsp;&nbsp;&nbsp;</td>
        <td align="center" valign="top">#mech_c31#</td>
        <td align="center" valign="top">#elect_c31#</td>
        <td align="center" valign="top">#ins_c31#</td>
        <!---<td align="center" valign="top">#ra_c31#</td>--->
        <td align="center" valign="top">#fm_c31#</td>
        <td align="center" valign="top">#close_m_count# </td>
        </tr>
      <tr>
        <td align="right" valign="top">% Completed:&nbsp;&nbsp;&nbsp;</td>
        <td align="center" valign="top">
		  <cfif mech_c31 neq 0>
          	  #numberformat(mech_c31/mech_c11*100,'999')#%
          </cfif>
        </td>
        <td align="center" valign="top">
		  <cfif elect_c31 neq 0>
              #numberformat(elect_c31/elect_c11*100,'999')#%
          </cfif>
        </td>
        <td align="center" valign="top">
		  <cfif ins_c31 neq 0>
              #numberformat(ins_c31/ins_c11*100,'999')#%
          </cfif>
        </td>
        <!---<td align="center" valign="top">
		  <cfif ra_c31 neq 0>
              #numberformat(ra_c31/ra_c11*100,'999')#%
          <cfelse>
          	0%
          </cfif>
        </td>--->
        <td align="center" valign="top">
		  <cfif fm_c31 neq 0>
              #numberformat(fm_c31/fm_c11*100,'999')#%
          <cfelse>
          	0%
          </cfif>
        </td>
        <td align="center" valign="top">
		  <cfif close_m_count neq 0>
               #NumberFormat(close_m_count/m_count*100,'999.9')#%
          </cfif>
        </td>
        </tr>
    </table></td>
    </tr>
</table>
<br>
<cfset grand_total = 0/>  
<table width="100%" border="0" cellpadding="0" cellspacing="10">
  <tr>
    <th colspan="7" align="center">Cost of Maintenance</th>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td align="center">Count</td>
    <td align="center">Man hours</td>
    <!---<td align="right">Labour</td>--->
    <td align="right" nowrap="nowrap">Contract Jobs</td>
    <td align="right">Parts</td>
    <td align="right">Total</td>
  </tr>
  <tr>
    <td align="right" valign="top">PM tasks completed:&nbsp;&nbsp;&nbsp;</td>
    <td align="center" valign="top">#close_pm_count#</td>
    <td align="center" valign="top">
    	<cfset pm_h = GetManHours(pm_woid)/>#pm_h#
    </td>
    
    <!---<td align="right" valign="top"><cfset lprice = HOURLY_RATE*pm_h/>#dollarformat(lprice)#</td>--->
    <td align="right" valign="top"><cfset cc_1 = GetContractCost(pm_woid)/>#dollarformat(cc_1)# </td>
    <td align="right" valign="top">
    <cfset partU1 = GetPartsUsed(pm_woid)/>#dollarformat(partU1)#
    </td>
    <td align="right" valign="top">#dollarformat(<!---lprice+--->partU1+cc_1)#</td>
  </tr>
  <tr>
    <td align="right" valign="top">Non PM Task completed:&nbsp;&nbsp;&nbsp;</td>
    <td align="center" valign="top">#close_m_count#</td>
    <td align="center" valign="top"><cfset m_h = GetManHours(m_woid)/>#m_h#</td>
    <!---<td align="right" valign="top"><cfset lprice2 = HOURLY_RATE*m_h/>
      #dollarformat(lprice2)#
    </td>--->
    <td align="right" valign="top"><cfset cc_2 = GetContractCost(m_woid)/>#dollarformat(cc_2)#</td>
    <td align="right" valign="top"><cfset partU2 = GetPartsUsed(m_woid)/>#dollarformat(partU2)#</td>
    <td align="right" valign="top">#dollarformat(<!---lprice2+--->partU2+cc_2)#</td>
  </tr>
  <tr>
    <td align="right" valign="top">Total for jobs completed:&nbsp;&nbsp;&nbsp;</td>
    <td align="center" valign="top">#close_pm_count+close_m_count#</td>
    <td align="center" valign="top">#m_h+pm_h#</td>
    <!---<td align="right" valign="top">#dollarformat(lprice2+lprice)#</td>--->
    <td align="right" valign="top"><cfset cc_tt = cc_1+cc_2/>#DollarFormat(cc_tt)#</td>
    <td align="right" valign="top">#dollarformat(partU1+partU2)#</td>
    <td align="right" valign="top">
        <cfset cum_1 =<!---lprice2+lprice+--->partU1+partU2+cc_tt/> 
    <b>#dollarformat(cum_1)#</b></td>
  </tr>

  </table> 
  <br>
  <cfquery name="qCost">
        SELECT
        wo.WorkOrderId, wo.Description,
        Sum(if(w.Currency = "USD",wi.Quantity*w.UnitPrice,0)) AS USD,
        Sum(if(w.Currency = "NGN",wi.Quantity*w.UnitPrice,0)) AS NGN1,
        Sum(if(wi.ItemId IS NULL,wi.Quantity*wi.UnitPrice,0)) AS NGN2,
        Sum(if(c.Currency = "USD",c.Cost,0)) AS ContractINUSD,
        Sum(if(c.Currency = "NGN",c.Cost,0)) AS ContractINNGN,
        DATE_FORMAT(wo.DateOpened,'%b - %y') AS Months,
        jc.Class, CONCAT(NULLIF(core_user.Surname,''),' ',NULLIF(core_user.OtherNames,'')) AS CreatedBy
        FROM
        work_order_item AS wi
        LEFT JOIN whs_item AS w ON wi.ItemId = w.ItemId
        LEFT JOIN work_order AS wo ON wi.WorkOrderId = wo.WorkOrderId
        INNER JOIN job_class AS jc ON wo.WorkClassId = jc.JobClassId
        LEFT JOIN core_user ON wo.CreatedByUserId = core_user.UserId
        LEFT JOIN contract AS c ON c.WorkOrderId = wi.WorkOrderId
        WHERE wo.UnitId IN (#mtnid#) AND wo.Status = 'Close' AND 
        wo.DateOpened BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#startd#"/> AND <cfqueryparam cfsqltype="cf_sql_date" value="#endd#"/>
        GROUP BY DATE_FORMAT(wo.DateOpened,'%Y %m')
  </cfquery>
  
  
  <table width="60%">
  	<tr>
    	<th>Cost Comparison</th>
    </tr>
    <tr>
    	<td>
            <c:Chart caption="" width="840" height="210" type="MSColumn2DLineDY" PYAxisName="Cost Per Month ($)">
                <c:Categories>
                    <cfloop query="qCost">
                    	<c:category name="#Months#"/>
                    </cfloop>
                </c:Categories> 
                <c:dataset seriesName="Period" color="AFD8F8" showValues="1" numberSuffix="%25">
                    <cfloop query="qCost">
						<cfset usd1 = USD + ContractINUSD>
                        <cfset ngn = NGN1 + NGN2 + ContractINNGN>
                        <cfif usd1 eq ""><cfset usd = 0></cfif>
                        <cfif ngn eq ""><cfset ngn1 = 0></cfif>
                        <cfset tcost = usd1 + ((ngn) / EXCHANGE_RATE) />
                        
                        <c:set value="#tcost#"/>
                    </cfloop>
                     
                </c:dataset>
            </c:Chart>
        </td>
    </tr>
    <tr>
    	<td>
                <strong>Break Down Details ($)</strong>,<br>
        	<cfloop query="qCost">
				<cfset usd1 = USD + ContractINUSD>
                <cfset ngn = NGN1 + NGN2 + ContractINNGN>
                <cfif usd1 eq ""><cfset usd = 0></cfif>
                <cfif ngn eq ""><cfset ngn1 = 0></cfif>
                <cfset tcost = usd1 + (ngn / EXCHANGE_RATE)/>
                <strong>#Months#</strong>: <a href="cost_break_down.cfm?r=#EXCHANGE_RATE#&m=#Months#" target="_blank" style=" text-decoration:none">#NumberFormat(tcost,"$9,999.99")#</a> &nbsp;&nbsp;
            </cfloop>
        </td>
    </tr>
  </table>
  
    <BR/><BR/>
    </td>
</tr>
 
<tr>
  <td class="noline" align="center">
<br>
  </td>
</tr>
</table>

<p class="page_break"></p>



<cfquery name="qWO">
    SELECT 
        w.*, 
        u.Name Unit,
        a.Description Asset,
        jc.Code WorkClass, jc.Class WorkClassName
    FROM work_order w
    INNER JOIN core_unit u ON u.UnitId = w.UnitId
    INNER JOIN asset a ON a.AssetId = w.AssetId
    INNER JOIN job_class jc ON jc.JobClassId = w.WorkClassId
    WHERE w.DateOpened >= <cfqueryparam cfsqltype="cf_sql_date" value="#startd#"/>
        AND w.DateOpened <= <cfqueryparam cfsqltype="cf_sql_date" value="#endd#"/>
        AND w.DepartmentId = 16 AND w.UnitId IN (#mtnid#)
</cfquery>

<cfquery name="qU" dbtype="query">
    SELECT UnitId, Unit FROM qWO
    GROUP BY UnitId, Unit
</cfquery>

<!--- work class legend --->
<cfquery name="qWC" dbtype="query">
    SELECT WorkClass, WorkClassName FROM qWO
    GROUP BY WorkClass, WorkClassName
</cfquery>
<small style="line-height:15px;"><strong>Work class legend:</strong> <cfloop query="qWC"> #WorkClass#: #WorkClassName# <cfif recordcount neq currentrow>,</cfif> </cfloop></small>
<br/>
<hr/>
<br/>
<cfloop query="qU">
    <h2>#qU.Unit#</h2><br/>
<cfquery name="qWOC" dbtype="query">
    SELECT * FROM qWO WHERE UnitId = #qU.UnitId#
</cfquery>
<table width="100%" border="0" cellpadding="0" cellspacing="0" >
    <thead>
        <tr>
            <th>S/N</th>
            <th>WO ##</th>
            <th align=""left>Asset</th>
            <th align="left">Task</th>
            <th>Class</th>
            <th>Status</th>
        </tr>
    </thead>
    <tbody>
        <cfloop query="qWOC">
            <tr>
                <td valign="top">#qWOC.Currentrow#</td>
                <td valign="top">
                    <a target="_blank" href="print_workorder.cfm?id=#qWOC.WorkOrderId#">#qWOC.WorkOrderId#</a>
                </td>
                <td valign="top">#qWOC.Asset#</td>
                <td valign="top">#qWOC.Description#</td>
                <td valign="top" title="#qWOC.WorkClassName#">#qWOC.WorkClass#</td>
                <td valign="top">
                    <cfif qWOC.Status eq "Close">
                        <span class="red">Close</sapn>
                    <cfelseif qWOC.Status eq "Open">
                        <span class="green">Open</span>
                    <cfelse>
                        <span class="orange">#qWOC.Status#</span>
                    </cfif>
                </td>
            </tr>
        </cfloop>
    </tbody>
</table>
<p class="page_break"></p>

</cfloop>


</body>
</html>

<cffunction name="GetContractCost" access="private" returntype="numeric">
    <cfargument name="id" type="string" required="yes"/>
    
   	<cfset var temp = 0/>
    <cfif arguments.id neq "">
    
        <cfquery name="q">
            SELECT SUM(Cost/#EXCHANGE_RATE#) Total FROM contract c
            INNER JOIN work_order w ON w.WorkOrderId = c.WorkOrderId
            WHERE c.WorkOrderId IN (#arguments.id#)            
            AND w.Status = "Close"
        </cfquery>
		<cfset temp = val(q.Total)/> 
    
    </cfif>	
    
	<cfreturn temp/>
</cffunction>

<cffunction name="GetManHours" access="private" returntype="numeric">
    <cfargument name="id" type="string" required="yes"/>
   	<cfset var temp = 0/>
    <cfif arguments.id neq "">
    
        <cfquery name="q_">
            SELECT SUM(l.Hours) Hr FROM labour l
            INNER JOIN work_order w ON w.WorkOrderId = l.WorkOrderId
            WHERE l.WorkOrderId IN (#arguments.id#)
            AND w.Status = "Close"
        </cfquery>
		<cfset temp = val(q_.Hr)/> 
    
    </cfif>	
    
	<cfreturn temp/>
</cffunction>

<cffunction name="GetPartsUsed" access="private" returntype="string">
	<cfargument name="wo" type="string" required="yes" hint="list of workorder ids" />
    
    <cfset var temp =0/>
    
    <cfif arguments.wo neq "">
        <cfquery name="qW">
            SELECT 
            	SUM(i.UnitPrice*wi.Quantity) T, i.Currency
            FROM work_order_item wi
            INNER JOIN whs_item i ON i.ItemId = wi.ItemId
            INNER JOIN work_order w ON w.WorkOrderId = wi.WorkOrderId
            WHERE w.WorkOrderId IN (#arguments.wo#)
            GROUP BY i.Currency
        </cfquery>
        <cfloop query="qW">
        	<cfif qW.Currency eq "NGN">
            	<cfset temp = temp + (qW.T / EXCHANGE_RATE)/>
            <cfelse>
            	<cfset temp = temp + qW.T/>
            </cfif>
        </cfloop>
    </cfif>
    
    <cfreturn temp/>
</cffunction>

</cfoutput>