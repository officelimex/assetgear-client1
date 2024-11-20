<cfparam default="0" name="url.id"/>
<cfparam default="" name="url.filter"/>
<cfif isdefined("request.filter")>
	<cfset url.filter = request.filter/>
</cfif>

<cfparam name="url.cid" default=""/>
<cfset woId = "__workorder_c_all_workorder#url.cid##url.filter#" & url.id/>

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

<cfset qWO = application.com.WorkOrder.GetWorkOrder(url.id)/>
<cfset qOI = application.com.WorkOrder.GetWorkOrderItems(url.id)/>
<cfset qJC = application.com.WorkOrder.GetJobClass()/>
<cfset qWI = application.com.Item.GetItems()/>
<cfset qAL = application.com.Asset.GetAssetLocationByAsset(qWO.AssetId)/>
<!---<cfset qA = application.com.Asset.GroupAssetByLocation()/>--->

<cfquery name="qCU">
	SELECT UserId,concat(Surname, " ", OtherNames) as Names, Email
    FROM core_user
	WHERE Approved = "Yes" AND UserStatus = "Active"
    ORDER BY Names
</cfquery>
<cfquery name="qCun">
	SELECT * FROM core_unit
    ORDER BY Name
</cfquery>
<cfquery name="qCD">
	SELECT * FROM core_department
    ORDER BY Name
</cfquery>

<cfquery name="qL">
    SELECT
        l.LabourId,l.Hours,l.Rate,l.Function,l.WorkOrderId,
        CONVERT(Concat(cu.Surname," ",cu.OtherNames,"~",cu.UserId) USING utf8) as `Names`
    FROM
    	labour AS l
    INNER JOIN core_user AS cu ON l.UserId = cu.UserId
	WHERE l.WorkOrderId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/> AND Approved="Yes"
</cfquery>
<cfquery name="qCon">
    SELECT * FROM contract c
    WHERE c.WorkOrderId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>
<cfif url.id eq 0>
<br/>
</cfif>
<f:Form id="#woId#frm" action="modules/ajax/maintenance.cfm?cmd=SaveWorkOrder" EditId="#url.id#">
    <input type="hidden" value="#qWO.PMTaskId#" name="PMTaskId"/>
	<input type="hidden" value="#qWO.ServiceRequestId#" name="ServiceRequestId"/>
	<div id="#Id1#" style="height:420px;">
        <table width="100%" border="0">
          <tr>
            <td colspan="2" valign="top">
<!---<cfif url.id eq 0>--->
<cfquery name="qA">
	SELECT
    	CONCAT(a.Description,' @ ',l.Name,' ',IFNULL(al.LocDescription,'')) Asset, CONCAT(a.AssetId,',',al.AssetLocationId) AssetId 
    FROM asset a
    LEFT JOIN asset_location al ON (al.AssetId = a.AssetId)
    INNER JOIN location l ON (l.LocationId = al.LocationId)
    WHERE a.Status = "Online"
    ORDER BY a.Description,l.Name
</cfquery>

<!---<f:Select name="AssetId" label="Asset" required ListValue="#valuelist(qA.AssetId,'`')#" autoselect delimiters="`" ListDisplay="#valuelist(qA.Asset,'`')#" Selected="#qWO.AssetId#,#qWO.AssetLocationIds#" class="span10"/>
--->
<cfquery name="qA">
	SELECT
    	CONCAT(a.Description) Asset, a.AssetId
    FROM asset a
</cfquery>
<f:Select name="AssetId" label="Asset" required ListValue="#valuelist(qA.AssetId,'`')#" autoselect delimiters="`" ListDisplay="#valuelist(qA.Asset,'`')#" Selected="#qWO.AssetId#" class="span10"/>


</td>
          </tr>
          <tr>
            <td width="50%" valign="top">
            <f:TextArea name="Description" label="Work Description" required value="#qWO.Description#" rows="4"/>

			<!---<cfif request.IsHost>
                <f:Select name="DepartmentId" label="Department" required selected="#qWO.DepartmentId#" ListValue="#Valuelist(qCD.DepartmentId)#" ListDisplay="#Valuelist(qCD.Name)#"/>
            </cfif>--->
            </td>
            <td class="horz-div" valign="top">
            <cfif qWO.WorkClassId eq 10>
            	<f:Select name="WorkClassId" label="Work Class" required ListValue="#Valuelist(qJC.JobClassId)#" ListDisplay="#Valuelist(qJC.Class)#" Selected="#qWO.WorkClassId#" />
            <cfelse>
            	<f:Select name="WorkClassId" label="Work Class" required ListValue="#Valuelist(qJC.JobClassId)#" ListDisplay="#Valuelist(qJC.Class)#" Selected="#qWO.WorkClassId#" />
            </cfif>

            <f:DatePicker name="DateOpened" label="Date Opened" required value="#dateformat(qWO.DateOpened,'dd/mmm/yyyy')#"/>
            <f:Select name="DepartmentId" label="Department" required ListValue="#Valuelist(qCD.DepartmentId)#" ListDisplay="#Valuelist(qCD.Name)#"  Selected="#qWO.DepartmentId#"/>
			<f:Select name="UnitId" label="Unit"  ListValue="#Valuelist(qCun.UnitId)#" ListDisplay="#Valuelist(qCun.Name)#"  Selected="#qWO.UnitId#"/>
			
			<input type="hidden" name="AssetFailureReportId" label="Failure Report ##" value="#qWO.AssetFailureReportId#"/>
            <!---<f:DatePicker name="DateDue" label="Date Due" required value="#dateformat(qWO.DateDue,'dd/mmm/yyyy')#"/>--->

            </td>
          </tr>
          <tr>
            <td colspan="2" ><f:CheckBox name="AssetLocationIds" ListValue="#ValueList(qAL.AssetLocationId,'`')#" ListDisplay="#ValueList(qAL.Location,'`')#" showlabel label="Asset Location" delimiters="`" bind="AssetId" Event="change" data="modules/ajax/maintenance.cfm?cmd=LoadAssetLocations" selected="#qWO.AssetLocationIds#" inline/></td>
          </tr>          <tr>
            <td colspan="2">
                <table width="99%">
                    <tr>
                    	<td width="160px" he valign="top" nowrap="nowrap" align="center">Work Details:</td>
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
                        <textarea id="WorkDetails" name="WorkDetails" style="width:85%; height:110px;" class="#dd#">#qWO.WorkDetails#</textarea></td>
                    </tr>

                </table>
            </td>
          </tr>
        </table>
    </div>
    <div id="#Id2#">
    	<div class="alert alert-info">Use this area to add spare parts from the warehouse</div>
    	<cfquery name="qOI_" dbtype="query">
        	SELECT * FROM qOI
          WHERE ItemId <> '' AND ItemStatus = 'Online' AND Obsolete = 'No'
      </cfquery>
        <et:Table allowInput height="200px" id="WorkOrderItem">
            <et:Headers>
                <et:Header title="Spare parts" size="6" type="int">
                    <et:Select ListValue="#Valuelist(qWI.ItemId,'`')#" ListDisplay="#Valuelist(qWI.ItemDescription,'`')#" delimiters="`"/>
                </et:Header>
                <et:Header title="Purpose" size="4" type="text" />
                <et:Header title="Qty" size="1" type="int" />
                <et:Header title="" size="1"/>
            </et:Headers>
           <et:Content Query="#qOI_#" Columns="ItemDescription,Purpose,Quantity" type="int-select,text,int" PKField="WorkOrderItemId"/>
        </et:Table>
    </div>

	<div id="#Id3#">
    	<div class="alert alert-info">Use this area to add materials not stocked in the warehouse</div>
    	<cfquery name="qOI_2" dbtype="query">
        	SELECT * FROM qOI
            WHERE ItemId = ''
        </cfquery>
        <et:Table allowInput height="200px" id="WorkOrderItem2">
            <et:Headers>
                <et:Header title="Material needed" size="5" type="text"/>
                <et:Header title="Purpose" size="3" type="text"/>
                <et:Header title="Unit price" size="2" type="float"/>
                <et:Header title="Qty" size="1" type="float"/>
                <et:Header title="" size="1"/>
            </et:Headers>
           <et:Content Query="#qOI_2#" Columns="Description,Purpose,UnitPrice,Quantity" type="text,text,float,int" PKField="WorkOrderItemId"/>
        </et:Table>
    </div>

    <div id="#Id4#"><!--- Labour --->
    	<et:Table allowInput height="210px" id="Labour">
            <et:Headers>
                <et:Header title="Employee" size="4" type="int">
                    <et:Select ListValue="#Valuelist(qCU.UserId,'`')#" ListDisplay="#Valuelist(qCU.Names,'`')#" delimiters="`"/>
                </et:Header>
                <et:Header title="Role played in this job" size="6" type="text"/>
                <et:Header title="Hours" size="1" type="int"/>
                <et:Header title="" size="1"/>
            </et:Headers>
            <et:Content Query="#qL#" Columns="Names,Function,Hours" type="text,text,int" PKField="LabourId"/>
        </et:Table>
    </div>

    <div id="#Id5#"><!--- Contractor --->
    	<et:Table allowInput height="210px" id="Contract">
            <et:Headers>
                <et:Header title="Contractor" size="4" type="text"/>
                <et:Header title="Work scope" size="5" type="text"/>
                <et:Header title="Currency" size="1" type="text">
                    <et:Select ListValue="NGN,USD"/>
                </et:Header>
                <et:Header title="Cost" size="1" type="float"/>
                <et:Header title="" size="1"/>
            </et:Headers>
            <et:Content Query="#qCon#" Columns="Contractor,Description,Currency,Cost" type="text,text,text,foat" PKField="ContractId"/>
        </et:Table>
    </div>

    <div id="#Id6#" align="center">
        <table width="100%" border="0">
          <tr>
            <td width="50%" valign="top">
            	<f:DatePicker name="DateClosed" label="Date Closed" value="#dateformat(qWO.DateClosed,'dd/mmm/yyyy')#"/>
            </td>
            <td class="horz-div" valign="top">
            	<f:Select name="SupervisedByUserId" autoselect label="Supervised By" delimiters="`" ListValue="#Valuelist(qCU.UserId,'`')#" ListDisplay="#Valuelist(qCU.Names,'`')#" Selected="#qWO.SupervisedByUserId#" class="span9" required/>
            </td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
          	<td colspan="2">
            	<f:TextArea name="WorkDone" label="Work Done" value="#qWO.WorkDone#" class="span11" rows="8"/>
            </td>
          </tr>
          <tr>
          	<td>
                <cfif (qWO.DepartmentId eq request.userinfo.departmentid)>
                    <cfif request.IsSV || request.IsPS || request.IsMS || (request.userinfo.role eq "FS")>
                        <f:Select name="Status" required ListValue="Open,Close,Suspended,Part on hold,Declined" Selected="#qWO.Status#" class="span6"/>
                    <cfelse>
                        <f:Select name="Status" ListValue="Open,Close,Suspended" Selected="#qWO.Status#" class="span6"/>
                    </cfif>
                <cfelse>
                    <cfif request.userinfo.role eq "FS" || equest.IsMS>
                        <f:Select name="Status" required ListValue="Open,Close,Suspended,Part on hold,Declined" Selected="#qWO.Status#" class="span6"/>
                    <cfelse>
                        <f:Select name="Status" Disabled ListValue="Open,Close,Suspended,Part on hold,Declined" Selected="#qWO.Status#" class="span6"/>
                    </cfif>
                </cfif>
            </td>
            <td></td>
          </tr>
        </table>
    </div>

    <div id="#Id7#">
        <cfquery name="qMr" result="rt1">
        	SELECT * FROM whs_mr WHERE WorkOrderId  = #url.Id#
        </cfquery>
        <cfquery name="qMIs" result="rt2">
        	SELECT * FROM whs_issue WHERE WorkOrderId  = #url.Id#
        </cfquery>
        <cfset printtype = "print_mrni"/>
        <cfif qMr.Type eq "SI">
        	<cfset printtype = "print_mr"/>
        </cfif>
        
        <div class="alert alert-info">Use this area to add/view documents for easy access such as invoice, receipt, or any other type of document.</div>
        <ul >
			<cfif rt1.RecordCount gt 0>
                <li style=" display:inline; margin-right:12px">
                    <cfloop query="qMr">
                        MATERIAL REQUISITION ##: <a target="_blank" href="modules/warehouse/transaction/mr/#printtype#.cfm?id=#qMr.MRId#">#qMr.MRId#</a>
                    </cfloop>
                </li>
             </cfif>
			<cfif rt2.RecordCount gt 0>
                <li style=" display:inline; margin-right:12px">
                    <cfloop query="qMIs">
                        MATERIAL ISSUE ##: <a target="_blank" href="modules/warehouse/transaction/issue/print_material_issue.cfm?id=#qMIs.IssueId#">#qMIs.IssueId#</a>
                    </cfloop>
                </li>
             </cfif>
        </ul>
        <hr>
        <u:UploadFile id="Attachments" table="work_order" pk="#url.id#" />
    </div>

    <nt:NavTab renderTo="#woId#">
        <nt:Tab>
            <nt:Item title="Open Section" isactive/>
            <nt:Item title="Part Section (A)"/>
            <nt:Item title="Part Section (B)"/>
            <nt:Item title="Labour Section"/>
            <nt:Item title="Contractors"/>
            <nt:Item title="Close Section"/>
            <nt:Item title="Documents"/>
        </nt:Tab>
        <nt:Content>
            <nt:Item id="#Id1#" isactive/>
            <nt:Item id="#Id2#"/>
            <nt:Item id="#Id3#"/>
            <nt:Item id="#Id4#"/>
            <nt:Item id="#Id5#"/>
            <nt:Item id="#Id6#"/>
            <nt:Item id="#Id7#"/>
        </nt:Content>
    </nt:NavTab>
  
</f:Form>

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
