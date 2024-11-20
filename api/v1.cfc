component extends="assetgear.awaf2.com.odata.API" {

	static.token = "Bearer M7ObSv5Fnq7UHwr0tqGE==" 

	private boolean function access()	{

		var hd = GetHttpRequestData()

		var rt = false 
		if (isdefined("hd.headers.authorization"))	{
			if(hd.headers.authorization == static.token)	{

				rt = true

			}
		}

		return rt
	}

	remote any function Item(
			numeric id = 0,
			string $select = '
				ItemId, Status, Obsolete, DateAdded, Description, 
				VPN, Reference, QOR, QOH, Currency, UnitPrice,
				itemCode, um, asset
		 ',
			string $orderBy = '',
			string $filter = '', 
			string $expand = '', 
			numeric $top = 0,
			numeric $skip = 0
		) returnFormat="json"	{
		
		if(this.access())	{

			var field_map = {
				'itemCode' 		: 'i.Code',
				'umCode' 			: 'um.Code',
				'itemStatus' 	: 'i.Status',
				'assets.id' 	: 'assets.AssetId',
				'assets.name' : 'assets.Description'
			}
			
			var _order_by = getOrderBy(arguments.$orderBy) 
			var _filter 	= getFilter(arguments.$filter, arguments.id, field_map)
			var _limit	 	= getLimit(arguments.$skip, arguments.$top)

			myQuery = queryExecute("
				SELECT
					i.Status, Obsolete, DateAdded, i.Description, 
						i.ItemId, VPN, Reference, QOR, QOH, Currency, UnitPrice,
						i.Code itemCode, i.UMId, 
					um.Code UMCode, 
						AssetIds,
						GROUP_CONCAT(assets.Description) AssetName,
						GROUP_CONCAT(assets.AssetId) AssetId
				FROM whs_item i
				INNER JOIN um 								ON um.UMId 		= i.UMId
				LEFT JOIN spare_part sp 			ON sp.ItemId 	= i.ItemId
				LEFT JOIN asset assets				ON sp.AssetId = assets.AssetId
				#_filter#
				GROUP BY i.ItemId
				#_order_by#
				#_limit#
			",
				{},
				{returntype : "array_of_entity"}
			)
			var rt = []
			for(x in myQuery)	{
				y = {"@odata.id": "#application.site.url#api/v1.cfc?method=Item&id=#x.ItemId#"}
				loop list="#arguments.$select#" item="fld"	{
					fld = trim(listfirst(fld,' '))
					if(fld == "um")	{
						y.um = {
							"Code": x.umCode,
							"Id": x.umId
						}
					}
					else if(fld == "asset")	{

						_x = []
						if(isdefined("x.AssetId"))	{
							loop list="#x.AssetId#" item="l" index="i"	{
								_x.append({
									"@odata.id" : "#application.site.url#api/v1.cfc?method=Asset&id=#val(l)#",
									"Id" : val(l),
									"Name" : listGetAt(x.AssetName, i)
								})
							}
						}
						y["Assets"] = _x
					}
					else {
						y[fld] = x[fld] 
					}
					
				} 
				rt.Append(y) 
			}
		
		}
		else {
			rt = ["WRONG TOKEN"]
		}
  
		return rt
	}

	remote any function jha(
			numeric id = 0,
			string $select = '
				ItemId, Status, Obsolete, DateAdded, Description, 
				VPN, Reference, QOR, QOH, Currency, UnitPrice,
				itemCode, um, asset
		 ',
			string $orderBy = '',
			string $filter = '', 
			string $expand = '', 
			numeric $top = 0,
			numeric $skip = 0
		) returnFormat="json"	{
		
		if(this.access())	{

			var field_map = {
				'itemCode' 		: 'i.Code',
				'umCode' 			: 'um.Code',
				'itemStatus' 	: 'i.Status',
				'assets.id' 	: 'assets.AssetId',
				'assets.name' : 'assets.Description'
			}
			
			var _order_by = getOrderBy(arguments.$orderBy) 
			var _filter 	= getFilter(arguments.$filter, arguments.id, field_map)
			var _limit	 	= getLimit(arguments.$skip, arguments.$top)

			myQuery = queryExecute("
				SELECT
					i.Status, Obsolete, DateAdded, i.Description, 
						i.ItemId, VPN, Reference, QOR, QOH, Currency, UnitPrice,
						i.Code itemCode, i.UMId, 
					um.Code UMCode, 
						AssetIds,
						GROUP_CONCAT(assets.Description) AssetName,
						GROUP_CONCAT(assets.AssetId) AssetId
				FROM whs_item i
				INNER JOIN um 								ON um.UMId 		= i.UMId
				LEFT JOIN spare_part sp 			ON sp.ItemId 	= i.ItemId
				LEFT JOIN asset assets				ON sp.AssetId = assets.AssetId
				#_filter#
				GROUP BY i.ItemId
				#_order_by#
				#_limit#
			",
				{},
				{returntype : "array_of_entity"}
			)
			var rt = []
			for(x in myQuery)	{
				y = {"@odata.id": "#application.site.url#api/v1.cfc?method=Item&id=#x.ItemId#"}
				loop list="#arguments.$select#" item="fld"	{
					fld = trim(listfirst(fld,' '))
					if(fld == "um")	{
						y.um = {
							"Code": x.umCode,
							"Id": x.umId
						}
					}
					else if(fld == "asset")	{

						_x = []
						if(isdefined("x.AssetId"))	{
							loop list="#x.AssetId#" item="l" index="i"	{
								_x.append({
									"@odata.id" : "#application.site.url#api/v1.cfc?method=Asset&id=#val(l)#",
									"Id" : val(l),
									"Name" : listGetAt(x.AssetName, i)
								})
							}
						}
						y["Assets"] = _x
					}
					else {
						y[fld] = x[fld] 
					}
					
				} 
				rt.Append(y) 
			}
		
		}
		else {
			rt = ["WRONG TOKEN"]
		}
  
		return rt
	}

}