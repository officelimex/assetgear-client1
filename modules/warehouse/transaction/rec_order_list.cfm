<cfoutput>
    
    <cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />

    <cfset IssID = '__transaction_c'/>
    <cfset pgId = 'rec_order_list'/>
    
    <cfquery name="qI" cachedwithin="#CreateTime(1,0,0)#">
        #application.com.Item.WAREHOUSE_ITEM_SQL#
        WHERE (whi.MinimumInStore <> 0) AND (whi.QOH < whi.MinimumInStore) 
    </cfquery>

    <f:Form id="#pgId#frm" action="modules/warehouse/transaction/report/order_level_report.cfm" target="_blank"> 

        <table width="100%" border="0" class="table-hover table-condensed table-striped">
        <thead>
            <tr>
                <th>##</th>
                <th>Description</th>
                <th style="text-align:left;">P/N</th>
                <th>QOH</th>
                <th>Order Point</th>
                <th>QOR</th>
            </tr>
        </thead>
        <tbody>
            <cfloop query="qI">
                <tr>
                    <td>#qI.ItemId#</td>
                    <td>#qI.Description#</td>
                    <td>#qI.VPN#</td>
                    <td>#qI.QOH#</td>
                    <td>#qI.MinimumInStore#</td>
                    <td>#qI.QOR#</td>
                </tr>
            </cfloop>
        </tbody>
        </table>
        
        <f:ButtonGroup>
            <f:Button value="Show Report" class="btn-primary" IsNewWindow/>
        </f:ButtonGroup>
            
    </f:Form> 

</cfoutput>