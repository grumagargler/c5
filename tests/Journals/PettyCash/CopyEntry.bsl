// Scenario:
// - Create a new Entry, operation = Cash Expense
// - Open Petty Cash journal
// - Find and Copy that Entry
// - Check if New Voucher command appears

Call ( "Common.Init" );
CloseAll ();

id = Call ( "Common.ScenarioID", "286E2F8C" );
env = getEnv ( ID );
createEnv ( env );

// ************
// Create Entry
// ************

Commando ( "e1cib/data/Document.Entry" );
With ( "Entry (cr*" );
Put ( "#Operation", Env.Operation );
Put ( "#Content", id );
Click ( "#FormWrite" );
Close ();

// ************
// Open Journal
// ************

Commando ( "e1cib/list/DocumentJournal.PettyCash" );
list = With ( "Petty Cash" );

// Find Entry
GotoRow ( "#List", "Memo", id );

// Copy
Click ( "#FormCopy" );
With ( "Entry (cr*" );
CheckState ( "#NewVoucher", "Visible" );

// *************************
// Procedures
// *************************

Function getEnv ( ID )

	p = new Structure ();
	p.Insert ( "ID", ID );
	p.Insert ( "Operation", "Operation " + ID );
	p.Insert ( "Individual", "Individual " + ID );
	p.Insert ( "Location", "Location " + ID );
	return p;

EndFunction

Procedure createEnv ( Env )

	id = Env.ID;
	if ( Call ( "Common.DataCreated", id ) ) then
		return;
	endif;
	
	// *************************
	// Create Operation
	// *************************

	p = Call ( "Catalogs.Operations.Create.Params" );
	p.Operation = "Cash Expense";
	p.Description = Env.Operation;
	p.Simple = true;
	p.AccountDr = "12800";
	p.AccountCr = "10400";
	Call ( "Catalogs.Operations.Create", p );

	Call ( "Common.StampData", id );

EndProcedure
