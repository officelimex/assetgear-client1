<cfsetting requesttimeout="9999999999"/>

<cfquery name="qW">
	SELECT * FROM work_order where DateOpened > "2024/1/1" 
</cfquery>
<cfquery name="qwi_p">
    SELECT 
       wi.ItemId, i.UnitPrice  
    FROM work_order_item wi 
    INNER JOIN whs_item i ON i.ItemId = wi.ItemId
    WHERE wi.ItemId IS NOT NULL AND wi.UnitPrice = 0 AND i.UnitPrice <>0
</cfquery>
<cfloop query="qwi_p">
    <cfquery>
        UPDATE work_order_item SET
            UnitPrice = #VAL(qwi_p.UNITPRICE)# 
        WHERE ItemId = #qwi_p.ItemId# AND UnitPrice = 0
    </cfquery>
</cfloop>
<cfoutput>
<cfloop query="qW">
	<!--- get cost of material in the warehose --->
    <cfquery name="q1">
    	SELECT SUM(i.UnitPrice*wi.Quantity) tp FROM work_order_item wi
        INNER JOIN whs_item i ON i.ItemId = wi.ItemId
        WHERE wi.ItemId IS NOT NULL  and wi.WorkOrderId = #qW.WorkOrderId#
    </cfquery>
    
    <!--- get cost of materil not in warehouse --->
    <cfquery name="q2">
    	SELECT SUM(wi.UnitPrice*wi.Quantity) tp FROM work_order_item wi 
        WHERE ItemId IS NULL and wi.WorkOrderId = #qW.WorkOrderId#
    </cfquery>
    
    <!--- get man power cost --->
    <cfquery name="q3">
    	SELECT SUM((l.Hours*29000)) tp FROM labour l
        WHERE l.WorkOrderId = #qW.WorkOrderId#
    </cfquery> 
    
    <!--- get contractor cost --->
    <cfquery name="q4">
    	SELECT SUM(Cost) tp FROM contract 
        WHERE  WorkOrderId = #qW.WorkOrderId#
    </cfquery> 
    <cfset tc = val(q1.tp) + val(q2.tp) + val(q3.tp) + val(q4.tp) /> 
    <!--- update wo --->
    <cfquery>
    	UPDATE work_order SET
        	 TotalCost = #tc#,
             ManHours = (SELECT SUM(Hours) FROM labour WHERE WorkOrderId = #qW.WorkOrderId#)
        WHERE WorkOrderId = #qW.WorkOrderId#
    </cfquery>
    #dateformat(qW.DateOpened,'dd-mmm-yyyy')# : #qW.WorkOrderId# : #numberformat(tc,'9,999.99')#<br/>
    <cfflush />
    
</cfloop>
</cfoutput>