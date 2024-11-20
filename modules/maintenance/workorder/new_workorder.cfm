<cfparam name="url.id" default="0"/>
<cfparam name="url.cid" default=""/>
<cfset woId = "__workorder_c_all_workorder#url.cid#" & url.id/>

<cfset Id1 = "#woId#_1"/>
<cfset Id2 = "#woId#_2"/>
<cfset Id3 = "#woId#_3"/>
<cfset Id4 = "#woId#_4"/>
<cfset Id5 = "#woId#_5"/>
<cfset Id6 = "#woId#_6"/>
<cfset Id7 = "#woId#_7"/>

<cfoutput>

	<cfimport taglib="../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
	<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />
	<cfimport taglib="../../../assets/awaf/tags/xEditTable/" prefix="et" />
	<cfimport taglib="../../../assets/awaf/tags/xUploader_1000/" prefix="u" />

	<cfset qWI = application.com.Item.GetItems()/>
	<cfset qJC = application.com.WorkOrder.GetJobClass()/>

	<cfquery name="qCD">
		SELECT * FROM core_department
			ORDER BY Name
	</cfquery>
	<cfquery name="qJC" dbtype="query">
		SELECT * FROM qJC
		WHERE JobClassId <> 10
	</cfquery>
	<cfquery name="qCun">
		SELECT * FROM core_unit
			ORDER BY Name
	</cfquery>
	<!---<cfset qA = application.com.Asset.GroupAssetByLocation()/>--->
	<cfquery name="qA">
		SELECT
				CONCAT(a.Description,' @ ',l.Name,' ',IFNULL(al.LocDescription,'')) Asset, CONCAT(a.AssetId,',',al.AssetLocationId) AssetId 
			FROM asset a
			LEFT JOIN asset_location al ON (al.AssetId = a.AssetId)
			INNER JOIN location l ON (l.LocationId = al.LocationId)
			WHERE a.Status = "Online"
			ORDER BY a.Description,l.Name
	</cfquery>
	<cfquery name="qCU">
		SELECT UserId,concat(Surname, " ", OtherNames) as Names, Email FROM core_user
		WHERE Approved = "Yes" AND UserStatus = "Active"
	</cfquery>

	<cfif url.id eq 0>
		<br/>
	</cfif>

	<!--- get all work order created by user --->
	<cfquery name="qc1">
		SELECT COUNT(WorkOrderId) Total FROM work_order 
		WHERE CreatedByUserId = #request.userinfo.userId#
			AND Status <> "Close"
	</cfquery>
	

<!--- 	<cfif request.userinfo.departmentid == 16>
		<cfquery name="qc1">
			SELECT COUNT(WorkOrderId) Total FROM work_order 
			WHERE CreatedByUserId = #request.userinfo.userId#
				AND Status <> "Close"
		</cfquery>
		<cfquery name="qc2">
			SELECT COUNT(WorkOrderId) Total FROM work_order 
			WHERE Status <> "Close" 
				AND DepartmentId = #request.userinfo.departmentid#
				AND DateOpened < "#Dateformat(now(), 'yyyy/m/d')#"
			<cfif val(request.userinfo.unitid)>
				AND UnitId = #request.userinfo.UnitId#
			</cfif>
		</cfquery>
	<cfelse> --->
		<cfquery name="qc1">
			SELECT COUNT(WorkOrderId) Total FROM work_order 
			WHERE CreatedByUserId = #request.userinfo.userId#
				AND Status = "Open"
		</cfquery>
		<cfquery name="qc2">
			SELECT COUNT(WorkOrderId) Total FROM work_order 
			WHERE Status = "Open" 
				AND DepartmentId = #request.userinfo.departmentid#
				AND DateOpened < "#Dateformat(now(), 'yyyy/m/d')#"
			<cfif val(request.userinfo.unitid)>
				AND UnitId = #request.userinfo.UnitId#
			</cfif>
		</cfquery>
<!--- 	</cfif> --->

	<cfset can_create = true/>

	<cfif qc2.Total gt 35>
		<cfset can_create = false/>
		<div class="alert alert-danger">
			You can not open a new Work Order. <br  />
			Kindly close or update the status of at least #abs(qc2.Total-35)# OPEN work order created by your unit
		</div>
	</cfif>

	<cfif qc1.Total gt 15>
		<cfset can_create = false/>
		<div class="alert alert-danger">
			You can not open a new Work Order. <br/>
			Kindly close #abs(qc1.Total-15)# of all OPEN work order created by you
		</div>
	</cfif>

	<!---cfset can_create = true  /--->

	<cfif can_create>

		<f:Form id="#woId#frm" action="modules/ajax/maintenance.cfm?cmd=saveWorkOrder" EditId="#url.id#">
			<div id="#Id1#">
					<table width="100%" border="0">
						<tr>
							<td colspan="2" valign="top">
								<f:Select name="AssetId" label="Asset" required ListValue="#valuelist(qA.AssetId,'`')#" autoselect delimiters="`" ListDisplay="#valuelist(qA.Asset,'`')#" class="span10"/>
							</td>
						</tr>
						<tr>
							<td width="50%" valign="top">
								<!---<cfif request.IsHost or !request.IsAdmin>
									<f:Select name="DepartmentId" label="Department" required ListValue="#Valuelist(qCD.DepartmentId)#" ListDisplay="#Valuelist(qCD.Name)#"/>
								</cfif>--->
								<f:DatePicker name="DateOpened" label="Date Opened" required value="#dateformat(now(),'dd/mmm/yyyy')#"/>
								<f:TextArea label="Work Description" name="Description" required class="span11" style="width:94%; height:140px;"/>
							</td>
							<td class="horz-div" valign="top">
								<input type="hidden" name="AssetFailureReportId" label="Failure Report ##" value=""/>
								<!---<f:DatePicker name="DateDue" label="Date Due" required value="#dateformat(now(),'dd/mmm/yyyy')#"/>
								<f:TextBox name="EstimateManHours" label="Estimate Man Hours" required class="span2"/>--->
								
								<f:Select name="WorkClassId" label="Work Class" required ListValue="#Valuelist(qJC.JobClassId)#" ListDisplay="#Valuelist(qJC.Class)#"/>
								
								<f:Select name="DepartmentId" label="Department" required ListValue="#Valuelist(qCD.DepartmentId)#" ListDisplay="#Valuelist(qCD.Name)#"  Selected="#request.UserInfo.DepartmentId#"/>
								<f:Select name="UnitId" label="Unit" required ListValue="#Valuelist(qCun.UnitId)#" ListDisplay="#Valuelist(qCun.Name)#" Selected="#request.UserInfo.UnitId#"/>
								
								<f:Select name="Status" required ListValue="Open" class="span4"/>
								<!--- <f:Select name="Status" required ListValue="Open,Part on hold" class="span4"/> --->
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<table width="99%">
									<tr>
										<td width="160px" valign="top" nowrap="nowrap" align="center">Work Details:</td>
										<td valign="top">
											<script>
												<cfset dd= "_#CreateUUID()#"/>
												CKEDITOR.replaceAll('#dd#');
												var editor = CKEDITOR.instances['WorkDetails'], _txteditor = $$('.#dd#')[0];
												editor.on( 'key', function( e ) {
													_txteditor.set('text',e.editor.getData());
												});
												editor.on( 'blur', function( e ) {
													_txteditor.set('text',e.editor.getData());
												});
											</script>
											<textarea id="WorkDetails" name="WorkDetails" style="width:100%; height:350px;" class="#dd#"></textarea>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
			</div>
			<div id="#Id2#">
				<div class="alert alert-info">Use this area to add spare parts from the warehouse</div>
					<et:Table allowInput height="222px" id="WorkOrderItem">
							<et:Headers>
									<et:Header title="Spare parts" size="6" type="int">
													<et:Select ListValue="#Valuelist(qWI.ItemId,'`')#" ListDisplay="#Valuelist(qWI.ItemDescription,'`')#" delimiters="`"/>
											</et:Header>
									<et:Header title="Purpose" size="4" type="text" />
									<et:Header title="Qty" size="1" type="int" />
									<et:Header title="" size="1"/>
							</et:Headers>
					</et:Table>
			</div>
			<div id="#Id3#">
				<div class="alert alert-info">Use this area to add materials not stocked in the warehouse</div>
				<et:Table allowInput height="222px" id="WorkOrderItem2">
					<et:Headers>
						<et:Header title="Material needed" size="5" type="text"/>
						<et:Header title="Purpose" size="3" type="text"/>
						<et:Header title="Unit price" size="2" type="float"/>
						<et:Header title="Qty" size="1" type="float"/>
						<et:Header title="" size="1"/>
					</et:Headers>
				</et:Table>
			</div>
			<div id="#Id4#"><!--- Labour --->
					<et:Table allowInput height="190px" id="Labour">
								<et:Headers>
										<et:Header title="Employee" size="4" type="int">
												<et:Select ListValue="#Valuelist(qCU.UserId,'`')#" ListDisplay="#Valuelist(qCU.Names,'`')#" delimiters="`"/>
										</et:Header>
										<et:Header title="Role to play in this job" size="6" type="text" />
										<et:Header title="Hours" size="1" type="int" />
										<et:Header title="" size="1"/>
								</et:Headers>
						</et:Table>
			</div>
			<div id="#Id7#"><!--- Labour --->
					<table width="100%" border="0">
						<tr>
							<td valign="top">
								<f:Select name="SupervisedByUserId" autoselect label="Supervised By" delimiters="`" ListValue="#Valuelist(qCU.UserId,'`')#" ListDisplay="#Valuelist(qCU.Names,'`')#" Selected="" class="span12" required/>
							</td>
						</tr>
					</table>
			</div>
			<div id="#Id5#"><!--- Contractor --->
				<et:Table allowInput height="222px" id="Contract">
					<et:Headers>
						<et:Header title="Contractor" size="4" type="text"/>
						<et:Header title="Work scope" size="5" type="text"/>
						<et:Header title="Currency" size="1" type="text">
								<et:Select ListValue="NGN,USD"/>
						</et:Header>
						<et:Header title="Cost" size="1" type="float"/>
						<et:Header title="" size="1"/>
					</et:Headers>
					</et:Table>
			</div>
			<div id="#Id6#">
				<div class="alert alert-info">Use this area to add third party documents for easy access such as invoice, receipt, or any other type of document.</div>
				<u:UploadFile id="Attachments" table="work_order" pk="#url.id#" />
			</div>


				<nt:NavTab renderTo="#woId#">
						<nt:Tab>
								<nt:Item title="Open Section" isactive/>
								<nt:Item title="Part Section (A)"/>
								<nt:Item title="Part Section (B)"/>
								<nt:Item title="Labour Section"/>
								<nt:Item title="Supervision"/>
								<nt:Item title="Contractors"/>
								<nt:Item title="Documents"/>
						</nt:Tab>
						<nt:Content>
								<nt:Item id="#Id1#" isactive/>
								<nt:Item id="#Id2#"/>
								<nt:Item id="#Id3#"/>
								<nt:Item id="#Id4#"/>
								<nt:Item id="#Id7#"/>
								<nt:Item id="#Id5#"/>
								<nt:Item id="#Id6#"/>
						</nt:Content>
				</nt:NavTab>

				<cfif url.id eq 0>
						<f:ButtonGroup>
								<f:Button value="Create new Work Order" class="btn-primary" IsSave subpageId="new_workorder" ReloadURL="modules/maintenance/workorder/new_workorder.cfm"/>
						</f:ButtonGroup>
				</cfif>


		</f:Form>

	</cfif>

	<script>
		function #woId#changePT(d)	{
			if(d.value == 'm')	{
				$('#Id1#_a').addClass('hide');
				$('#Id1#_b').removeClass('hide');
			}
			else	{
				$('#Id1#_b').addClass('hide');
				$('#Id1#_a').removeClass('hide');
			}
		}
	</script>

</cfoutput>
