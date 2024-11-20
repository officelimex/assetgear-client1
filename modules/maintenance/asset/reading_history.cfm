<!--- 
	Author: Arowolo Abiodun
	Created: 2011/09/30
	Modified: 2011/09/30
	-> edit a page 
--->
<cfparam default="0" name="url.id"/>
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />

<cfset astcId = '__asset_c_meter_reading' & url.id/>

<cfquery name="qRH">
	#application.com.Asset.METER_READING_HISTORY_SQL#
    WHERE al.AssetLocationId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
    ORDER BY EntryDate DESC
    LIMIT 0, 30
</cfquery> 
 
<cfoutput>
<table class="table">
<thead>
  <tr>
    <th nowrap="nowrap">Rading taken by</th>
    <th>Entry Date</th>
    <th>Readings (#qRH.ReadingTypeCode#)</th>
    <th>Comment/Remark</th>
  </tr>
</thead>
<tbody>
  <cfloop query="qRH">
  <tr>
    <td>#qRH.ReadingBy#</td>
    <td>#dateformat(qRH.EntryDate,'dd-mmm-yyyy')# #timeformat(qRH.EntryDate,'hh:mm tt')#</td>
    <td>#Numberformat(qRH.CurrentReading,'9,999.99')#</td>
    <td class="span5">#qRH.Comment#</td>
  </tr>
  </cfloop>
</tbody>
</table>

</cfoutput>