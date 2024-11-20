<cfoutput>
<h3 align="center">Issues to Departments &mdash; Summary</h3><br />

<table width="100%" border="0" cellpadding="0" cellspacing="0" >
  <tr>
    <th width="8%" align="left">EFN</th>
    <th width="45%" align="left">Department</th>
    <th width="24%" style="text-align:right;">Amount (N)</th>
    <th width="23%" style="text-align:right;"> Amount ($)</th>
    </tr>  
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
    </tr>
<cfquery name="qD">
	SELECT 
    	SUM(i.USDTotal) USDT, SUM(i.NGNTotal) NGNT,
        d.Name Department
    FROM whs_issue i
    INNER JOIN core_department d ON (d.DepartmentId = i.DepartmentId)
    WHERE i.DateIssued >= <cfqueryparam cfsqltype="cf_sql_date" value="#sDate#"/>
    	 AND i.DateIssued <= <cfqueryparam cfsqltype="cf_sql_date" value="#eDate#"/>    
    GROUP BY i.DepartmentId
</cfquery>    
    <cfset td = tn = 0/>
    <cfloop query="qD">
  <tr>
    <td height="27" valign="middle">#qD.currentrow#</td>
    <td valign="middle">#ucase(Department)#</td>
    <td align="right" valign="middle">N #NumberFormat(qD.NGNT,'9,999.99')#</td>
    <td align="right" valign="middle"> 
    	#DollarFormat(qD.USDT)#
        <cfset td = td + qD.USDT/>
        <cfset tn = tn + qD.NGNT/>
    </td>
  </tr>
   </cfloop>
  <tr>
    <td height="29" valign="top" class="noline">&nbsp;</td>
    <td align="right" valign="middle" class="noline">&nbsp;</td>
    <td align="right" valign="middle"><div style="font:15 bold;">N#Numberformat(tn,'9,999.99')#</div></td>
    <td align="right" valign="middle"><div style="font:15 bold;">#DollarFormat(td)#</div></td>
  </tr>
   
   
</table>
</cfoutput>