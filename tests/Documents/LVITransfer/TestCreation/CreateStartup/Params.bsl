p = new Structure ();
p.Insert ( "ID" );
p.Insert ( "Date", BegOfDay ( CurrentDate () ) );
p.Insert ( "EmployeeSender" );
p.Insert ( "EmployeeReceiver" );
p.Insert ( "DepartmentSender" );
p.Insert ( "DepartmentReceiver" );
p.Insert ( "Expense" );
p.Insert ( "LVI" );
p.Insert ( "ResidualValue" );
return p;