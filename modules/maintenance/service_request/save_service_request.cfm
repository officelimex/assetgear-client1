<cfparam default="0" name="url.id"/>

<cfparam name="url.cid" default=""/>
<cfset jrId = "__service_request_c_all_service_request#url.cid#" & url.id/>

<cfoutput>
<cfimport taglib="../../../assets/awaf/tags/xNavTab_1000/" prefix="nt"/>
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../assets/awaf/tags/xEditTable/" prefix="et" />

<!---<cfset qJR = application.com.WorkOrder.GetServiceRequest(url.id)/>--->
<!---<cfset qA = application.com.Asset.GetAllAsset()/>--->
<cfset qCU = application.com.User.GetUsers()/>
<cfset qAL = application.com.Asset.GetLocationInGroup(' &mdash; ')/>

<cfif url.id eq 0><br/></cfif>

<f:Form id="#jrId#frm" action="modules/ajax/maintenance.cfm?cmd=SaveServiceRequest" EditId="#url.id#">

<table width="100%" border="0">
  <tr>
    <td width="50%" valign="top">
      <f:select name="ServiceType" label="Type of Request" required Listvalue="MR,JR" listDisplay="Material Request,Job Request" onchange="#jrId#changePT(this)"/>

    </td>
    <td valign="top">

    </td>
  </tr>
  </table>
  <div id="#jrId#mr" style="display:none;" >
  <table width="100%"border="0">
  <tr>
    <td valign="top" colspan="2">

    <div class="alert alert-warning">NB: The materials below should be non work related, for work related materials, use Work Order</div>
        <et:Table allowInput height="200px" id="ServiceRequestItem">
            <et:Headers>
                <et:Header title="Material needed" size="8" type="text"/>
                <et:Header title="Unit price" size="2" type="float"/>
                <et:Header title="Qty" size="1" type="int" />
                <et:Header title="" size="1"/>
            </et:Headers>
        </et:Table>
    </td>
  </tr>
  <tr>
    <td valign="top" colspan="2">&nbsp;</td>
  </tr>
  <tr>
    <td valign="top" width="50%">
      	<f:TextArea name="Description" label="Reason for Request" class="span11" rows="5" required/>
        <f:Select name="Category" label="Category" required ListValue="m,s" listDisplay="Material Related,Services" class="span11" />
    </td>
    <td class="horz-div" valign="top" width="50%">
		<f:DatePicker name="DateNeeded" label="Date needed" required help="When do you need this materials"/>
        <f:Select name="Priority" label="Priority" required ListValue="h,m,l" listDisplay="High,Medium,Low" class="span5" help="<span style='color:red'>High</span> - Must be done within 48 hours<br/> <span style='color:green'>Medium</span> - Within the week.<br/> <span style='color:gray'>Low</span> - When you get a chance."/>
    </td>
  </tr>
  </table>
  </div>
  <div id="#jrId#sr" style="display:none;">
 <table width="100%" border="0">
 <tr>
 	<td colspan="2">
<cfquery name="qA">
	SELECT
    	CONCAT(a.Description,' @ ',l.Name,' ', IFNULL(al.LocDescription,'')) Asset, a.AssetId, al.AssetLocationId
    FROM asset a
    LEFT JOIN asset_location al ON (al.AssetId = a.AssetId)
    INNER JOIN location l ON (l.LocationId = al.LocationId)
    WHERE al.Status = "Online"
</cfquery>
<f:Select name="AssetLocationId" label="Asset" required ListValue="#valuelist(qA.AssetLocationId,'`')#" autoselect delimiters="`" ListDisplay="#valuelist(qA.Asset,'`')#" class="span10"/>
</td>
 </tr>
  <tr>
    <td valign="top" width="50%">
      <f:Select name="Priority" label="Priority" required ListValue="h,m,l" listDisplay="High,Medium,Low" class="span5" help="<span style='color:red'>High</span> - Must be done within 48 hours<br/> <span style='color:green'>Medium</span> - Within the week.<br/> <span style='color:gray'>Low</span> - When you get a chance."/>
      </td>
    <td class="horz-div" valign="top" width="50%">
    <!---<f:CheckBox name="LocationIds" ListValue="#qAL.value#" ListDisplay="#qAL.display#" showlabel label="Location of Asset" delimiters="`" height="440px"/>--->
    <f:TextArea name="Description" label="Nature of work / Observation" class="span11" rows="13" required/></td>
  </tr>
  </table>
  </div>

<cfif url.id eq 0>
    <f:ButtonGroup>
        <f:Button id="yy" beforeSave="if (!confirm('This record can not be edited after saving. \nDo you want to save this record?')) return True"   value="Create Request" class="btn-primary" IsSave/>
    </f:ButtonGroup>
</cfif>
</f:Form>
<script>
	function #jrId#changePT(d)	{
		var mr_ = $("#jrId#mr"),sr_ = $("#jrId#sr");
		if(d.value == 'MR')	{
		 	sr_.setStyle('display','none');
			mr_.setStyle('display','block');
		}
		else	{
		 	mr_.setStyle('display','none');
			sr_.setStyle('display','block');
		}
	}

</script>
</cfoutput>
