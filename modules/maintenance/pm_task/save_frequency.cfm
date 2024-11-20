<!--- 
	Author: Arowolo Abiodun
	Created: 2011/09/30
	Modified: 2011/09/30
	-> edit a page 
--->
<cfparam default="0" name="url.id"/>
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />

<cfset frqId = '__pm_task_c_frequency' & url.id/>

<cfquery name="qP">
	SELECT * FROM frequency
    WHERE FrequencyId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>


<cfoutput>

<f:Form id="#frqId#frm" action="modules/ajax/settings.cfm?cmd=SaveFrequency" EditId="#url.id#"> 
<!---<cfdump var="#DayOfWeekAsString(DayOfWeek(now()))#"/>--->
	<table width="100%" border="0">
    	<tr>
        	<td width="50%" valign="top">
    <f:TextBox name="Code" label="Code" required value="#qP.Code#" class="span4"/> 
    <f:TextArea name="Description" label="Description" required value="#qP.Description#"/>
    <f:TextBox name="Years" label="Years" value="#qP.Years#" validate="integer" class="span2"/>
    <f:TextBox name="Quarters" label="Quarters" value="#qP.Quarters#" validate="integer" class="span2"/>
    		</td>
            <td class="horz-div" valign="top">
    <f:TextBox name="Months" label="Months" value="#qP.Months#" validate="integer" class="span2"/>
    <f:TextBox name="Weeks" label="Weeks" value="#qP.Weeks#" validate="integer" class="span2"/>
    <f:TextBox name="Days" label="Days" value="#qP.Days#" validate="integer" class="span2"/>
    <f:TextBox name="Hours" label="Hours" value="#qP.Hours#" validate="integer" class="span2"/>
    <f:TextBox name="Minutes" label="Minutes" value="#qP.Minutes#" validate="integer" class="span2"/>
    		</td>
        </tr>
    	<tr>
    	  <td colspan="2" valign="top"><f:CheckBox name="WorkingDaysOnly" ListValue="yes" ListDisplay="Working days only" Selected="#qP.WorkingDaysOnly#"/></td>
   	  </tr>
    </table>
</f:Form>

</cfoutput>