<cfoutput>
<cfquery name="q">
	SELECT * FROM whs_issue 
</cfquery>

<cfloop query="q">
    <cfquery name="qIItem">
        SELECT * FROM whs_issue_item WHERE IssueId = #q.IssueId#
    </cfquery>
    <cfset dtotal = ntotal = 0/>
    <cfloop query="qIItem">
        <cfquery name="qI">
            SELECT UnitPrice,Currency FROM whs_item WHERE ItemId = #qIItem.ItemId#
        </cfquery>
        <cfquery>
            UPDATE whs_issue_item SET 
                UnitPrice = <cfqueryparam cfsqltype="cf_sql_float" value="#qI.unitprice#"/>,
                Currency = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qI.Currency#"/>
            WHERE ItemIssueId = #qIItem.ItemIssueId#
        </cfquery>
        <cfif qI.Currency eq "NGN">
            <cfset ntotal = ntotal + (qI.unitprice*qIItem.Quantity)/>
        <cfelse>
            <cfset dtotal = dtotal + (qI.unitprice*qIItem.Quantity)/>
        </cfif>
    
    </cfloop>
    <!--- save total price --->
    <cfquery>
        UPDATE whs_issue SET 
            USDTotal = #val(dtotal)#,
            NGNTotal = #val(ntotal)#
        WHERE IssueId = #val(qIItem.IssueId)#
    </cfquery>
</cfloop>
</cfoutput>
am done...