<cfoutput>

<cfimport taglib="../../../../assets/awaf/tags/xUtil/" prefix="util" />

<cfset qP = application.com.Permit.GetPermit(url.id)/>
<cfset qJ = application.com.Permit.GetJHA(qP.JHAId)/>
<cfset qJL = application.com.Permit.GetJHAList(qP.JHAId)/>
<cfset qGT = application.com.Permit.GetGasTest(url.id)/>
<cfset qAL = application.com.Asset.GetAssetLocationInWorkOrder(qP.AssetLocationIds)/>
<cfset qL = application.com.WorkOrder.GetLabourers(val(qP.WorkOrderId))/>
<style>
	.qaz, .qaz dt,.qaz dd{ line-height:25px;}
	.cimg0 img,.cimg1 img { margin-bottom:5px;}.cimg1{color:blue;}
	.r270{-o-transform:rotate(270deg); -moz-transform:rotate(270deg); -webkit-transform:rotate(270deg); font-weight:bold; vertical-align:middle;}
	.divx{text-align:center; padding-bottom:7px; margin-bottom:5px;margin-top:5px; padding-top:3px; text-shadow:white 1px 0 1px; font-weight:bold; background-color:##F9F9F9; border-top:solid 1px ##eee;}
</style>


<div class="qaz">
    <div class="row-fluid">
        <div class="span12"> 
            <div class="row-fluid">
                <div class="span1 r270">Section_1</div>
                <div class="span5">
                    <dl class="dl-horizontal">
                        <dt>Facility/Intallation:</dt>
                        <dd>#qP.Asset#</dd>
                        <dt>Work Description:</dt>
                        <dd>#qP.Work#</dd>
                        <dt>Location:</dt>
                        <dd>#replace(valuelist(qAL.Location),',',', ','all')#</dd>
                        <dt>Time:</dt>
                        <dd>#lcase(Dateformat(qP.StartTime,'dd/mm/yy'))# #lcase(timeformat(qP.StartTime,'hh:mm tt'))# - #lcase(Dateformat(qP.EndTime,'dd/mm/yy'))# #lcase(timeformat(qP.EndTime,'hh:mm tt'))#</dd>
                    </dl>  
                </div>
                <div class="span6">
                    <dl class="dl-horizontal">
                        <dt>Department:</dt>
                        <dd>#qP.Department#</dd>
                        <dt>Contractor:</dt>
                        <dd>#qP.Contractor#-</dd>
                        <dt>Num. of Workers:</dt>
                        <dd><cfif qP.NumberOfWorkers eq 0>#qL.Recordcount#<cfelse>#qP.NumberOfWorkers#</cfif></dd> 
                        <dt>Tools to be used:</dt>
                        <dd>#qJ.EquipmentToUse#</dd>
                    </dl> 
                </div>
            </div>
        </div>
    </div>
    <div class="row-fluid">
    	<div class="span12 divx">&mdash; Safety Precautions to be taking at wotk place &mdash;</div>
    </div>
    <div class="row-fluid">
        <div class="span9"> 
            <div class="row-fluid">
                <div class="span1 r270">Section_2</div>
                <div class="span5">
                	<strong>Facilities to be Isolated by:</strong><br/>
					<cfset ftbib = "Spades or Blinds,Physical seperation,Closed valves,De-energising prim mover"/>
                    <cfloop list="#ftbib#" index="it"> 
                    	<cfset chk = getCheck(qP.SafetyRequirement2,it)/>
                    	<div class="cimg#chk#"><img src="assets/img/ptw_checkbox_#chk#.png" width="9" height="9"> #it#</div> 
                    </cfloop>  
                </div>
                <div class="span6">
                	<strong>Facilities to be prepared by:</strong><br/>
					<cfset ftbib = "Depressurising,Draining / Venting,Steaming,Gas Test"/>
                    <cfloop list="#ftbib#" index="it"> 
                    	<cfset chk = getCheck(qP.SafetyRequirement3,it)/>
                    	<div class="cimg#chk#"><img src="assets/img/ptw_checkbox_#chk#.png" width="9" height="9"> #it#</div> 
                    </cfloop> 
 					<BR/>
                	<strong>Work are to be prepared by:</strong><br/>
					<cfset ftbib = "Temporary demarcation,Temporary road closure,Additional lighting,Scaffolding/Work platform"/>
                    <cfloop list="#ftbib#" index="it"> 
                    	<cfset chk = getCheck(qP.SafetyRequirement4,it)/>
                    	<div class="cimg#chk#"><img src="assets/img/ptw_checkbox_#chk#.png" width="9" height="9"> #it#</div> 
                    </cfloop> 
                </div>
            </div>
            <div class="row-fluid">
            	<div class="span1"></div>
                <div class="span11">
                    <dl class="">
                        <dt>Additional Precautions:</dt>
                        <dd>#qP.AdditionalPrecaution#</dd>
                    </dl>
                 </div>
            </div>            
        </div>
        <div class="span3">
            <strong>PPE:</strong><br/>
      		<cfset ppe = "Coverall,Safety helmet,Safety shoes,Safety goggles,Safety spectacles,Light fumes mask,Breathing apparatus,Plastic gloves,Dotted gloves,Hearing protection,Protective Apron,Rubber boots,Dust mask,Safety hamess,Work vest/life jacket,Self contained BA,Compressor air line"/>
            <cfloop list="#ppe#" index="it"> 
                <cfset chk = getCheck(qP.PPE,it)/>
                <div class="cimg#chk#"><img src="assets/img/ptw_checkbox_#chk#.png" width="9" height="9"> #it#</div> 
            </cfloop> 
        </div>
    </div>
    <div class="row-fluid">
    	<div class="span12 divx">&mdash; Certificates (Indicated as required) &mdash;</div>
    </div>
    
    <div class="row-fluid">
        <div class="span12"> 
            <div class="row-fluid">
                <div class="span1 r270">Section_3</div>
                <div class="span5">  
					<cfset hwp = "HOT WORK PRECAUTION,Wash down area with water,Cover area with sand,Cover area with foam blanket,Shield adjacent areas,Provide trained fire watch,Provide portable fire extinguishers,FIRE to provide additional fire cover,Test area for flammable atmosphere,Gas test prior to commencement of work,Gas test at intervals of..........,Continious gas monitoring,Suspend potentially dangerous activites"/>
                    <cfloop list="#hwp#" index="it">
                    <cfset chk = getCheck(qP.Hotwork,it)/>
                    <div class="cimg#chk#"><img src="assets/img/ptw_checkbox_#chk#.png" width="9" height="9"> #it#</div>
                    </cfloop>
                    <em>Special Precautions:</em> #qP.Custom2#<br /><br />
					<strong>GAS TEST</strong><br/>
                    The area was tested by me with the following results:
                    <table class="table table-striped table-bordered table-hover table-condensed">
                    	<thead>
                      <tr><th>DATE</th><th>GAS%</th><th>O<SUB>2</SUB>%</th><th>H<sub>2</sub>S%</th></tr>
                      </thead>
                      <tbody>
                      <cfloop query="qGT">
                      <tr>
                        <td>#dateformat(qGT.Date,'dd/mm/yy')# #timeformat(qGT.Date,'hh:mm tt')#</td>
                        <td>#qGT.Gas#</td>
                        <td>#qGT.O2#</td>
                        <td>#qGT.H2O#</td>
                      </tr>
                      </cfloop>
                      </tbody>
                    </table>
                    <strong>Gas Free:</strong> #qP.GasFree#
                </div>
                <div class="span6">
					<cfset cshibfs = "CONFINED SPACE ENTRY HAZARDS IDENTIFIED BY DACILITY SUPERVISOR,Oxygen deficiency,Oxygen enrichment,Chemical / Toxic substances,Flammable gases,Physical Harzard"/>
                    <cfloop list="#cshibfs#" index="it"> 
                    	<cfset chk = getCheck(qP.ConfinedSpace,it)/>
                    	<div class="cimg#chk#"><img src="assets/img/ptw_checkbox_#chk#.png" width="9" height="9"> #it#</div> 
                    </cfloop> 
                	<em>Specify</em>:#qP.Custom3#<br/><br/>
		            <cfset p_ = "PRECAUTIONS,Gas tests for flammable gas O<sub>2</sub> & H<sub>2</sub>O carried out,Hazadousor non-hazardous entry(form gas test),Continious gas test every ....... hours for flammable gas O<sub>2</sub> & H<sub>2</sub>O carried out,Positive breathing apparatus worn,Standby man with lifeline and positive breathing apparatus,Fumes present. Light fume respirator worn,Potentially dangerous activity adjacent the work area has been suspended,Max. number of persons in confined space,All flammable/toxic residues removed,Additional lightings flame proof,Special tools required,Improved natural ventilation,External Mechanical Ventilation Flame proof,Emergency exits/equipments available"/>
                    <cfloop list="#p_#" index="it"> 
                    	<cfset chk = getCheck(qP.Precaution,it)/>
                    	<div class="cimg#chk#"><img src="assets/img/ptw_checkbox_#chk#.png" width="9" height="9"> #it#</div> 
                    </cfloop> 
                </div>
            </div>           
        </div>
    </div>

    <div class="row-fluid">
        <div class="span12"> 
            <div class="row-fluid">
                <div class="span1 r270">Job_Hazard_Analysis</div>
                <div class="span11">  
                    <dl class="">
                        <dt>JHA Number:</dt>
                        <dd>#qJ.JHAId#</dd>
                    </dl>
<table width="100%" class="table table-striped table-bordered table-hover table-condensed">
    <thead><tr>
      <th>&nbsp;</th>
      <th nowrap="nowrap">Job Sequence</th>
      <th>Hazard</th>
      <th align="center">Target</th>
      <th align="center">Risk</th>
      <th>Consequences</th>
      <th>Control Measure</th>
      <!---<th>Responsible Party</th>--->      
    </tr></thead>
  <cfloop query="qJL">
    <tr>
      <td valign="top">#qJL.Currentrow#.</td>
      <td valign="top">#qJL.JobSequence#</td>
      <td valign="top">#qJL.Hazard#</td>
      <td align="left" valign="top" nowrap="nowrap">#ucase(qJL.Target)#</td>
      <td align="left" valign="top" nowrap="nowrap">#ucase(qJL.Risk)#</td>
      <td valign="top">#qJL.Consequences#</td>
      <td valign="top">#qJL.ControlMeasure#</td>
      <!---<td valign="top">#qJL.ResponsibleParty#</td>--->      
    </tr>
  </cfloop> 
</table>
<util:FileView type="a" table="ptw_jha" pk="#qp.JHAId#" source="doc/attachment/" column="4"/> <br />


                </div> 
            </div>           
        </div>
    </div>
       
</div>


<cffunction name="getCheck" access="private" returntype="string">
	<cfargument name="lst1" type="string" required="yes"/>
    <cfargument name="vl" type="string" required="yes"/>
    
	<cfset var chk = 0/>
    <cfif ListFindNoCase(arguments.lst1,arguments.vl)>
        <cfset chk=1/>
    </cfif>	
    
    <cfreturn chk/>
</cffunction>

</cfoutput>