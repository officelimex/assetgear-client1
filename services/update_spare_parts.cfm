<cfsetting requesttimeout="99999999999"/>
<cfquery name="qA">
  SELECT * FROM asset WHERE ItemIds IS NOT NULL
</cfquery>

<cfquery name="qI">
  SELECT * FROM whs_item WHERE AssetIds IS NOT NULL
</cfquery>
<style>body{font-size:9px;}</style>
<cfoutput>

  <cfloop query="qA">

    <cfloop list="#qA.ItemIds#" item="id">
      <cfset _id = trim(id)>
      <cfif val(_id)>
        <cfquery>
          INSERT IGNORE INTO spare_part SET 
            AssetId = #qA.AssetId#,
            ItemId  = #_id#
        </cfquery>

      </cfif>
    </cfloop>
    .
    <cfflush/>
  </cfloop>
  --- asset done ---
  <cfloop query="qI">

    <cfloop list="#qI.AssetIds#" item="id">
      <cfset _id = trim(id)>
      <cfif val(_id)>
        <cfquery>
          INSERT IGNORE INTO spare_part SET 
            ItemId = #qI.ItemId#,
            AssetId  = #_id#
        </cfquery>

      </cfif>
    </cfloop>
    .
    <cfflush/>
  </cfloop>
  --- item done ---

</cfoutput>