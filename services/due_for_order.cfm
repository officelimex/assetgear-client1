<cfscript>

  now = dateformat(now(), 'd/m')
  // writedump(now)
  // FOR item shortage
  //if(listFindNoCase('1/1,1/3,1/6,1/9,1/12', now)) {
    query name="q" {
      echo("
        SELECT 
          i.ItemId, i.QOH, i.MinimumInStore, i.Description, i.Code, i.VPN, i.QOR
        FROM whs_item i 
        LEFT JOIN whs_mr_item mri ON mri.ItemId = i.ItemId 
        LEFT JOIN whs_mr mr       ON mr.MRId    = mri.ItemId
        WHERE 
          i.Obsolete = 'No' AND 
          i.`Status` = 'Online' AND
          i.MinimumInStore > QOH AND 
          i.MinimumInStore <> 0 AND 
          (mr.Status IS NULL OR mr.Status <> 'Close')
          AND i.QOR < i.MinimumInStore
      GROUP BY i.ItemId
      ")
    }

    if(q.recordcount) {
      d = "";
      for(x in q) {
        d = listAppend(d, "<li>[#x.Code#] #x.Description# (PN:#x.VPN#)</li>"," ")
      }
      d = "<ul>#d#</ul>"
      application.com.Notice.SendEmail("materials-logistics@#application.domain#","Items need to be Re-Ordered","
        Hi,<br/><br/>
        Kindly find below items that requires your attention for re-order
        <hr/>
        #d#
        <br/>
        Regards
      ")
    }
  //}

  // for mr not closd out and more than 30days

</cfscript>