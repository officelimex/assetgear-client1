<cfset IssID = '__transaction_c'/>
<cfimport taglib="../../../../assets/awaf/tags/xGrid_1001/" prefix="g" />

<cfoutput>

   <g:Grid renderTo="#IssID#_material_issue" url="modules/ajax/warehouse.cfm?cmd=getMaterialIssue" commandWidth="70px" class="table-hover table-condensed" firstsortOrder="DESC">
   	<g:Columns>
   		<g:Column id="IssueID" caption="##" field="IssueId" sortable searchable/>
         <g:Column id="MRId" Caption="MR ##" searchable field="m.MRId" hide/>
         <g:Column id="WorkOrderId" caption="WO ##" searchable field="mi.WorkOrderId"/>
         <g:Column id="Remark"/>
         <g:Column id="DateIssued" caption="Date Issued"/>
         <g:Column id="IssuedBy" caption="Issued By" hide/>
         <g:Column id="IssuedTo" caption="Received by"/>
         <g:Column id="USDTotal" caption="Total ($)"/>
         <g:Column id="NGNTotal" caption="Total (&##8358;)"/>
   	</g:Columns>
      <g:Commands>
         <g:Command id="addIssue" help="New Material Issue" pin icon="plus-sign"/>
         <g:Command id="viewIssue" icon="file" help="View Material Issue"/>
         <g:Command id="printIsue" icon="print" help="Print Material Issue"/>
      </g:Commands>

      <g:Event command="addIssue">
         <g:Window title="'New Material Issue'" width="850px" height="440px" url="'modules/warehouse/transaction/issue/save_material_issue.cfm'" IdFromGrid="">
            <g:Button IsSave IsNewForm/>
         </g:Window>
      </g:Event>

      <g:Event command="viewIssue">
         <g:Window title="'Material Issue For ' + d[0]" width="850px" height="440px" url="'modules/warehouse/transaction/issue/view_material_issue.cfm'"/>
      </g:Event>

      <g:Event command="printIsue">
         <g:Window IsNewWindow url="'modules/warehouse/transaction/issue/print_material_issue.cfm'"/>
      </g:Event>

   </g:Grid>

</cfoutput>
