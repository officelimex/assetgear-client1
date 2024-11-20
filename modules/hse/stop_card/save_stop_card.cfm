<!---
	Author: Daniel Udeme
	Created: 2016/10/10
	Modified: 2016/10/10
	->
--->
<cfparam default="0" name="url.id"/>
<cfparam default="" name="url.cid"/>

<cfif url.id eq 0><br /></cfif>
<cfset spCD = '__stop_card_c_all_stop_card#url.cid#' & url.id/>

<cfoutput>
    <cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />

    <!--- QUERIES --->
  <cfquery name = "qS" >
      SELECT * FROM sop_card
      WHERE SOPId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
  </cfquery>
  <cfquery name = "qD" >
      SELECT * FROM core_department
      ORDER BY Name
  </cfquery>
  <cfquery name = "qU" >
      SELECT UserId,CONCAT(Surname," ",OtherNames) AS Names FROM core_user
  </cfquery>

<style>
	.pad35	{padding:35px;}
</style>

    <f:Form id="#spCD#frm" action="modules/ajax/hse.cfm?cmd=SaveSOPCard" EditId="#url.id#">
        <table width="100%" cellpadding="0" cellspacing="0">
        	<tr>
            	<td valign="top">
                	<table width="100%">
                    	<tr valign="top">
                        	<td valign="top">
                              <f:select name="Site" label="Site Location" required Listvalue="Kwale,Lagos" listDisplay="Kwale Location,Lagos Office" Selected="#qS.Site#"/>
                              <f:Select name="departmentId" required label="Observer's Department" ListValue="#Valuelist(qD.DepartmentId,'`')#" ListDisplay="#Valuelist(qD.Name,'`')#" class="span11" Selected="#qS.DepartmentId#" delimiters="`"/>
                              <f:select name="Acts" label="Act Category" required Listvalue="SafeActs,UnsafeActs,UnsafeConditions" listDisplay="Safe Act,Unsafe Act,Unsafe Condiction" Selected="#qS.Acts#" onchange="#spCD#changePT(this)"/>
                            </td>
                        </tr>
                    	<tr>
                        	<td valign="top">
                                 <div id="#spCD#1" style="display:<cfif qS.Acts eq "SafeActs">block<cfelse>none</cfif>" >
                                 	<f:CheckBox name="ActDetails" selected="#qS.ActDetails#" width="auto" height="auto" style="margin-left:90px !important" ListValue="Correct use of Tools/Equipment,Good procedure,Good behaviour/responsible actions,HSE milestones"  delimiter="'"/>
                                 </div>
                                 <div id="#spCD#2" style="display:<cfif qS.Acts eq "UnsafeActs">block<cfelse>none</cfif>">
                                 	<f:CheckBox  name="ActDetails" selected="#qS.ActDetails#" width="auto" height="auto" style="margin-left:90px !important" ListValue="Improper use of tools/equipment,Improper lifting/stacking/loading,Improper position or posture,Failure to use safe system of work/PTW,Failure to use safety devices,Failure to report incidents,Failure to use the right PPE,Rendering PPE ineffective,Rendering equipment defective,Houseplay,Operating without authorization,Operating at unsafe speed,Under the influence of alcohol or drugs" delimiter="'"/>
                                 </div>
                                 <div id="#spCD#3" style="display:<cfif qS.Acts eq "UnsafeConditions">block<cfelse>none</cfif>">
                                 	<f:CheckBox name="ActDetails" selected="#qS.ActDetails#" width="auto" height="auto" style="margin-left:90px !important" ListValue="Unguarded mechinery,Unsafe floor/working surfaces,Fire or explosion hazards,Inadequate housekeeping,Workplace Congestion,Hazardous environment conditions,Spillage,Poor or ecessive illumination,Temperature extremes,Excessive noise,Broken chairs/damaged/faulty equipment"  delimiter="'"/>
                                 </div>
                            </td>
                        </tr>
                    
                    </table>
                </td>
            	<td style="border-left:##777575 solid 1px" width="50%" valign="top">
                	<table width="100%">
                    	<tr>
                        	<td valign="top">
                                <f:TextArea required name="Observation" label="Observation" help="" value="#qS.Observation#" class="span11" rows="2"/>
                                <f:TextArea  name="ImmediateAction" label="Immediate Corrective Actions" help="" value="#qS.ImmediateAction#" class="span11" rows="2"/>
                                <f:TextArea  name="FurtherCorrection" label="Further Corrective/Preventive Action Required" help="" value="#qS.FurtherCorrection#" class="span11" rows="3"/>
                                
                            	<f:TextBox required name="ObserverSurnameName" label="Observer's Surname Name" hint=""  value="#qS.ObserverSurnameName#" class="span11"/>
                            	<f:TextBox required name="ObserverFirstName" label="Observer's First Name" hint=""  value="#qS.ObserverFirstName#" class="span11"/>
                            	
                            	<f:TextBox required name="Location" label="Location" hint="Where the observation was made"  value="#qS.Location#" class="span11"/>
                            	<f:DatePicker name="SOPDate" label="Date" required help="" value="#Dateformat(qS.SOPDate,'yyyy-mm-dd')#"/>
                            </td>
                        </tr>
                    </table>
                </td>
                
            </tr>
        </table>

		<cfif url.id eq 0>
            <f:ButtonGroup>
                <f:Button value="Create new SOP Card" class="btn-primary" IsSave subpageId="save_stop_card" ReloadURL="modules/maintenance/stop_card/save_stop_card.cfm"/>
            </f:ButtonGroup>
        </cfif>
    </f:Form>
<script>

</script>
<script>
	function #spCD#changePT(d)	{
		var a1_ = $("#spCD#1"),a2_ = $("#spCD#2"),a3_ = $("#spCD#3");
		if(d.value == 'SafeActs')	{
		 	a1_.setStyle('display','block');
			a2_.setStyle('display','none');
			a3_.setStyle('display','none');
		}
		else if(d.value == 'UnsafeActs'){
		 	a1_.setStyle('display','none');
			a2_.setStyle('display','block');
			a3_.setStyle('display','none');
		}
		else if (d.value == 'UnsafeConditions')	{
		 	a1_.setStyle('display','none');
			a2_.setStyle('display','none');
			a3_.setStyle('display','block');
		}else{
		 	a1_.setStyle('display','none');
			a2_.setStyle('display','none');
			a3_.setStyle('display','none');
		}
	}
</script>
</cfoutput>
