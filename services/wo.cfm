<cfoutput>
 

    <cfdocument pagetype="a4" format="pdf" margintop="0.25" marginbottom="0" marginleft="0.4" marginright="0.4">
    <html> 
    <head>
    <cfset bg = "##f0f2f8"/>
    <cfset brd_c = "##d6daeb"/>
    <cfset brd_c2 = "##5364a9"/>
    <style type="text/css">	
      body{background: ##FFF;} body,table{ font:12px Arial; line-height:22px; } th{text-align: center;background:##eee;border-bottom:2px ##333 solid;padding-left:1px;} td{ border-bottom:1px solid ##CCC; padding:1px; } th,td{ padding-left:2px;  } .header{text-decoration:underline;text-align:center;font-weight:bold;font-size:13px;padding-bottom:10px;display:block;text-transform:uppercase;} td.noline	{ border: none; } h2 div{font-size:14px; text-align:center; display:block;} .ftr{padding:2px; margin-right:10px;} .ftr span{padding:0px 10px;} .gr{color:gray;} h2{margin:0px;}
    </style>
    </head>
    <body> 
    <cfloop from="1" to="5" index="xx">
      <cfset _year = 2020/>
      <cfset _now = "#_year#/#xx#/1"/>
      <cfset EXCHANGE_RATE = 1000/>
      <cfset dmonth = month(dateAdd('d',1,_now))/>
      <cfset dpart = _year & "/" & dmonth/>
      <cfset startd =  "#dpart#/1">
      <cfset dinmonth = DaysInMonth(startd)/>
      <cfset endd =  "#dpart#/#dinmonth#">
      <cfset ystart = "#_year#/1/1"/>
      
      <cfquery name="qWO">
        #application.com.WorkOrder.WORK_ORDER_SQL#
          WHERE wo.DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.departmentId#"/>
          AND DateOpened >= <cfqueryparam cfsqltype="cf_sql_date" value="#startd#"/>
          AND DateOpened <= <cfqueryparam cfsqltype="cf_sql_date" value="#endd#"/>
      </cfquery>
      <cfset dept = qWO.Department/>
      <cfset pm_count = open_pm_count = close_pm_count = close_m_count = cr_pm_o_count = mi_pm_o_count = ma_pm_o_count = 0/>
      <cfset pm_woid = m_woid = ""/>

      <cfloop query="qWO">
      
        <cfif qWO.WorkClassId == 10>

          <cfset pm_woid = listAppend(pm_woid,qWO.WorkOrderId)/>
          <cfset pm_count++/>
          <cfswitch expression="#qWO.Status#">
            <cfcase value="Critical"><cfset cr_pm_o_count++/></cfcase>
            <cfcase value="Minor"><cfset mi_pm_o_count++/></cfcase>
            <cfcase value="Major"><cfset ma_pm_o_count++/></cfcase>
          </cfswitch> 
          <cfswitch expression="#qWO.Status#">
            <cfcase value="Open"><cfset open_pm_count++/></cfcase>
            <cfcase value="Close"><cfset close_pm_count++/></cfcase>
          </cfswitch>
          
        <cfelse>
            
          <cfset m_woid = ListAppend(m_woid,qWO.WorkOrderId)/>
          <cfset close_m_count++/>
               
        </cfif>
          
      </cfloop>
    <table width="100%">
    <cfset request.letterhead.title="MONTHLY MAINTENANCE REPORT"/>
    <cfset request.letterhead.Id="#dept# Department"/>
    <cfset request.letterhead.date = "Period : #MonthAsString(dmonth)# #_year#"/>
    <cfinclude template="../include/letter_head.cfm"/>
    
    <tr>
      <td class="noline"> 
    <table width="100%" border="0" cellpadding="10" cellspacing="10">
      <tr>
        <td valign="top" class="noline"><table width="100%" border="0" cellpadding="0" cellspacing="0" >
          <tr>
            <th colspan="2" align="center">Planned Maintenance</th>
            <td class="noline"> </td>
            </tr>
          <tr>
            <td>&nbsp;</td>
            <td align="center" valign="top">Count</td>
            <td align="center" class="noline">&nbsp;</td>
            </tr>
          <tr>
            <td align="right" valign="top">PM task planned:&nbsp;&nbsp;&nbsp;</td>
            <td align="center" valign="top">#pm_count#</td>
            <td align="center" class="noline">&nbsp;</td>
            </tr>
          <tr>
            <td align="right" valign="top">PM task still open:&nbsp;&nbsp;&nbsp;</td>
            <td align="center" valign="top">#open_pm_count# </td>
            <td align="center" class="noline">&nbsp;</td>
            </tr>
          <tr>
            <td align="right" valign="top">PM task closed out:&nbsp;&nbsp;&nbsp;</td>
            <td align="center" valign="top">#close_pm_count# </td>
            <td align="center" class="noline">&nbsp;</td>
            </tr>
          <tr>
            <td align="right" valign="top">% Completed:&nbsp;&nbsp;&nbsp;</td> 
            
            <td align="center" valign="top">#NumberFormat(close_pm_count/pm_count*100,'999')#%</td>
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
                WHERE Status = 'part on hold' 
            </cfquery>#qP.Recordcount#        
            </td>
          </tr>
          <tr>
            <td align="right" valign="top">Total  jobs:&nbsp;&nbsp;&nbsp;</td>
            <td align="center" valign="top">#qP.Recordcount+qO.Recordcount+qS.Recordcount#</td>
          </tr>
          </table></td>
      </tr>
    </table><br>
    <br>
      
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td>&nbsp;</td>
        <th colspan="5" align="center">Cost of Maintenance</th>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td align="center">Count</td>
        <td align="center">Man hours</td>
        <td align="right">Labour</td>
        <td align="right">Parts</td>
        <td align="right">Total</td>
      </tr>
      <tr>
        <td align="right" valign="top">PM tasks completed:&nbsp;&nbsp;&nbsp;</td>
        <td align="center" valign="top">#close_pm_count#</td>
        <td align="center" valign="top">
           
          <cfset pm_h = GetManHours(pm_woid)/>#pm_h#
        </td>
        
        <td align="right" valign="top"><cfset lprice = 50*pm_h/>#dollarformat(lprice)#</td>
        <td align="right" valign="top">
        <cfset partU1 = GetPartsUsed(pm_woid)/>#dollarformat(partU1)#
        </td>
        <td align="right" valign="top">#dollarformat(lprice+partU1)#</td>
      </tr>
      <tr>
        <td align="right" valign="top">Non PM Task completed:&nbsp;&nbsp;&nbsp;</td>
        <td align="center" valign="top">#close_m_count#</td>
        <td align="center" valign="top"><cfset m_h = GetManHours(m_woid)/>#m_h#</td>
        <td align="right" valign="top"><cfset lprice2 = 50*m_h/>
          #dollarformat(lprice2)#
        </td>
        <td align="right" valign="top"><cfset partU2 = GetPartsUsed(m_woid)/>#dollarformat(partU2)#</td>
        <td align="right" valign="top">#dollarformat(lprice2+partU2)#</td>
      </tr>
      <tr>
        <td align="right" valign="top">Total for jobs completed:&nbsp;&nbsp;&nbsp;</td>
        <td align="center" valign="top">#close_pm_count+#close_m_count##</td>
        <td align="center" valign="top">#m_h+pm_h#</td>
        <td align="right" valign="top">#dollarformat(lprice2+lprice)#</td>
        <td align="right" valign="top">#dollarformat(partU1+partU2)#</td>
        <td align="right" valign="top">#dollarformat(lprice2+lprice+partU1+partU2)#</td>
      </tr>
      </table> 
      
        <BR/><BR/>
        </td>
    </tr>
     
    <tr>
      <td class="noline" align="center">
    
    <cfquery name="qC1" cachedwithin="#CreateTime(1,0,0)#">
      SELECT 
          DATE_FORMAT(DateOpened,'%M') MonthOpen, DATE_FORMAT(DateOpened,'%c') mc, COUNT(WorkOrderId) WCount 
        FROM work_order
        WHERE DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.departmentId#"/>
          AND Status = "Close"
          AND WorkClassId = 10
            AND DateOpened >= <cfqueryparam cfsqltype="cf_sql_date" value="#ystart#"/>
            AND DateOpened <= <cfqueryparam cfsqltype="cf_sql_date" value="#endd#"/>
        GROUP BY MonthOpen
        ORDER BY mc    
    </cfquery>
    <cfquery name="qC2" cachedwithin="#CreateTime(1,0,0)#">
      SELECT 
          DATE_FORMAT(DateOpened,'%M') MonthOpen, DATE_FORMAT(DateOpened,'%c') mc, COUNT(WorkOrderId) WCount 
        FROM work_order
        WHERE DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.departmentId#"/>
          AND Status = "Close"
          AND WorkClassId <> 10
            AND DateOpened >= <cfqueryparam cfsqltype="cf_sql_date" value="#ystart#"/>
            AND DateOpened <= <cfqueryparam cfsqltype="cf_sql_date" value="#endd#"/>
        GROUP BY MonthOpen
        ORDER BY mc
    </cfquery>
    
    <br>
    <cfchart format="png" scalefrom="0" seriesplacement="stacked" show3d="no" chartwidth="800"> 
        <cfchartseries type="bar" serieslabel="Non PM Task" seriescolor="##ffcc00" query="qC2" itemcolumn="MonthOpen" valuecolumn="WCount"/> 
      <cfchartseries type="bar" serieslabel="PM Task" seriescolor="blue" query="qC1" itemcolumn="MonthOpen" valuecolumn="WCount"/> 
    </cfchart>  
      
    
      </td>
    </tr>
    <cfdocumentitem type="footer">
    <tr><td ><table width="100%" border="0" style="font:9px Tahoma; border-top:1px solid ##ECF4CF; padding-left:15px;">
      <tr>
      <td nowrap="nowrap">
    
    
      </td>
        <td align="right">Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#</td>
    </tr></table></td></tr>
    </cfdocumentitem>
    <cfdocumentitem type="pagebreak">
    </table>
    </cfloop>
    </body>
    </html>
    </cfdocument>
    
    <cffunction name="GetManHours" access="private" returntype="numeric">
        <cfargument name="id" type="string" required="yes"/>
         <cfset var temp = 0/>
        <cfif arguments.id neq "">
        
            <cfquery name="q">
                SELECT SUM(Hours) Hr FROM labour
                WHERE WorkOrderId IN (#arguments.id#)
            </cfquery>
        <cfset temp = val(q.Hr)/> 
        
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