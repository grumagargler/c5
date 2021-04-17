
Call ( "Common.Init" );
CloseAll ();

id = Call ( "Common.ScenarioID", "25CFD6BF" );
env = getEnv ( id );
createEnv ( env );

Commando ( "e1cib/data/Document.LVIWriteOff" );
With ( "LVI Write Off (cr*" );
Click ( "#ShowPrices" );

table = Get ( "#Items" );
Click ( "#ItemsAdd" );

Put ( "#ItemsItem", env.Item );
Next ();

// Calc without VAT
Set ( "#ItemsQuantityPkg", 2, table );
Set ( "#ItemsPrice", 50, table );
Check ( "#ItemsAmount", 100, table );

// Set VAT use = Included in Price
Put ( "#VATUse", "Included in Price" );
Check ( "#ItemsVATCode", "20%", table );
Check ( "#ItemsVAT", 16.67, table );
Check ( "#VAT", 16.67 );

// Set VAT use = Excluded from Price
Put ( "#VATUse", "Excluded from Price" );
Check ( "#ItemsVAT", 20, table );
Check ( "#VAT", 20 );

Put ( "#ItemsAmount", "90", table );
Check ( "#ItemsVAT", 18, table );
Check ( "#Amount", 108 );

Put ( "#ItemsPrice", "40", table );
Check ( "#ItemsVAT", 16, table );
Check ( "#Amount", 96 );

Put ( "#ItemsVAT", "40", table );
Check ( "#Amount", 120 );


// *************************
// Procedures
// *************************

Function getEnv ( ID )

	p = new Structure ();
	p.Insert ( "ID", ID );
	p.Insert ( "Item", "Item " + ID );
	return p;

EndFunction

Procedure createEnv ( Env )

	id = Env.ID;
	if ( Call ( "Common.DataCreated", id ) ) then
		return;
	endif;
	
	// *************************
	// Create Item
	// *************************
	
	p = Call ( "Catalogs.Items.Create.Params" );
	p.Description = Env.Item;
	Call ( "Catalogs.Items.Create", p );

	Call ( "Common.StampData", id );

EndProcedure
