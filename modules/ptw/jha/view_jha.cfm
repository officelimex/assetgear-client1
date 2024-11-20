<!--- 
	Author: Arowolo Abiodun
	Created: 2011/09/30
	Modified: 2011/09/30
	-> edit a page 
--->
<cfparam default="0" name="url.id"/>
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f"/>
<cfimport taglib="../../../assets/awaf/tags/xEditTable/" prefix="et"/>
<cfimport taglib="../../../assets/awaf/tags/xUtil/" prefix="util" />

<cfset locId = '__jha_c_all_jha_' & url.id/>

<cfset qJS = application.com.Permit.GetJHA(url.id)/>
<cfset qJ = application.com.Permit.GetJHAList(url.id)/>

<cfoutput>
<cfif url.id eq 0><br/></cfif>
<f:Form id="#locId#frm" action="modules/ajax/ptw.cfm?cmd=saveJHA" EditId="#url.id#"> 
	<table width="100%"  border="0">
    	<tr>
        	<td width="50%" >
            	<f:Label name="Work Description" value="#qJS.WorkDescription#"/> 
            </td>
            <td class="horz-div" valign="top">
                <f:Label name="Equipment touse" value="#qJS.EquipmentToUse#"/> 
            </td>
        </tr>
        <tr>
        	<td></td>
        </tr>
        <tr>
        	<td colspan="2">
        <table width="100%" border="0">
          <tr>
            <td valign="top" style="padding-left:10px;">
                <table class="table"><thead><tr>
                    <th>Job Sequence</th>
                    <th>Hazard</th>
                    <th>Target</th>
                    <th>Risk</th>
                    <th>Consequences</th>
                    <th>Control Measure</th>
                    <!---<th>Responsible Party</th>--->                    
                  </tr></thead>
                  <cfloop query="qJ">
                  <tr><td>#qJ.JobSequence#</td>
                    <td>#qJ.Hazard#</td>
                    <td>#qJ.Target#</td>
                    <td>#qJ.Risk#</td>
                    <td>#qJ.Consequences#</td>
                    <td>#qJ.ControlMeasure#</td>
                    <!---<td>#qJ.ResponsibleParty#</td>--->
                  </tr>
                  </cfloop>
                </table>
    
            </td>
          </tr>
          <tr>
            <td valign="top" style="padding-left:10px;">
              <util:FileView type="a" table="ptw_jha" pk="#url.id#" source="doc/attachment/" column="4"/> 
            </td>
          </tr> 
        </table> 
          	
            </td>
        </tr>
    	<tr>
        	<td></td>
        </tr>
       
    </table>
 
</f:Form>
<div style="display: block; position: absolute; bottom:70px; width:80%; right:20px;">
<div style="float:left">
	<span class="label label-info">Target:</span> P = Personnel, E = Environment, A = Asset, R = Reputation               	
</div>    
<div style="float:right;">
<span class="label label-important">Risk:</span> L = Low, M = Medium, H = High
</div> 
</div>
<script>
<cfif qJS.Status eq "c">
$$('###locId# div.dbx-but-frame a.btn').setStyle('display','none');</script>
</cfif>
</cfoutput>