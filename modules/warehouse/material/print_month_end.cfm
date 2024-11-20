<cfoutput>
<cfdocument pagetype="a4" format="pdf" margintop="0.25" marginbottom="0" marginleft="0.4" marginright="0.4">
<html>
<head>
<style>
body{background: ##FFF;} body,table{ font:11px Arial;} th{ text-align:left;background:##eee;border-bottom:2px ##333 solid;padding-left:1px; padding-bottom:2px; padding-top:3px;}
td{ border-bottom:1px solid ##CCC; padding:1px; } table.cover td{ border-bottom:1px solid ##CCC; padding:4px 50px; } th,td{ padding-left:2px;  }
.header{text-decoration:underline;text-align:center;font-weight:bold;font-size:13px;padding-bottom:10px;display:block;text-transform:uppercase;}
td.noline	{ border-style: none; border:none;} h2 div{font-size:14px; text-align:center; display:block;} .ftr{padding:2px; margin-right:10px;}
.ftr span{padding:0px 10px;} h2{margin:0px; font-size:25px;}
</style>
<cfset form.Date_ = dateformat(now(),'yyyy/mm/01')/>
<cfset medate = dateformat(form.Date_,'yyyy/mm/')/>

<cfset sDate = Left(medate,8) & "01"/>	<cfset eDate = Left(medate,8) & DaysInMonth(form.Date_)/>
<cfset form.From_ = sDate/>
<cfset form.To_ = eDate />

<cfquery name="qME">
    SELECT * FROM whs_month_end
    WHERE Date = <cfqueryparam cfsqltype="cf_sql_date" value="#eDate#"/>
</cfquery>
</head>
<body>
<table width="100%">
<tr>
<td class="noline">
<cfdocumentitem type="header">
<cfset request.letterhead.title="WHAREHOUSE REPORT"/>
<cfset request.letterhead.Id=""/>
<cfset request.letterhead.date = "Period Ended: #dateformat(form.Date_,'mmmm, yyyy')#"/>
<cfinclude template="../../../include/letter_head.cfm"/>
</cfdocumentitem>

<cfinclude template="includes/cover.cfm"/>

<!---<cfdocumentitem type="pagebreak"/>
<cfinclude template="include/swr-i.cfm"/>

<cfdocumentitem type="pagebreak"/>
<cfinclude template="include/swr-l.cfm"/>

<cfdocumentitem type="pagebreak"/>
<cfinclude template="include/swr-t.cfm"/>--->

<cfdocumentitem type="pagebreak"/>
<cfinclude template="includes/issues-s.cfm"/>

<cfdocumentitem type="pagebreak"/>
<cfinclude template="includes/receipt.cfm"/>

<!---cfdocumentitem type="pagebreak"/>
<cfinclude template="include/await-i.cfm"/>--->
<cfquery name = "qWhsValue" >
    SELECT Currency,SUM(UnitPrice*QOH) AS Amount FROM `whs_item` GROUP BY Currency;
</cfquery>

<h3 align="center">Warehouse Value</h3>
<br>
<table width="450px">
  <tr>
    <cfloop query = "qWhsValue" >
        <cfif currency neq "">
          <th>
            #Currency#
          </th>
        </cfif>
    </cfloop>
  </tr>
  <tr>
    <cfloop query = "qWhsValue" >
      <cfif currency neq "">
          <td>
            #numberformat(Amount,"9,999.99")#
          </td>
      </cfif>
    </cfloop>
  </tr>
</table>
<cfdocumentitem type="footer" >
    <div style="border-top:##ccc solid 2px; padding:5px; ">
    <div style="font:11px Arial;float:left;">Warehouse Report</div>
    <div style="font:11px Arial;float:right; clear:left;">#cfdocument.currentpagenumber# of #cfdocument.totalpagecount#</div>
    </div>
</cfdocumentitem>
</td></tr></table>
</cfdocument>
</cfoutput>
