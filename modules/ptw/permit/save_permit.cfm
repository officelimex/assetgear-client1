<!--- 
	Author: Arowolo Abiodun
	Created: 2011/09/30
	Modified: 2011/09/30
	->  
--->
<cfparam default="0" name="url.id"/>

<cfif url.id eq 0><br /></cfif>

<cfset PmtId = "__permit_c_unapproved_permit" & url.id/>

<cfset Id1 = "#PmtId#_1"/>
<cfset Id2 = "#PmtId#_2"/>
<cfset Id3 = "#PmtId#_3"/>
<cfset Id4 = "#PmtId#_4"/>

<cfoutput>
    <cfimport taglib="../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
    <cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />
    <cfimport taglib="../../../assets/awaf/tags/xUploader_1000/" prefix="u" />
    <cfimport taglib="../../../assets/awaf/tags/xEditTable/" prefix="et" />
    
    
    <!--- QUERIES --->
    <cfset qPM = application.com.Permit.GetPermit(url.id)/> 
    <cfquery name="qGT">
        SELECT
        	gt.*, 
            Date_Format(gt.Date,'%d-%m-%y %r') Dates
        FROM
       		ptw_gas_test AS gt
        INNER JOIN ptw_permit AS pp ON gt.PermitId = pp.PermitId 
        WHERE gt.PermitId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
	</cfquery>

<style>
.pad35	{padding:35px;}
</style> 
    
    <f:Form id="#PmtId#frm" action="modules/ajax/ptw.cfm?cmd=SavePermit" EditId="#url.id#"> 
        <div id="#Id1#">
        <table border="0" width="100%">
            <tr>
                <td width="50%" valign="top">
                    <f:TextBox name="JHAId" label="JHA ##" required value="#qPM.JHAId#" class="span5"/>
                    <f:RadioBox ShowLabel Label="Job type" name="WorkType" ListValue="Hot Work,Cold Work,Electrical Work" selected="#qPM.WorkType#" Inline/>
                </td>
                <td class="horz-div"  valign="top">
                    <f:DatePicker name="StartTime" label="Start Date/Time" required value="#qPM.StartTime#" type="datetime"/>
                    <f:DatePicker name="EndTime" label="End Date/Time" required value="#DateFormat(qPM.EndTime,'dd/mmm/yyyy')# #TimeFormat(qPM.EndTime,'HH:MM')#" type="datetime"/>
                    <f:TextBox name="Contractor" label="Contractor" value="#qPM.Contractor#" class="span11"/>
                    <f:TextBox name="NumberOfWorkers" label="Number of workers" required  value="#qPM.NumberOfWorkers#" validate="integer" class="span2"/>                
                </td>
           </tr>
 
        </table>
        </div>
        <div id="#Id2#" <cfif url.id neq 0>style="height:320px;"</cfif>>
        <table width="100%" border="0">
        	<tr class="vert-div">
            	<td colspan="2" align="center" valign="top" >
                	SAFETY PRECAUTIONS TO BE TAKEN AT WORK PLACE <br/>
                </td>
            </tr>
            <tr>
            	<td>
                	<f:CheckBox name="SafetyRequirement1" ListValue="Job hazard analysis sheet attached" selected="#qPM.SafetyRequirement1#" /> 
                </td>
            </tr>
        	<tr>
            	<td width="50%" valign="top">
                	Facilities to be isolated by <br/>
                    <f:CheckBox name="SafetyRequirement2" ListValue="Spades or Binds,Physical seperation,Closed valves, De-energising prime mover"  selected="#qPM.SafetyRequirement2#" delimiter="'"/> 
                    Facilities to be prepared by <br/>
                    <f:CheckBox name="SafetyRequirement3" selected="#qPM.SafetyRequirement3#" ListValue="Depressurising,Draining/venting,Steaming,Gas Test"  /> 
                    Work area to be prepared by<br/>
                    <f:CheckBox name="SafetyRequirement4" selected="#qPM.SafetyRequirement4#" ListValue="Temporary demarcation,Temporary road closure,Additional lighting,Scaffolding/work platform"  /> 
                </td>
                <td class="horz-div" valign="top" >
                	<f:CheckBox name="PPE" selected="#qPM.PPE#" label="Personal" showlabel ListValue="Coverall,Safety helmet,safety shoes, Safety goggles,Safety spectacles,Light fumes mask,Breathing apparatus,Plastic gloves,Dotted gloves,Hearing protection,Protective apron,Rubber boots,Dust mask,Safety hamess,Work vest/life jacket,Self contained BA,Compressor air line"  />
                </td>
            </tr>
            <tr>
            	<td>
                	<br/>
                </td>
           </tr>
           <tr>
           		<td colspan="2">
                	<f:TextArea name="AdditionalPrecaution" label="Additional precautions" value="#qPM.AdditionalPrecaution#" class="span10" rows="4"/>
                </td>
           </tr>
        </table>
        </div>
        <div id="#Id3#" <cfif url.id neq 0>style="height:320px;"</cfif>>
            <table width="100%">
            	<tr class="vert-div" >
                	<td colspan="2" align="center">CERTIFICATES (INDICATE AS REQUIRED)</td>
                </tr>
                <tr>
                	<td valign="top" width="50%">
                    	<br/>
                    	<f:CheckBox selected="#qPM.HotWork#"  label="Hot work precaution" name="HotWork" ListValue="Wash down area with water,Cover area with sand,Cover area with foam blanket,Shield adjacent areas,Provide trained fire watch,Provide portable fire extinguishers,FIRE to provide additional fire cover,Test area for flammable atmosphere,Gas test prior to commencement of work,Continious gas monitoring,Suspend potentially dangerous activites" showlabel /> 
                        <f:TextBox  name="Custom1" label="Gas test at intervals" value="#qPM.Custom1#" hint=",Gas test at intervals of.........."/>
                        <f:TextArea name="Custom2" label="Special precautions" value="#qPM.Custom2#" class="span11" />
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td colspan="5">
                                	<strong>Gas test</strong><br/><br/>
                                	FLAMMABLE GAS TEST RECORDED (By an approved gas tester)<br/>The area was tested by me with the following results:
                                </td>
                            </tr>
                            <tr>
                            	<td>
                                <et:Table allowInput height="100px" id="PermitGasTest">
                                    <et:Headers>
                                        <et:Header title="Date" size="4" type="text"/> 
                                        <et:Header title="Gas" size="2" type="text" />
                                        <et:Header title="O<sub>2</sub>" size="2" type="text" />
                                        <et:Header title="H <sub>2</sub> O" size="2" type="text" />
                                        <et:Header title="" size="2"/>
                                    </et:Headers>
                                   <et:Content Query="#qGT#" Columns="Dates,Gas,O2,H2o" type="text,text,text,text,text" PKField="GasTestId"/> 
                                </et:Table>                                
                                </td>
                            </tr>
                            
                        </table>   <br/>
                        <f:RadioBox Label="Gas Free?" ShowLabel Inline name="GasFree" ListValue="Yes,No" selected="#qPM.GasFree#" delimiter="'"/>    
                    </td> 
                    <td class="horz-div" valign="top">
                    	<br/>                        
                    	<f:CheckBox  label="Confined space" selected="#qPM.ConfinedSpace#" name="ConfinedSpace" ListValue="Oxygen deficiency,Oxygen enrichment,Chemical / Toxic substances,Flammable gases,Physical Harzard" showlabel /> 
                        <f:TextBox name="Custom3" label="Specify" value="#qPM.Custom3#"/>
                        <f:CheckBox  label="Precautions" selected="#qPM.Precaution#" name="Precaution" ListValue="Gas tests for flammable gas O<sub>2</sub> & H<sub>2</sub>O carried out,Hazadousor non-hazardous entry(form gas test),Positive breathing apparatus worn,Standby man with lifeline and positive breathing apparatus,Fumes present. Light fume respirator worn,Potentially dangerous activity adjacent the work area has been suspended,Max. number of persons in confined space,All flammable/toxic residues removed,Additional lightings flame proof,Special tools required,Improved natural ventilation,External Mechanical Ventilation Flame proof,Emergency exits/equipments available" showlabel /> 
                        <span style="float:right">Continious gas tests every <input type="text" name="Custom4" value="#val(qPM.Custom4)#" style=" width:22px"/> hours for flammable gas O<sub>2</sub> & H<sub>2</sub>O carried out.</span>
                    </td>
                </tr>
        	</table>
        </div>
        <div id="#Id4#" <cfif url.id neq 0>style="height:320px;"</cfif>>
        	<table width="100%" border="0">
            	<tr>
                	<td align="center"><br/><br/><br/>
                    	<cfif url.id eq 0>
                        	<input type="hidden" value="0" name="PAApprovedByUserId" id="PAApprovedByUserId"/>
                        </cfif>
                    	<div class="h1 alert pad35" <cfif val(qPM.PAApprovedByUserId) neq 0>style="display:none;"</cfif>><a id="#Id4#_sign">Click here</a> to confirm that the safety percautions specified will be observed.</div>
                        <div class="h2 alert pad35 alert-info" <cfif val(qPM.PAApprovedByUserId) eq 0>style="display:none;"</cfif>><cfif request.userinfo.userid eq qPM.PAApprovedByUserId>You have<cfelse>#qPM.PA# has</cfif> signed this document on #dateformat(qPM.PAApprovedDate,'dd mmm yyyy')# #lcase(timeformat(qPM.PAApprovedDate,'hh:mm tt'))#</div> 
                        <div class="h3 alert pad35 alert-danger" style="display:none;">Document signed successfuly</div> 
                    </td>
                </tr>
            </table>
        
        </div>
        
        <nt:NavTab renderTo="#PmtId#">
        <nt:Tab>
            <nt:Item title="Section 1" isactive/>
            <nt:Item title="Section 2"/>
            <nt:Item title="Section 3"/>
            <nt:Item title="Section 4"/>
        </nt:Tab>
        <nt:Content>
            <nt:Item id="#Id1#" isactive/>
            <nt:Item id="#Id2#"/>
            <nt:Item id="#Id3#"/>
            <nt:Item id="#Id4#"/>    
        </nt:Content>
        </nt:NavTab>
        
		<cfif url.id eq 0>
            <f:ButtonGroup>
                <f:Button value="Create new Permit" class="btn-primary" IsSave subpageId="save_permit" ReloadURL="modules/ptw/permit/save_permit.cfm"/>
            </f:ButtonGroup>
        </cfif>
    </f:Form>
<script>    
	window.addEvent('domready', function(){
		var aSign = $('#Id4#_sign');
		aSign.addEvent('click', function(e)	{ 
			var aW = new aWindow('_#left(CreateUUID(),6)#',{
				title:'Enter PIN to Sign Permit',
				url:'modules/ptw/permit/enter_pin.cfm',
				renderTo: $('#Id4#'),modal:true,
				size : {
					width : '400px', height : '100px'
				}	
			});
			
			aW.addButton(new Element('input[type="button"]',{
				'value': 'Continue',
				'class' : 'btn btn-success',
				events:{
					click: function(e)	{
						// send pin to server and check if ok then sign the sign the doc
						new Request({
							url: 'modules/ajax/ptw.cfm?cmd=ConfirmPin&id=#url.id#&pin='+$('__ptw_pin').value,
							onRequest: function(){e.target.disabled=true;},
							onFailure: function(r){
								showError(r);
								$('__ptw_pin').value='';
								$('__ptw_pin').focus();
							},
							onSuccess: function(r){
								<cfif url.id eq 0>
									$('PAApprovedByUserId').value='#request.userinfo.userid#';
								</cfif>
								$$('###Id4# .h1').setStyle('display','none');
								$$('###Id4# .h3').setStyle('display','block');
								aW.close();
							},
							onComplete: function(){e.target.disabled=false;}
						}).send();
					}
				}
			}));
		});
	});
</script>	
</cfoutput>

	
