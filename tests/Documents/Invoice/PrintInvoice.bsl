﻿// Create and print Invoice

Call ( "Common.Init" );
CloseAll ();

this.Insert ( "ID", Call ( "Common.ScenarioID", "2D27BCE6" ) );
getEnv ();
createEnv ();

Commando("e1cib/list/Document.Invoice");
p = Call("Common.Find.Params");
p.Where = "Memo";
p.What = this.ID;
Call("Common.Find", p);
Click ( "#FormDataProcessorPrintInvoice" );
With ();
Put("#Language", "Default");
Click("#FormOK");
With();
CheckTemplate ( "#TabDoc" );

Procedure getEnv ()

	id = this.ID;
	this.Insert ( "Customer", "Customer " + id );
	this.Insert ( "Warehouse", "Warehouse " + id );
	this.Insert ( "Item1", "Item1 " + id );
	this.Insert ( "Item2", "Item2 " + id );

EndProcedure

Procedure createEnv ()

	id = this.ID;
	if ( EnvironmentExists ( id ) ) then
		return;
	endif;
	
	#region createCustomer
	p = Call ( "Catalogs.Organizations.CreateCustomer.Params" );
	p.Description = this.Customer;
	Call ( "Catalogs.Organizations.CreateCustomer", p );
	#endregion
	
	#region createWarehouse
	p = Call ( "Catalogs.Warehouses.Create.Params" );
	p.Description = this.Warehouse;
	Call ( "Catalogs.Warehouses.Create", p );
	#endregion

	#region createItems
	p = Call ( "Catalogs.Items.Create.Params" );
	p.Description = this.Item1;
	Call ( "Catalogs.Items.Create", p );

	p.Description = this.Item2;
	Call ( "Catalogs.Items.Create", p );
	#endregion
	
	#region createInvoice
	Commando ( "e1cib/data/Document.Invoice" );
	With ();
	Put ( "#Customer", this.Customer );
	Put ( "#PaymentOption", "no discounts");
	tomorrow = Format ( CurrentDate () + 86400, "DLF=D" );
	Put ( "#PaymentDate", tomorrow );
	Put ( "#Warehouse", this.Warehouse );
	PUt ( "#Memo", id );
	
	Click ( "#ItemsTableAdd" );
	Put ( "#ItemsItem", this.Item1 );
	Activate ( "#ItemsFeature" ).Create ();
	With ();
	Set ( "#Description", Call ( "Common.GetID" ) );
	Click ( "#FormWriteAndClose" );
	
	With ();
	Items = Get ( "#ItemsTable" );
	
	Put ( "#ItemsPrice", "100" );
	Put ( "#ItemsQuantity", "5" );
	
	Click ( "#ItemsTableAdd" );
	Put ( "#ItemsItem", this.Item2 );
	Put ( "#ItemsPrice", "200" );
	Put ( "#ItemsDiscountRate", 10 );
	Put ( "#ItemsQuantity", "10" );
	Set ( "#Memo", id );
	Click ( "#JustSave" );
	Close ();
	#endregion

	RegisterEnvironment ( id );

EndProcedure
