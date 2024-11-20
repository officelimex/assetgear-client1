

<cfparam default="0" name="url.id"/>

<cfparam name="url.cid" default=""/>
<cfparam name="url.filter" default=""/>
<cfset woId = "__workorder_c_all_workorder#url.cid##url.filter#" & url.id/>
 
<cfset Id1 = "#woId#_1"/>
<cfset Id2 = "#woId#_2"/>
<cfset Id4 = "#woId#_4"/>
<cfset Id3 = "#woId#_3"/>
<cfset Id5 = "#woId#_5"/>

 
<cfoutput>
<cfimport taglib="../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../assets/awaf/tags/xEditTable/" prefix="et" />
<cfimport taglib="../../../assets/awaf/tags/xUtil/" prefix="util" />
 
<cfset qWO = application.com.WorkOrder.GetWorkOrder(url.id)/>
<cfset qOI = application.com.WorkOrder.GetWorkOrderItems(url.id)/> 
 
<cfquery name="qAS">
	SELECT *
    FROM asset
    WHERE AssetId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qWO.AssetId#"/>
</cfquery>

<cfquery name="qAl">
	SELECT l.`Name` 
    FROM asset_location a 
    INNER JOIN location l on a.LocationId=l.LocationId 
    WHERE AssetLocationId 
    IN (#qWO.AssetLocationIds#)
</cfquery>

<cfset qSU = application.com.User.GetUser(val(qWO.SupervisedByUserId))/> 
<cfset qCU = application.com.User.GetUser(val(qWO.ClosedByUserId))/>
  
 
<cfset qL = application.com.WorkOrder.GetLabourers(qWO.WorkOrderId)/>
<cfif url.id eq 0>
	<br/>
</cfif>
<cfset AssetLocation =""/>
<cfloop query="qAl">
	<cfset AssetLocation = AssetLocation & "#qAl.Name#, "/>
</cfloop>

<f:Form id="#woId#frm" action="modules/ajax/maintenance.cfm?cmd=SaveWorkOrder" EditId="#url.id#"> 
  <div id="#Id1#">
        <table width="100%" border="0">
          <tr>
            <td width="50%" valign="top"> 
                <f:Label name="Work Description" value="#qWO.Description#"/>
                <f:Label name="Asset" value="#qAS.Description#"/>
                <f:Label name="Asset Location" value="#AssetLocation# "/> 
            </td>
            <td class="horz-div" valign="top"> 
                <f:Label name="Service Request ##" label="Service Request ##" value="#qWO.ServiceRequestId#" />
                <f:Label name="Work Class" value="#qWO.JobClass#" />
                <f:Label name="Date Opened" value="#dateformat(qWO.DateOpened,'dd/mmm/yyyy')#"/>
            </td>
          </tr> 
          <tr>
            <td colspan="2">
            </td>
          </tr>
          <tr>
            <td colspan="2"> 
              <f:label name="Work Details" value="#qWO.WorkDetails#" class="span10" rows="6"/>
            </td>
          </tr>
        </table>
    </div>
    <div id="#Id2#" >
        <table width="100%" border="0">
          <tr>
            <td valign="top" style="padding-left:10px;">
                <table class="table"><thead><tr>
                    <th>Spare parts</th>
                    <th>Purpose</th>
                    <th>Quantity</th>
                    <th>Status</th>
                  </tr></thead>
                  <cfloop query="qOI">
                  <tr><td>#qOI.Item#</td>
                    <td>#qOI.Purpose#</td>
                    <td>#qOI.Quantity#</td>
                    <td>#qOI.Status#</td>
                  </tr></cfloop>
                </table>
    
            </td>
          </tr> 
        </table> 

    </div>    
    <div id="#Id3#" >
        <table width="100%" border="0">
          <tr>
            <td valign="top" style="padding-left:10px;">
                <table class="table"><thead><tr>
                    <th>Employee</th>
                    <th>Function</th>
                    <th>Hours</th>
                  </tr></thead>
                  <cfloop query="qL">
                  <tr><td>#qL.User#</td>
                    <td>#qL.Function#</td>
                    <td>#qL.Hours#</td>
                  </tr></cfloop>
                </table>
    
            </td>
          </tr> 
        </table> 

    </div>
    
    <div id="#Id4#"> 
    	<util:FileView type="a" table="work_order" pk="#url.id#" source="doc/attachment/" column="4"/>
        <!---<u:UploadFile id="Attachments" table="work_order" pk="#url.id#" />--->
    </div>
    
    <div id="#Id5#" align="left">
        <table width="100%" border="0">
          <tr>
            <td width="50%" valign="top">
            <f:Label name="Supervised By" value="#qSU.UserName#"/>
            <f:Label name="DateClosed" value="#dateformat(qWO.DateClosed,'dd/mmm/yyyy')#"/>
            </td>
            <td class="horz-div" valign="top"> 
            <f:Label name="Closed By" value="#qCU.UserName#" /></td>
          </tr>
          <tr>
            <td colspan="2" valign="top">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2" valign="top"><f:Label name="Work Done" value="#qWO.WorkDone#" /></td>
          </tr> 
          
          
        </table>
    
    </div> 
    
    <nt:NavTab renderTo="#woId#">
        <nt:Tab>
            <nt:Item title="Open Session" isactive/>
            <nt:Item title="Part Session"/>
            <nt:Item title="Labour Session"/>
            <nt:Item title="Documents"/>
            <nt:Item title="Close Session"/> 
        </nt:Tab>
        <nt:Content>
            <nt:Item id="#Id1#" isactive/>
            <nt:Item id="#Id2#"/>
            <nt:Item id="#Id3#"/>
            <nt:Item id="#Id4#"/>
            <nt:Item id="#Id5#"/>
        </nt:Content>
    </nt:NavTab>
    
</f:Form>

<script>
	/* $$('##__workorder_c_all_workorder#url.cid##url.filter#_#url.id# div.dbx-but-frame a.btn').setStyle('display','none'); */
 
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
</script></cfoutput>