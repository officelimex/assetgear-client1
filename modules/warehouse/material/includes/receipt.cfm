<cfoutput> 
<cfloop from="1" to="1" index="m">
<!---- qR1 : from cover page --->
 <h3 align="center">Warehouse Receipts &mdash; From old MR</h3>
 <br /> 

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <th>Recipt ##</th>
    <th>Date</th>
    <th>Description</th>
    <th>Reference</th>
    <th style="text-align:right;">Qty</th>
    <th style="text-align:right;">N</th>
    <th style="text-align:right;">$</th>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>

<cfset usdValue = ngnValue = 0/> 
    <cfloop query="qR1">
  <tr>
    <td valign="top" class="noline">#MaterialReceivedId#</td>
    <td valign="top" class="noline">#Dateformat(date,'dd-mmm-yyyy')#</td>
    <td valign="top" class="noline">#Item#</td>
    <td valign="top" class="noline" >#Reference#</td>
    <td style="text-align:right;" class="noline" >#Quantity#</td>
    <td style="text-align:right;" valign="top" class="noline">
	<cfif currency eq "NGN"><cfset ngnValue = TVal + ngnValue />#numberformat(TVal,'9,999.99')#</cfif></td>
    <td style="text-align:right;" valign="top" class="noline">
    
    <cfif currency eq "USD"><cfset usdValue = TVal + usdValue />#Dollarformat(TVal)#</cfif></td>
  </tr>
  </cfloop>
    <tr>
      <td class="noline">&nbsp;</td>
      <td class="noline">&nbsp;</td>
      <td class="noline">&nbsp;</td>
      <td class="noline">&nbsp;</td>
      <td class="noline" align="right">&nbsp;</td>
      <td >&nbsp;</td>
      <td >&nbsp;</td>
    </tr>
    <tr>
    <td class="noline">&nbsp;</td>
    <td class="noline">&nbsp; </td>
    <td class="noline">&nbsp;</td>
    <td class="noline">&nbsp;</td>
    <td class="noline" align="right">Total</td>
    <td style="padding:10px; font-size:15px; font-weight:bold;;text-align:right;" align="right">N#NumberFormat(ngnValue,'9,999.99')#</td>
    <td style="padding:10px; font-size:15px; font-weight:bold;text-align:right;">#dollarFormat(usdValue)#</td>
  </tr>
 
<cfset iValue = 0/>
 
  </table>
  


<cfset gtotal = ivalue+usdValue/>
<cfdocumentitem type="pagebreak"/>
</cfloop>
</cfoutput>
