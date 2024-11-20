<!--- 
	Author: Arowolo Abiodun
	Created: 2011/09/30
	Modified: 2011/09/30
	->  
--->
<cfparam default="0" name="url.id"/>
<cfset whsId = "__material_c_warehouse_item" & url.id/>

<cfset Id1 = "#whsId#_1"/>
<cfset Id2 = "#whsId#_2"/>

<cfoutput>
<cfimport taglib="../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../assets/awaf/tags/xUploader_1000/" prefix="u" />
<cfimport taglib="../../../assets/awaf/tags/xEditTable/" prefix="et"/>
<cfimport taglib="../../../assets/awaf/tags/xPlainGrid_1000/" prefix="pg"/>

<cfset qWI = application.com.Item.GetItem(url.id)/>  


<f:Form id="#whsId#frm" action="modules/ajax/warehouse.cfm?cmd=CorrectItem" EditId="#url.id#"> 
	<div id="#Id1#">
    <table border="0" width="100%">
        <tr>
            <td width="50%" valign="top">
            	<f:label name="Description" value="#qWI.Description# <br/> &mdash; #qWI.VPN# <br/><br/>"/>    	 
				<f:DatePicker name="Date" label="Date Adjusted" required value="#dateformat(now(),'dd/mmm/yyyy')#"/>
                <f:TextArea name="Reason" label="Reason for adjustment" required/>								
            </td>
            <td class="horz-div" width="50%" valign="top">            	
                <f:TextBox name="QOH" label="Qty on hand" required value="#qWI.QOH#" validate="numeric" class="span3"/> 
                <f:TextBox name="QOR" label="Qty on request" required value="#qWI.QOR#" validate="numeric" class="span3"/>
				
				<f:RadioBox name="Currency" inline showlabel label="Currency" required selected="#qWI.Currency#" ListValue="NGN,USD" ListDisplay="Naira,US Dollar" />
				<f:TextBox name="UnitPrice" label="Unit price" required value="#trim(numberformat(qWI.UnitPrice,'9,999.99'))#" validate="numeric" class="span4"/> 
            					            	
            </td>
       </tr> 
    </table>
    </div>
	
	<div id="#Id2#" style="height:230px;"">
		<cfquery name="qIA">
			SELECT 
				CONCAT(u.Surname," ",u.OtherNames) AdjustedBy,
				ia.*
			FROM whs_inventory_adjustment ia
			INNER JOIN core_user u ON u.UserId = ia.AdjustedByUserId
			WHERE ItemId = <cfqueryparam  cfsqltype="cf_sql_integer" value="#url.id#"/>
			ORDER BY Date DESC
			LIMIT 0,50
		</cfquery>
		<pg:PlainGrid datasource="#qIA#" >
			<pg:Columns>
				<pg:Column caption="##" value="Currentrow"/>
				<pg:Column value="Date" format="date"/>
				<pg:Column caption="Adjusted by" value="AdjustedBy"/>
				<pg:Column caption="Reason" value="Reason"/>
				<pg:Column value="QOH" align="right"/>
				<pg:Column value="QOR" align="right"/>
				<pg:Column value="UnitPrice" caption="Unit Price" align="right" format="money"/>
			</pg:Columns>
		</pg:PlainGrid>
	</div>
	
	<nt:NavTab renderTo="#whsId#">
		<nt:Tab>
			<nt:Item title="Item to Correct" isactive/>
			<nt:Item title="Correction History"/>
		</nt:Tab>
		<nt:Content>
			<nt:Item id="#Id1#" isactive/>
			<nt:Item id="#Id2#"/> 
		</nt:Content>
	</nt:NavTab>
 
 </f:Form>

</cfoutput>
