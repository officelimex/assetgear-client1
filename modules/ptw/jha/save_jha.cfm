<!--- 
	Author: Arowolo Abiodun
	Created: 2011/09/30
	Modified: 2011/09/30
	-> edit a JHA, create JHA
--->
<cfparam default="0" name="url.id"/> 

<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f"/>
<cfimport taglib="../../../assets/awaf/tags/xEditTable/" prefix="et"/>
<cfimport taglib="../../../assets/awaf/tags/xUploader_1000/" prefix="u" />

<cfset locId = '__jha_c_all_jha' & url.id/>

<cfset qJS = application.com.Permit.GetJHA(url.id)/>
<cfset qJ = application.com.Permit.GetJHAList(url.id)/>

<cfoutput>
<cfif url.id eq 0><br/></cfif>
<f:Form id="#locId#frm" action="modules/ajax/ptw.cfm?cmd=saveJHA" EditId="#url.id#"> 
	<table width="100%"  border="0">
    	<tr>
        	<td width="26%" >
    			<f:TextBox name="WorkOrderId" label="Work Order ##" required value="#qJS.WorkOrderId#" class="span9"/>
            </td>
            <td class="horz-div" valign="top">
                <f:TextBox name="EquipmentToUse" required label="Equipment/Tools to be used" value="#qJS.EquipmentToUse#" class="span11" />
            </td> 
        </tr>
        <tr>
        	<td></td>
        </tr>
        <tr>
        	<td colspan="2">
                <et:Table allowInput height="240px" id="JHAList">
                    <et:Headers>
                        <et:Header title="Job Sequence" size="3" type="text"/>
                        <et:Header title="Hazard" size="2" type="text" />
                        <et:Header title="Target" size="1" type="text" hint="P,E,A,R"/>
                        <et:Header title="Risk" size="1" type="text" hint="L,M,H"/>
                        <et:Header title="Consequences" size="2" type="text"/>
                        <et:Header title="Control Measure" size="2" type="text"/>
                        <!---<et:Header title="Responsible Party" size="1" type="text"/>--->                   
                        <et:Header title="" size="1"/>
                    </et:Headers>
                    <et:Content Query="#qJ#" Columns="JobSequence,Hazard,Target,Risk,Consequences,ControlMeasure" type="text,text,text,text,text,text" PKField="JHAListId"/> 
                </et:Table>            	
            </td>
        </tr>
        <tr>
          <td colspan="2">
        <div class="alert alert-info">Attach third party JHA.</div>
        <u:UploadFile id="Attachments" table="ptw_jha" pk="#url.id#" />
          </td>
        </tr>
    	<tr>
        	<td></td>
        </tr>
       
    </table>
   
    <cfif url.id eq 0>
        <f:ButtonGroup>
            <f:Button value="Create new JHA" class="btn-primary" IsSave subpageId="save_jha" ReloadURL="modules/ptw/jha/save_jha.cfm"/>
        </f:ButtonGroup>
    </cfif>
</f:Form>
<div style="display: block; position: absolute; bottom:70px; width:80%; right:20px;">
<div style="float:left">
	<span class="label label-info">Target:</span> P = Personnel, E = Environment, A = Asset, R = Reputation               	
</div>    
<div style="float:right;">
<span class="label label-important">Risk:</span> L = Low, M = Medium, H = High
</div> 
</div>

</cfoutput>