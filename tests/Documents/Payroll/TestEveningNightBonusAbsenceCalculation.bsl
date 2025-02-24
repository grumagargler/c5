﻿Call ( "Common.Init" );
CloseAll ();

id = Call ( "Common.ScenarioID", "284ABCA7" );
env = getEnv ( id );
createEnv ( env );

// ********************
// Create a new Payroll
// ********************

Commando ( "e1cib/data/Document.Payroll" );
form = With ( "Payroll (cr*" );

Click ( "#Fill" );
With ( "Payroll: Setup Filters" );
table = Get ( "#UserSettings" );
GotoRow ( table, "Setting", "Department" );
Put ( "#UserSettingsValue", env.Department, table );

Click ( "#FormFill" );
Pause ( __.Performance * 7 );

With ( form );
Click ( "#FormDocumentPayrollPayroll" );
Click ( "OK", Forms.Get1C () );
With ( "Payroll: Print" );
CheckTemplate ( "#TabDoc" );

With ( form );

// *************************
// Procedures
// *************************

Function getEnv ( ID )

	p = new Structure ();
	p.Insert ( "ID", ID );
	p.Insert ( "Date", CurrentDate () );
	p.Insert ( "Department", "_Department " + ID );
	p.Insert ( "Schedule", "_Schedule " + ID );
	p.Insert ( "Employees", getEmployees ( p ) );
	p.Insert ( "MonthlyRate", "_Monthly " + ID );
	p.Insert ( "Bonus", "_Bonus " + ID );
	p.Insert ( "Evening", "_Evening " + ID );
	p.Insert ( "Night", "_Night " + ID );
	return p;

EndFunction

Function getEmployees ( Env )

	id = Env.ID;
	date = Env.Date;
	dateStart = BegOfMonth ( date );
	dateEnd = Date ( 1, 1, 1 );
	
	employees = new Array ();
	employees.Add ( newEmployee ( "_Employee1 " + id, dateStart, dateEnd, 1000 ) );
	employees.Add ( newEmployee ( "_Employee2 " + id, dateStart, dateEnd, 1000 ) );
	return employees;

EndFunction

Function newEmployee ( Name, DateStart, DateEnd, Rate )

	p = new Structure ( "Name, DateStart, DateEnd, Rate" );
	p.Name = Name;
	p.DateStart = DateStart;
	p.DateEnd = DateEnd;
	p.Rate = Rate;
	return p;

EndFunction

Procedure createEnv ( Env )

	id = Env.ID;
	if ( EnvironmentExists ( id ) ) then
		return;
	endif;
	
	// *************************
	// Create Employees
	// *************************
	
	for each employee in Env.Employees do
		p = Call ( "Catalogs.Employees.Create.Params" );
		p.Description = employee.Name;
		Call ( "Catalogs.Employees.Create", p );
	enddo;

	// *************************
	// Create Department
	// *************************
	
	p = Call ( "Catalogs.Departments.Create.Params" );
	p.Description = Env.Department;
	Call ( "Catalogs.Departments.Create", p );

	// *************************
	// Create Compensation
	// *************************
	
	mainCompensation = Env.MonthlyRate;
	eveningCompensation = Env.Evening;
	nightCompensation = Env.Night;
	bonus = Env.Bonus;
	
	p = Call ( "CalculationTypes.Compensations.Create.Params" );
	p.Description = mainCompensation;
	p.Method = "Monthly Rate";
	Call ( "CalculationTypes.Compensations.Create", p );

	// ****************************
	// Create Evening & Night hours
	// ****************************
	
	p = Call ( "CalculationTypes.Compensations.Create.Params" );
	p.Description = eveningCompensation;
	p.Method = "Evening Hours";
	Call ( "CalculationTypes.Compensations.Create", p );

	p = Call ( "CalculationTypes.Compensations.Create.Params" );
	p.Description = nightCompensation;
	p.Method = "Night Hours";
	Call ( "CalculationTypes.Compensations.Create", p );

	// ************
	// Create Bonus
	// ************
	
	p = Call ( "CalculationTypes.Compensations.Create.Params" );
	p.Description = bonus;
	p.Method = "Percent";
	p.Base.Add ( eveningCompensation );
	p.Base.Add ( nightCompensation );
	p.Base.Add ( mainCompensation );
	Call ( "CalculationTypes.Compensations.Create", p );
	
	// *************************
	// Create Schedule
	// *************************

	p = Call ( "Catalogs.Schedules.Create.Params" );
	p.Description = Env.Schedule;
	p.Monday = 8;
	p.MondayEvening = 2;
	p.MondayNight = 2;
	p.Tuesday = 8;
	p.TuesdayEvening = 2;
	p.TuesdayNight = 2;
	p.Wednesday = 8;
	p.WednesdayEvening = 2;
	p.WednesdayNight = 2;
	p.Thursday = 8;
	p.ThursdayEvening = 2;
	p.ThursdayNight = 2;
	p.Friday = 8;
	p.FridayEvening = 2;
	p.FridayNight = 2;
	Call ( "Catalogs.Schedules.Create", p );
	
	// *************************
	// Hiring
	// *************************
	
	department = Env.Department;
	schedule = Env.schedule;
	bonusRate = 5;
	eveningPercent = 20;
	nightPercent = 35;
	params = Call ( "Documents.Hiring.Create.Params" );
	employees = params.Employees;
	for each employee in Env.Employees do
		// Main compensation
		p = Call ( "Documents.Hiring.Create.Row" );
		p.Employee = employee.Name;
		p.DateStart = Format ( employee.DateStart, "DLF=D" );
		p.DateEnd = Format ( employee.DateEnd, "DLF=D" );
		p.Department = department;
		p.Position = "Manager";
		p.Rate = employee.Rate;
		p.Compensation = mainCompensation;
		p.Schedule = schedule;
		
		// Bonus
		addons = p.RowsAdditions;
		additional = Call ( "Documents.Hiring.Create.RowAdditional" );
		additional.Compensation = bonus;
		additional.Rate = bonusRate;
		addons.Add ( additional );
		
		// Evening
		additional = Call ( "Documents.Hiring.Create.RowAdditional" );
		additional.Compensation = eveningCompensation;
		additional.Rate = eveningPercent;
		addons.Add ( additional );

		// Night
		additional = Call ( "Documents.Hiring.Create.RowAdditional" );
		additional.Compensation = nightCompensation;
		additional.Rate = nightPercent;
		addons.Add ( additional );

		employees.Add ( p );
	enddo;
	
	date = Env.Date;
	params.Date = date;
	Call ( "Documents.Hiring.Create", params );
	
	// *******
	// Absence
	// *******
	
	// Find first work day
	absenceDay = BegOfMonth ( date );
	for i = 0 to 1 do
		if ( WeekDay ( absenceDay ) < 6 ) then
			break;
		endif;
		absenceDay = absenceDay + 86400;
	enddo;

	p = Call ( "Documents.Deviations.Create.Params" );
	row = Call ( "Documents.Deviations.Create.Row" );
	row.Employee = Env.Employees [ 0 ].Name;
	row.Day = Format ( absenceDay, "DLF=D" );
	row.Duration = 8;
	row.Time = "Absence";
	p.Employees.Add ( row );
	Call ( "Documents.Deviations.Create", p );

	RegisterEnvironment ( id );

EndProcedure
