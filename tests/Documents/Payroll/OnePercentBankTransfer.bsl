﻿// Calculate salary when employee has regular salary and 1% from Net salary
// - Create two compensations: Monthly Payment (standard) and BankTransfer (from Net salary)
// - Hire two employees. The Employee1 will have gross (standard) compensations, the second "In Hand"
// - Enter balances (with precific amount from real case)
// - Create a Payroll & check amount

Call ( "Common.Init" );
CloseAll ();

this.Insert ( "ID", Call ( "Common.ScenarioID", "A0B5" ) );
getEnv ();
createEnv ();

#region createAndFillPayroll
Commando ( "e1cib/data/Document.Payroll" );
Put ("#Company", this.Company);
Click("#Button0", "1?:*"); // Yes
documentDate = Date ( Fetch ( "#DateStart" ) );
date = this.Date;
direction = ? ( documentDate < date, 1, -1 );
breaker = 1;
while ( breaker < 99 ) do
	dateStart = Date ( Fetch ( "#DateStart" ) );
	if ( dateStart = date ) then
		break;
	else
		Click ( ? ( direction = 1, "#NextPeriod", "#PreviousPeriod" ) );
	endif;
	breaker = breaker + 1;
enddo;
Activate ( "#Totals" );
Click ( "#Fill" );
With ();
table = Get ( "#UserSettings" );
GotoRow ( table, "Setting", "Department" );
Put ( "#UserSettingsValue", this.Department, table );
Click ( "#FormFill" );
Pause ( __.Performance * 4 );
With ();
Check ( "#Totals / Amount [ 1 ]", 10000 );
Check ( "#Totals / Other [ 1 ]", 0 );
Click("#FormPost");
#endregion

#region PayAndCheck
Commando("e1cib/command/Document.PayEmployees.Create");
Put ("#Company", this.Company);
Click("#Button0", "1?:*"); // Yes
Put("#Date", Format (EndOfMonth (this.Date), "DLF=D" ));
Click("#Fill");
With ();
table = Get ( "#UserSettings" );
GotoRow ( table, "Setting", "Department" );
Put ( "#UserSettingsValue", this.Department, table );
Click ( "#FormFill" );
Pause ( __.Performance * 4 );
With ();
Check ( "#Totals / Amount [ 1 ]", 10000 );
Check ( "#Totals / Net [ 1 ]", 8177.40 );
Check ( "#Totals / Amount [ 2 ]", 12298.97 );
Check ( "#Totals / Net [ 2 ]", 10000 );
#endregion

// *************************
// Procedures
// *************************

Procedure getEnv ()

	id = this.ID;
	this.Insert ( "Date", Date (Year(CurrentDate()),7,1) );
	this.Insert ( "Company", "Company " + id );
	this.Insert ( "Department", "Department " + id );
	this.Insert ( "Employees", getEmployees () );
	this.Insert ( "MonthlyRate", "Monthly " + id );

EndProcedure

Procedure createEnv ()

	id = this.ID;
	if ( EnvironmentExists ( id ) ) then
		return;
	endif;

	#region newCompany
	Call ( "Catalogs.Companies.Create", this.Company );
	#endregion

	#region newEmployee
	for each employee in this.Employees do
		p = Call ( "Catalogs.Employees.Create.Params" );
		p.Description = employee.Name;
		p.Company = this.Company;
		p.Deductions = "P";
		p.DeductionsDate = employee.DateStart;
		Call ( "Catalogs.Employees.Create", p );
	enddo;
	#endregion

	#region newDepartment
	p = Call ( "Catalogs.Departments.Create.Params" );
	p.Description = this.Department;
	p.Company = this.Company;
	Call ( "Catalogs.Departments.Create", p );
	#endregion

	#region newCompensation
	p = Call ( "CalculationTypes.Compensations.Create.Params" );
	compensation = this.MonthlyRate;
	p.Description = compensation;
	p.Method = "Monthly Rate";
	Call ( "CalculationTypes.Compensations.Create", p );
	#endregion

	#region tax1
	date = Format ( BegOfYear ( this.Date ), "DLF=D" );;
	p = Call ( "CalculationTypes.Taxes.Create.Params" );
	p.Description = "Tax1: " + id;
	p.Method = "Medical Insurance";
	p.RateDate = date;
	p.Rate = 9;
	p.Account = "5331";
	base = p.Base;
	base.Add ( compensation );
	Call ( "CalculationTypes.Taxes.Create", p );
	#endregion
	
	#region tax2
	p = Call ( "CalculationTypes.Taxes.Create.Params" );
	p.Description = "Tax2: " + id;
	p.Method = "Social Insurance";
	p.RateDate = date;
	p.Rate = 24;
	p.Account = "5331";
	base = p.Base;
	base.Add ( compensation );
	Call ( "CalculationTypes.Taxes.Create", p );
	#endregion

	#region tax3
	p = Call ( "CalculationTypes.Taxes.Create.Params" );
	p.Description = "Tax3: " + id;
	p.Method = "Income Tax";
	p.RateDate = date;
	p.Rate = 12;
	p.Account = "5342";
	base = p.Base;
	base.Add ( compensation );
	Call ( "CalculationTypes.Taxes.Create", p );
	#endregion 

	#region bankTransfer
	p = Call ( "CalculationTypes.Taxes.Create.Params" );
	p.Description = "Bank " + id;
	p.Method = "Percent";
	p.Net = true;
	p.RateDate = date;
	p.Rate = 1;
	p.Account = "5346";
	base = p.Base;
	base.Add ( compensation );
	Call ( "CalculationTypes.Taxes.Create", p );
	#endregion 

	#region Hiring
	department = this.Department;
	monthlyRate = this.MonthlyRate;
	params = Call ( "Documents.Hiring.Create.Params" );
	params.Company = this.Company;
	for each employee in this.Employees do
		p = Call ( "Documents.Hiring.Create.Row" );
		p.Employee = employee.Name;
		p.DateStart = Format ( employee.DateStart, "DLF=D" );
		p.DateEnd = Format ( employee.DateEnd, "DLF=D" );
		p.Department = department;
		p.Position = "Manager";
		p.Rate = employee.Rate;
		p.Compensation = monthlyRate;
		p.InHand = employee.InHand;
		params.Employees.Add ( p );
	enddo;
	params.Date = this.Date;
	Call ( "Documents.Hiring.Create", params );
	#endregion
	
	#region payrollBalances
	Commando ( "e1cib/list/DocumentJournal.Balances" );
	Put("#CompanyFilter", this.Company);
	Set ( "#BalanceDate", Format ( date, "DLF=D" ) );
	Next ();
	Click("#FormCreateByParameterPayrollBalances");
	With();
	Employees = Get ( "#Employees" );
	for each employee in this.Employees do
		Click ( "#EmployeesAdd" );
		Employees.EndEditRow ( false );
		Set ( "#EmployeesEmployee", employee.Name, Employees );
		Set ( "#EmployeesCompensation", monthlyRate, Employees );
		Set ( "#EmployeesDeductions", 12600, Employees );
	enddo;
	Click("#FormPost");
	#endregion

	RegisterEnvironment ( id );

EndProcedure

Function getEmployees ()

	id = this.ID;
	date = this.Date;
	dateStart = BegOfYear ( date )-86400;
	dateEnd = Date ( 1, 1, 1 );
	employees = new Array ();
	employees.Add ( newEmployee ( "Employee1 " + id, dateStart, dateEnd, 10000, false ) );
	employees.Add ( newEmployee ( "Employee2 " + id, dateStart, dateEnd, 10000, true ) );
	return employees;

EndFunction

Function newEmployee ( Name, DateStart, DateEnd, Rate, InHand )

	p = new Structure ( "Name, DateStart, DateEnd, Rate, InHand" );
	p.Name = Name;
	p.DateStart = DateStart;
	p.DateEnd = DateEnd;
	p.Rate = Rate;
	p.InHand = InHand;
	return p;

EndFunction
