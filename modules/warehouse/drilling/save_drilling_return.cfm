<cfparam default="0" name="url.id"/>

<cfparam name="url.cid" default=""/>
<cfset drId = "__drilling_c_all_drilling_return#url.cid#" & url.id/>

<cfoutput>
    <cfimport taglib="../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
    <cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />
    <cfimport taglib="../../../assets/awaf/tags/xUploader_1000/" prefix="u" />
    <cfimport taglib="../../../assets/awaf/tags/xEditTable/" prefix="et" />

<cfquery name="qWhs">
	SELECT * FROM drilling_return
    WHERE DReturnedId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>

<cfquery name="qWI">
    SELECT 
		*
	FROM 
		drilling_returned_item
    WHERE DReturnedId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Id#">
</cfquery> 
<cfquery name="qNames">
	SELECT *,CONCAT(Surname,' ',OtherNames) AS Names FROM core_user
</cfquery>


<cfif url.id eq 0>
	<br/>
</cfif>
<f:Form id="#drId#frm" action="modules/ajax/warehouse.cfm?cmd=SaveDrillingReturns" EditId="#url.id#"> 
<div>
<br>
<table width="100%" border="0">
  <tr>
    <td width="50%" valign="top"> 
        <f:TextBox name="ReturedBy" label="Delivered By" required value="#qWhs.ReturedBy#" class="span11"/>
        <f:DatePicker name="ReturedDate" label="Delivery Date" required value="#dateformat(qWhs.ReturedDate,'yyyy/mm/dd')#"/>
        <f:Select name="RecievedById" autoselect required label="Recieved By" selected="#qWhs.RecievedById#" listvalue="#ValueList(qNames.UserId)#" ListDisplay="#ValueList(qNames.Names)#" class="span10"/>
    </td>
    <td class="horz-div" valign="top"> 
        <f:TextArea name="Comment" label="Comment" help="Leave a comment on the returned items if any" value="#qWhs.Comment#" class="span11" rows="4"/>
    </td>
  </tr> 
  <tr>
  	<td colspan="2"> 
     
        <et:Table allowInput height="130px" id="DReturnedItemId" >
            <et:Headers>
               <et:Header title="Item Description" size="8" />
               <et:Header title="Qty" size="1" type="int"/>
                <et:Header title="Status" size="2" type="text">
                    <et:Select ListValue="Used,Un-Used"/>
                </et:Header>
                <et:Header title="" size="1"/>
            </et:Headers>
            <et:Content Query="#qWI#" Columns="ItemDescription,Qty,Status" type="text,int,text" PKField="DReturnedId"/>  
        </et:Table>    
    </td>
  </tr>
</table>

</div>

<cfif url.id eq 0>
	<f:ButtonGroup>
		<f:Button value="Create new Return" class="btn-primary" IsSave/>
	</f:ButtonGroup>
</cfif>


</f:Form>

</cfoutput>