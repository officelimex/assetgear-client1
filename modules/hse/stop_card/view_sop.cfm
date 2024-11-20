<cfoutput>

<cfparam default="0" name="url.id"/>

<cfparam name="url.cid" default=""/>
<cfparam name="url.r" default=""/>
<cfset spCD = "__stop_card_c_all_stop_card#url.cid#" & url.id/>

<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />

<cfSet qSR = application.com.WorkOrder.GetServiceRequest(url.id)/>


<f:Form id="#spCD#frm" action="">
<cfquery name="qS">
    SELECT
    s.*,CONCAT(s.ObserverSurnameName," ",s.ObserverFirstName) AS Observer,cd.`Name` AS Department,CONCAT(cu.Surname," ",cu.OtherNames) AS CreatedBy
    FROM sop_card AS s
    INNER JOIN core_department AS cd ON s.DepartmentId = cd.DepartmentId
    INNER JOIN core_user AS cu ON cu.UserId = s.CreatedByUserId
    WHERE s.SOPId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td style="vertical-align:bottom !important" >
    	<img src="assets/img/#application.appName#.png"  width="220px"/>
        <div style="font-size:18px" >SOP CARD</div>
    </td>
    <td align="right">CARD ## #url.id#</td>
  </tr>
  <tr>
    <td colspan="2" class="vert-div">&nbsp;</td>
  </tr>
  <tr>
    <td>
		<cfif qS.Acts eq "SafeActs">
            <cfset acts = "Safe Acts"/>
        <cfelseif qS.Acts eq "UnsafeActs">
            <cfset acts = "Unsafe Acts"/>
        <cfelse>
            <cfset acts = "Unsafe Conditions"/>
        </cfif>
        
        <strong><f:label name="Act Type"  value="#Acts#"/></strong>
        
        <cfif qS.Acts eq "SafeActs">
            <cfset ppe = "Correct use of Tools/Equipment,Good procedure, Good behaviour/responsible actions, HSE milestones"/>
        <cfelseif qS.Acts eq "UnsafeActs">
            <cfset ppe = "Improper use of tools/equipment,Improper lifting/stacking/loading,Improper position or posture,Failure to use safe system of work/PTW,Failure to use safety devices,Failure to report incidents,Failure to use the right PPE,Rendering PPE ineffective, Rendering equipment defective,Houseplay,Operating without authorization,Operating at unsafe speed,Under the influence of alcohol or drugs"/>
        <cfelse>
            <cfset ppe = "Unguarded mechinery,Unsafe floor/working surfaces,Fire or explosion hazards,Inadequate housekeeping,Workplace Congestion,Hazardous environment conditions,Spillage,Poor or ecessive illumination,Temperature extremes,Excessive noise,Broken chairs/damaged/faulty equipment"/>
        </cfif>
        
        <cfloop list="#ppe#" index="it" delimiters=",">
            <cfset chk = getCheck(qS.ActDetails,it)/>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="assets/img/ptw_checkbox_#chk#.png" width="10" height="10">&nbsp;&nbsp;#it#<br>
        </cfloop>
    
    </td>
    <td class="horz-div" width="50%" valign="top">
        <f:label name="Date" value="#DateFormat(qS.SOPDate,'dd-mm-yyyy')#"/>
        <f:label name="Location"  value="#qS.Location#"/>
        <f:label name="Observer's Name"  value="#qS.Observer#"/>
        <f:label name="Observation"  value="#qS.Observation#"/>
        <f:label name="Immediate Corrective Actions"  value="#qS.ImmediateAction#"/>
        <f:label name="Further Corrective/Preventive Action Required"  value="#qS.FurtherCorrection#"/>
    </td>
  </tr>
  <tr>
    <td colspan="2" class="vert-div">&nbsp;</td>
  </tr>
</table>
</f:Form>
</cfoutput>

<cffunction name="getCheck" access="private" returntype="string">
	<cfargument name="lst1" type="string" required="yes"/>
    <cfargument name="vl" type="string" required="yes"/>
    
	<cfset var chk = 0/>
    <cfif ListFindNoCase(arguments.lst1,arguments.vl)>
        <cfset chk=1/>
    </cfif>	
    
    <cfreturn chk/>
</cffunction>