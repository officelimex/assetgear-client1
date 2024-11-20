<cfscript>
	myQuery = queryExecute("
		SELECT

			user.Surname, user.OtherNames,
			user.Gender,
			employee.EmployeeType, employee.LastPromotion, employee.MaritalStatus,
				employee.Manager2Id, employee.Confirmed,
				employee.ExitDate, employee.ManagerId, employee.EmployeeId,
				employee.Manager3Id, employee.EmployeeNumber, employee.DateHired, employee.Phone,
				employee.Address, employee.ExitType, employee.UserId,
			job_title.Name JobTitle, job_title.JobTitleId,
			job_level.Name JobLevelId, job_level.JobLevelId,
			department.Name Department, department.DepartmentId,
			unit.Name Unit, unit.UnitId,
			company.Name Company,
			location.Name Location,
			grade_level.Name GradeLevel, grade_level.GradeLevelId,
			el.Name EntryLevel

		FROM employee
		INNER JOIN user 						ON user.UserId 									= employee.UserId
		LEFT JOIN job_title 				ON employee.JobTitleId 					= job_title.JobTitleId
		LEFT JOIN job_level 				ON employee.JobLevelId 					= job_level.JobLevelId
		LEFT JOIN department 				ON employee.DepartmentId 				= department.DepartmentId
		LEFT JOIN unit 							ON employee.UnitId 							= unit.UnitId
		LEFT JOIN company_location 	ON employee.CompanyLocationId 	= company_location.CompanyLocationId
		LEFT JOIN company 					ON company.CompanyId 						= company_location.CompanyId
		LEFT JOIN location 					ON location.LocationId 					= company_location.LocationId
		LEFT JOIN grade_level 			ON grade_level.GradeLevelId 		= employee.GradeLevelId
		LEFT JOIN grade_level el		ON el.GradeLevelId 							= employee.EntryLevelId
		WHERE user.Email = :email
		LIMIT 0,1
	",
		{email: request.email},
		{returntype : "array_of_entity"}
	)

	if (!myQuery.len())	{
		myQuery = ["NO DATA"]
	}
	else {

		myQuery[1]["Roles"] = queryExecute("
			SELECT
				role.RoleId Id, role.Name Title
			FROM user_role
			INNER JOIN user ON user.UserId = user_role.UserId
			INNER JOIN role ON role.RoleId = user_role.RoleId
			WHERE user_role.UserId = #myQuery[1].UserId#
		",
			{},
			{returntype : "array_of_entity"}
		)
	}

</cfscript>