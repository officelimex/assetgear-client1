<cfparam default="0" name="url.id"/>
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../assets/awaf/tags/xEditTable/" prefix="et" />
<cfimport taglib="../../../assets/awaf/tags/xUploader_1000/" prefix="u" />
<cfimport taglib="../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />

<cfset frId = "__asset_c_#url.id#"/>

<cfquery name="qA">
	SELECT
    	CONCAT(a.Description,' @ ',l.Name,' ',IFNULL(al.LocDescription,"")) AssetLocation, al.AssetLocationId
    FROM asset_location al
    INNER JOIN asset a ON a.AssetId = al.AssetId
    INNER JOIN location l ON al.LocationId = l.LocationId
    ORDER BY a.Description,l.Name
</cfquery>

<cfquery name="qFR">
    SELECT * FROM asset_failure_report
    WHERE AssetFailureReportId = #val(url.id)#
</cfquery>

<cfquery name="qIR">
	SELECT IncidentId AS WorkOrderId FROM incident_report ORDER BY IncidentId
</cfquery>
<cfquery  name="qWo">
	SELECT WorkOrderId FROM work_order ORDER BY WorkOrderId
</cfquery>

<cfquery name="qP">
    SELECT * FROM period ORDER BY PeriodId
</cfquery>


<cfset Id1 = "#frId#_1"/>
<cfset Id2 = "#frId#_2"/>
<cfset Id3 = "#frId#_3"/>
<cfset Id4 = "#frId#_4"/>
<cfif url.id neq 0>
	<cfset Id5 = "#frId#_5"/>
</cfif>

<cfoutput>

    <f:Form id="#frId#new_fr" action="controllers/Asset.cfc?method=SaveAssetFailureReport" EditId="#url.id#">
		<div id="#Id1#" style="height:auto;">
			<table width="100%">
				<tr>
					<td valign="top" colspan="2">
						<f:TextBox name="ReportTitle" label="Report Title" value="#qFR.ReportTitle#" required class="span11"/>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<f:select class="span11" name="FailureOn" label="Failure On" required 
						ListDisplay="Fix Asset - This include tangible assets or property plant and equipment (PP&E),Service - This are services provided by contractors or on house services" 
						Listvalue="Fix Asset,Service" onchange="#frId#changePT(this)"  Selected="#qFR.FailureOn#"/>
					</td>
				</tr>
			</table>
			<cfif qFR.FailureOn eq "Service">
				<cfset display2 = "block"/>
				<cfset display1 = "none"/>
			<cfelseif  qFR.FailureOn eq "Fix Asset">
				<cfset display2 = "none"/>
				<cfset display1 = "block"/>
			<cfelse>
				<cfset display2 = "none"/>
				<cfset display1 = "none"/>
			</cfif>
			<div style="display:#display1#" id="#frId#ic1">
				<tr>
					<td width="100%">
						<f:Select name="AssetLocationId"
							label="Asset" required
							ListValue="#valuelist(qA.AssetLocationId,'`')#" autoselect
							delimiters="`" ListDisplay="#valuelist(qA.AssetLocation,'`')#"
							selected="#qFR.AssetLocationId#" class="span11"/>
					</td>
				</tr>
			</div>
			<div style="display:#display2#" id="#frId#ic2">
				<tr>
					<td colspan="2">
						<f:TextArea name="ServiceDescription" required label="Service Description" value="#qFR.ServiceDescription#" class="span11" row="3"/>
					</td>
				</tr>
			</div>

			<table width="100%">
				<tr>
					<td valign="top" width="50%">
						<f:DatePicker name="Date" label="Noticed date" value="#qFR.Date#" required class="span12" type="datetime" />								
					</td>
					<td valign="top">
						<f:Select name="RiskLevel" label="Risk Level" required ListValue="High,Medium,Low" class="span9" selected="#qFR.RiskLevel#"/>								
					</td>
				</tr>
				<tr>
					<td valign="top" colspan="2">
						<f:TextBox name="ServiceProvider" label="Service Provider" value="#qFR.ServiceProvider#" class="span11"/>
					</td>
				</tr>
			</table>
			<div>
				<f:TextArea name="InitiatorsComment" value="#qFR.InitiatorsComment#" label="Initiator's Comment" class="span11" rows="3"/>
			</div>
			<div class="span11">
				<et:Table allowInput height="100%" id="IntegratIon">
					<cfquery name="qAI">
						SELECT * FROM failure_report_integration
						WHERE AssetFailureReportId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
					</cfquery>
					<et:Headers>
						<et:Header title="Integrate Into W.O or Incident (Double click to select options)" size="7" type="text" hint="Double click to select from options">
							<et:Select ListValue="Work Order,Incident Report"/>
						</et:Header>
						<!---<et:Header title="Reference ##" size="4" type="int">
			            	<et:Select ListValue="#id#" ListDisplay="#iddisplay#" delimiters=","/>
			            </et:Header>--->
						<et:Header title="Reference ##" size="4" type="int" hint="WO## or Incident##"/>
						<et:Header title="" size="1"/>
					</et:Headers>
					<et:Content Query="#qAI#" Columns="IntegrateTable,PK" type="text,int" PKField="IntegratIonId"/>
				</et:Table>
			</div>
		</div>
		<div id="#Id2#">
			<table width="100%">
				<tr>
					<td colspan="2">
						<f:CheckBox name="SuspectedCause" required ListValue="Design/Manufacturer,Shipping,Storage,Installation,Maintenance,Wear/Aging,Natural Disaster,Animals/Birds,Not Obvious,Others" selected="#qFR.SuspectedCause#" inline showlabel label="Suspected Cause" />
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<f:TextArea name="OtherCauses" value="#qFR.OtherCauses#" label="Other Causes" class="span11" rows="3"/>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<f:TextArea name="DescriptionOfSuspectedCause" value="#qFR.DescriptionOfSuspectedCause#" label="Description Of Suspected Cause" class="span11" rows="3"/>
					</td>
				</tr>
				<tr>
					<td valign="top" >
						<f:CheckBox name="PreventiveMeasure" ListValue="Equipment Replacement,Overhaul,Reduce Service Duration,Equipment Substitution,Upgrade,Beyond My Control,Others" 
						selected="#qFR.PreventiveMeasure#" required inline showlabel label="Measure(s) taken When Noticed" />
						<f:TextArea name="OtherPreventiveMeasure" value="#qFR.OtherPreventiveMeasure#" label="Othe Measures Taken" class="span11" rows="3"/>
					</td>

				</tr>
				
			</table>
		</div>
		<div id="#Id3#">
			<table width="100%">
				<tr>
			        <td  valign="top" width="100%">
						<f:CheckBox required name="ActionTaken" ListValue="Report Equipment Behaviour,Equipment Shutdown/Isolation,Fault Findings,Carried out Repairs,Function Tested,Others" 
						   selected="#qFR.ActionTaken#" inline showlabel label="Action Taken" />
				        <f:TextArea name="OtherActionTaken" value="#qFR.OtherActionTaken#" label="Other Actions Taken" class="span11" rows="3"/>
				        
					</td>
				</tr>
				<tr>
					<td>
						<f:Textarea name="Recommentdation" label="Recommendation" value="#qFR.Recommendation#" class="span11" rows="3"/>
					</td>
				</tr>
				<tr>
					<td>
						<table width="100%">
                            <tr>
                                <td width="50%">
                                    <f:Select name="ResolveTimeLine" label="Period to Resolve Fault" required ListValue="#ValueList(qP.Name)#" class="span9" selected="#qFR.ResolveTimeLine#"/>								
                                </td>
                                <td >
						            <f:DatePicker name="ResolveStartTime" label="From" value="#qFR.ResolveStartTime#" required class="span10" type="datetime" />								
                                </td>
                            </tr>
                        </table>
					</td>
				</tr>
				
			</table>
		</div>
		<div id="#Id4#">
			<table width="100%">
				<tr>
					<td>
						<f:TextArea name="Effect" value="#qFR.Effect#" label="What effect does it have on operations" class="span11" required rows="5"/>
					</td>
				</tr>

				<tr>
					<td>
						<f:TextArea name="ReasonForDelay" value="#qFR.ReasonForDelay#" label="Reason for delay in resolving issues (If any)" class="span11" rows="5"/>
					</td>
				</tr>
			</table>
		</div>
		<cfif url.id neq 0>
			<div id="#Id5#">
				<table width="100%">
					<tr>
						<td colspan="2">
							<f:CheckBox name="RootCause" required ListValue="Human Error,Asset Lifespan,Asset Fatigue,Installation Error,Mechanical Error,Electrical Error,Natural Disaster:Rain,Natural Disaster:Lightening,Natural Disaster:Flood,Natural Disaster:Stome,Others" 
							selected="#qFR.RootCause#" inline showlabel label="Root Cause" />
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<f:Textarea rows="3" name="OtherRootCause" label="Other Root Cause" value="#qFR.OtherRootCause#" class="span11"/>
						</td>
					</tr>

					<tr>
						<td colspan="2">
							<f:TextArea name="DownTimeCosting" value="#qFR.DownTimeCosting#" label="Cost of Down Time" class="span11" rows="2"/>
						</td>
					</tr>
                    <tr>
                        <td colspan="2">
                            <f:TextArea name="WorkDone" value="#qFR.WOrkDone#" label="Work Done" class="span11" rows="3"/>
                        </td>
                    </tr>
					<tr>
						<td colspan="2">
							<f:TextArea name="SupervisorComment" value="#qFR.SupervisorComment#" label="Supervisor Comment" class="span11" rows="3"/>
						</td>
					</tr>		

					<tr>
						<td width="50%">
							<f:DatePicker hint="" type="datetime" name="ResolvedDate" label="Resolved Date" value="#qFR.ResolvedDate#" class="span12"/>
                            <small><i>Adding this date auto-close the report</i></small>
						</td>
						<td>
							<f:Select name="Status"
									label="Status"
									required ListValue="Open,In Progress,Suspended"
									class="span9" selected="#qFR.Status#"/>
						</td>
					</tr>
				</table>
			</div>
		</cfif>

		<nt:NavTab renderTo="#frId#">
			<nt:Tab>
				<nt:Item title="General" isactive/>
				<nt:Item title="Preliminary Analysis"/>
				<nt:Item title="Action Taken / Recommendation"/>
				<nt:Item title="Effects"/>
				<cfif url.id neq 0><nt:Item title="Close Section"/></cfif>
			</nt:Tab>
			<nt:Content>
				<nt:Item id="#Id1#" isactive/>
				<nt:Item id="#Id2#"/>
				<nt:Item id="#Id3#"/>
				<nt:Item id="#Id4#"/>
				<cfif url.id neq 0><nt:Item id="#Id5#"/></cfif>
			</nt:Content>
		</nt:NavTab>
        <cfif url.id eq 0>
			<f:ButtonGroup>
				<f:Button value="Create new F.R." class="btn-primary" IsSave subpageId="new_fr" ReloadURL="modules/maintenance/asset/save_failure_report.cfm"/>
			</f:ButtonGroup>
		</cfif>
	</f:Form>
	<script>
		
		function #frId#changePT(d)	{
			var ic1_ = $("#frId#ic1");
			var ic2_ = $("#frId#ic2");
			if(d.value == 'Fix Asset')	{
				ic1_.setStyle('display','block');
				ic2_.setStyle('display','none');
			}
			else	{
				ic1_.setStyle('display','none');
				ic2_.setStyle('display','block');
			}
		}
	</script>
</cfoutput>
