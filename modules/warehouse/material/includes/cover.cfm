<cfoutput>
<table width="100%" border="0" cellspacing="2" cellpadding="2" class="cover">
  <tr>
    <td><h2 align="center">Warehouse Report<div align="center">Period Ended: #Dateformat(eDate,'dd. mmmm, yyyy')#</div></h2></td>
  </tr>
  <tr>
    <td></td>
  </tr>
</table>
<br />
<br />

<table width="600" align="center" border="0" cellspacing="2" cellpadding="2">

  <tr>
    <td width="20" class="noline">&nbsp;</td>
    <td width="275" height="32" class="noline">&nbsp;</td>
    <td width="125" align="right" class="noline">&nbsp;</td>
    <td width="52" align="right" class="noline">&nbsp;</td>
    <td width="50" align="right" class="noline">&nbsp;</td>
    <td width="40" align="right" class="noline">&nbsp;</td>
  </tr>
  <tr>
    <td class="noline">&nbsp;</td>
    <td class="noline">BEGINNING BALANCE</td>
    <td align="right" nowrap="nowrap" class="noline">&nbsp;</td>
    <td align="right" nowrap="nowrap" class="noline">&nbsp;</td>
    <td align="right" nowrap="nowrap" class="noline"><strong>N#Numberformat(0,'9,999.99')#</strong></td>
    <td align="right" nowrap="nowrap" class="noline"><strong>&nbsp;&nbsp;&nbsp;&nbsp;#Numberformat(0,'$9,999.99')#</strong></td>
  </tr>
  <tr>
    <td  height="64" colspan="2" class="noline"><strong>MATERIAL RECEIVED INTO WAREHOUSE :</strong></td>
    <td  align="right" nowrap="nowrap" class="noline">&nbsp;</td>
    <td  align="right" nowrap="nowrap" class="noline">&nbsp;</td>
    <td align="right" nowrap="nowrap"  class="noline">&nbsp;</td>
    <td align="right" nowrap="nowrap"  class="noline">&nbsp;</td>
  </tr>
  <tr>
    <td class="noline">&nbsp;</td>
    <td class="noline" height="38">INTERNATIONAL PURCHASE</td>
    <td align="right" nowrap="nowrap"  class="noline">N#NumberFormat(0,'9,999.99')#</td>
    <td align="right" nowrap="nowrap"  class="noline">


&nbsp;&nbsp;&nbsp;&nbsp;#NumberFormat(0,'$9,999.99')#</td>
    <td align="right" nowrap="nowrap"  class="noline">&nbsp;</td>
    <td align="right" nowrap="nowrap"  class="noline">&nbsp;</td>
  </tr>
  <tr>
    <td  class="noline">&nbsp;</td>
    <td  class="noline" height="37">LOCAL PURCHASE</td>
    <td  align="right" nowrap="nowrap" class="noline">N#NumberFormat(0,'9,999.99')#</td>
    <td  align="right" nowrap="nowrap" class="noline">&nbsp;&nbsp;&nbsp;&nbsp;#NumberFormat(0,'$9,999.99')#</td>
    <td  align="right" nowrap="nowrap" class="noline">&nbsp;</td>
    <td  align="right" nowrap="nowrap" class="noline">&nbsp;</td>
  </tr>
  <tr>
<cfquery name="qR1">
	SELECT
    	r.MaterialReceivedId, r.Date,
    	SUM(ri.Quantity*ri.UnitPrice) TVal, ri.Currency, ri.Reference, ri.Quantity, ri.UnitPrice,
        i.Description Item
    FROM whs_material_received r
    INNER JOIN whs_material_received_item ri ON (r.MaterialReceivedId = ri.MaterialReceivedId)
	INNER JOIN whs_item i ON (i.ItemId = ri.ItemId)
    WHERE r.Date >= <cfqueryparam cfsqltype="cf_sql_date" value="#sDate#"/>
    	 AND r.Date <= <cfqueryparam cfsqltype="cf_sql_date" value="#eDate#"/>
       AND i.Obsolete = "No" AND i.Status <> "Deleted"
    GROUP BY ri.MaterialReceivedItemId
</cfquery>
<cfquery name="qR2" dbtype="query">
	SELECT SUM(TVal) T FROM qR1
    WHERE Currency = 'NGN'
</cfquery>
<cfquery name="qR3" dbtype="query">
	SELECT SUM(TVal) T FROM qR1
    WHERE Currency = 'USD'
</cfquery>
    <td class="noline" align="left">&nbsp;</td>
    <td class="noline"  height="37" align="left">STOCK RECIVED FROM OLD M.R.</td>
    <td  align="right" nowrap="nowrap">N#NumberFormat(qR2.T,'9,999.99')#</td>
    <td  align="right" nowrap="nowrap">

    &nbsp;&nbsp;&nbsp;&nbsp;#dollarFormat(qR3.T)#</td>
    <td align="right" nowrap="nowrap" class="noline">&nbsp;</td>
    <td align="right" nowrap="nowrap" class="noline">&nbsp;</td>
  </tr>
  <tr>
    <td class="noline" align="center">&nbsp;</td>
    <td class="noline"  height="37" align="center">TOTAL</td>
    <td  align="right" nowrap="nowrap" class="noline">N#NumberFormat(0,'9,999.99')#</td>
    <td  align="right" nowrap="nowrap" class="noline">&nbsp;&nbsp;&nbsp;&nbsp;#NumberFormat(0,'$9,999.99')#</td>
    <td align="right" nowrap="nowrap" class="noline">&nbsp;</td>
    <td align="right" nowrap="nowrap"  class="noline">&nbsp;</td>
  </tr>
  <tr>
    <td class="noline">&nbsp;</td>
    <td class="noline" height="37">TOTAL RECEIPT</td>
    <td align="right" nowrap="nowrap" class="noline">&nbsp;</td>
    <td align="right" nowrap="nowrap" class="noline">&nbsp;</td>
    <td  align="right" nowrap="nowrap">N#NumberFormat(qR2.T,'9,999.99')#</td>
    <td  align="right" nowrap="nowrap">#NumberFormat(0,'$9,999.99')#</td>
  </tr>
  <tr>
    <td class="noline">&nbsp;</td>
    <td class="noline" height="48">BEGINNING BALANCE PLUS RECEIPT</td>
    <td align="right" nowrap="nowrap"  class="noline">&nbsp;</td>
    <td align="right" nowrap="nowrap"  class="noline">&nbsp;</td>
    <td align="right" nowrap="nowrap"  class="noline">

    N#NumberFormat(0,'9,999.99')#</td>
    <td align="right" nowrap="nowrap"  class="noline">#NumberFormat(0,'$9,999.99')#</td>
  </tr>
  <tr>
    <td height="48" colspan="2"  class="noline"><strong>MATERIAL ISSUED FROM WAREHOUSE</strong></td>
    <td align="right" nowrap="nowrap" class="noline">&nbsp;</td>
    <td align="right" nowrap="nowrap" class="noline">&nbsp;</td>
    <td align="right" nowrap="nowrap" class="noline">&nbsp;</td>
    <td align="right" nowrap="nowrap" class="noline">&nbsp;</td>
  </tr>
  <tr>
    <td class="noline">&nbsp;</td>
<cfquery name="qI">
	SELECT
    	SUM(Quantity*UnitPrice) TVal, ii.Currency, i.DepartmentId FROM
    whs_issue_item ii
    INNER JOIN whs_issue i ON (i.IssueId = ii.IssueId)
    WHERE i.DateIssued >= <cfqueryparam cfsqltype="cf_sql_date" value="#sDate#"/>
    	 AND i.DateIssued <= <cfqueryparam cfsqltype="cf_sql_date" value="#eDate#"/>
    GROUP BY ii.ItemIssueId
</cfquery>
<cfquery name="qI1" dbtype="query">
	SELECT SUM(TVal) T FROM qI
    WHERE Currency = 'NGN' AND DepartmentId <> 10
</cfquery>
<cfquery name="qI2" dbtype="query">
	SELECT SUM(TVal) T FROM qI
    WHERE Currency = 'USD' AND DepartmentId <> 10
</cfquery>
<cfquery name="qI3" dbtype="query">
	SELECT SUM(TVal) T FROM qI
    WHERE Currency = 'NGN' AND DepartmentId = 10
</cfquery>
<cfquery name="qI4" dbtype="query">
	SELECT SUM(TVal) T FROM qI
    WHERE Currency = 'USD' AND DepartmentId = 10
</cfquery>
    <td class="noline" height="37">ISSUES TO DEPARTMENTS</td>
    <td align="right" nowrap="nowrap" class="noline">N#NumberFormat(qI1.T,'9,999.99')#</td>
    <td align="right" nowrap="nowrap" class="noline">&nbsp;&nbsp;&nbsp;&nbsp;#DollarFormat(qI2.T)#</td>
    <td align="right" nowrap="nowrap" class="noline">&nbsp;</td>
    <td align="right" nowrap="nowrap" class="noline">&nbsp;</td>
  </tr>
  <tr>
    <td class="noline">&nbsp;</td>
    <td class="noline" height="39"> ISSUES FOR PROJECT PURPOSE</td>
    <td align="right" nowrap="nowrap">N#NumberFormat(qI3.T,'9,999.99')#</td>
    <td align="right" nowrap="nowrap">&nbsp;&nbsp;&nbsp;&nbsp;#DollarFormat(qI4.T)#</td>
    <td align="right" nowrap="nowrap" class="noline">&nbsp;</td>
    <td align="right" nowrap="nowrap" class="noline">&nbsp;</td>
  </tr>
  <tr>
    <td class="noline" align="center">&nbsp;</td>
    <td class="noline" height="48" align="center">TOTAL</td>
    <cfset trN = val(qI1.T)+val(qI3.T)/>
    <cfset trD = val(qI2.T)+val(qI4.T)/>
    <td align="right" nowrap="nowrap" class="noline">N#NumberFormat(trN,'9,999.99')#</td>
    <td align="right" nowrap="nowrap" class="noline">#DollarFormat(trD)#</td>
    <td align="right" nowrap="nowrap" class="noline">&nbsp;</td>
    <td align="right" nowrap="nowrap" class="noline">&nbsp;</td>
  </tr>
  <tr>
    <td class="noline">&nbsp;</td>
    <td class="noline" height="48">LESS RETURN TO STOCK</td>
    <td align="right" nowrap="nowrap" class="noline">N 0.00</td>
    <td align="right" nowrap="nowrap" class="noline"> $ 0.00</td>
    <td align="right" nowrap="nowrap" class="noline">&nbsp;</td>
    <td align="right" nowrap="nowrap" class="noline">&nbsp;</td>
  </tr>
  <tr>
    <td class="noline" align="center">&nbsp;</td>
    <td class="noline" height="48" align="center">TOTAL ISSUE</td>
    <td align="right" nowrap="nowrap" class="noline">&nbsp;</td>
    <td align="right" nowrap="nowrap" class="noline">&nbsp;</td>
    <td  align="right" nowrap="nowrap">N<span class="noline">#NumberFormat(trN,'9,999.99')#</span></td>
    <td  align="right" nowrap="nowrap"><span class="noline">#DollarFormat(trD)#</span></td>
  </tr>
  <tr>
    <td class="noline">&nbsp;</td>
    <td class="noline" height="48"><strong>ENDING BALANCE</strong></td>
    <td align="right" nowrap="nowrap" class="noline">&nbsp;</td>
    <td align="right" nowrap="nowrap" class="noline">&nbsp;</td>

    <td align="right" nowrap="nowrap" class="noline"><strong>N#NumberFormat(0,'9,999.99')#</strong></td>
    <td align="right" nowrap="nowrap" class="noline"><strong>&nbsp;&nbsp;&nbsp;&nbsp;#NumberFormat(0,'$9,999.99')#</strong></td>
  </tr>
</table>
</cfoutput>
