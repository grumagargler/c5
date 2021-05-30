﻿// Create a contract in USD with fixed currency 15 lei
// Create a SO in MDL then receive a payment in MDL
// Create an Invoice in MDL for 50% amount and check SO status

Call ( "Common.Init" );
CloseAll ();

id = Call ( "Common.ScenarioID", "2D2CD5A2" );
this.Insert ( "ID", id );
getEnv ();
createEnv ();

#region newSalesOrder
Commando("e1cib/list/Document.SalesOrder");
Clear("#StatusFilter");
Click("#FormCreate");
With();
Put ( "#Customer", this.Customer );
Put ( "#Currency", "MDL" );
Check("#Rate", 15);
Put ( "#Memo", id );
Items = Get ( "!ItemsTable" );
Click ( "!ItemsTableAdd" );
Items.EndEditRow ();
Set ( "!ItemsItem", this.Item, Items );
Set ( "!ItemsQuantityPkg", 2, Items );
Set ( "!ItemsPrice", 10, Items );
Set ( "!ItemsDiscountRate", 5, Items );

Click("#FormSendForApproval");
With();
Click ( "!Button0" );
#endregion

#region approveSO
With();
Click ( "!FormChange" );
With ();
Click ( "!FormCompleteApproval" );
With ();
Click ( "!Button0" );
#endregion

#region paySO
With ();
Click ( "#FormDocumentPaymentCreateBasedOn" );
With ();
Click ( "!FormPostAndClose" );
#endregion

#region checkInvoive1
Commando("e1cib/command/Document.Invoice.Create");
Set("#Customer", this.Customer);
Next ();
Items = Get ( "!ItemsTable" );
Assert ( Call("Table.Count", Items ) ).Not_ ().Empty ();
Check("#Currency", "USD");
Check("#Rate", 15);
Put("#Currency", "MDL");
Click ( "!FormPostAndClose" );
#endregion

#region checkInvoive2
Commando("e1cib/command/Document.Invoice.Create");
Set("#Customer", this.Customer);
Next ();
Items = Get ( "!ItemsTable" );
Assert ( Call("Table.Count", Items ) ).Empty ();
#endregion

// *************************
// Procedures
// *************************

Procedure getEnv ()

	id = this.ID;
	this.Insert ( "Vendor", "Vendor " + id );
	this.Insert ( "Customer", "Customer " + id );
	this.Insert ( "Item", "Item " + id );

EndProcedure

Procedure createEnv ()

	id = this.ID;
	if ( EnvironmentExists ( id ) ) then
		return;
	endif;

	#region createCustomer
	p = Call ( "Catalogs.Organizations.CreateCustomer.Params" );
	p.Description = this.Customer;
	p.Terms = "Due on receipt";
	p.Currency = "USD";
	p.RateType = "Fixed";
	p.Rate = 15;
	Call ( "Catalogs.Organizations.CreateCustomer", p );
	#endregion

	#region createVendor
	p = Call ( "Catalogs.Organizations.CreateVendor.Params" );
	p.Description = this.Vendor;
	Call ( "Catalogs.Organizations.CreateVendor", p );
	#endregion

	#region createItem
	p = Call ( "Catalogs.Items.Create.Params" );
	p.Description = this.Item;
	Call ( "Catalogs.Items.Create", p );
	#endregion

	#region CreateVI
	Commando("e1cib/command/Document.VendorInvoice.Create");
	Set ( "!Vendor", this.Vendor );
	Items = Get ( "!ItemsTable" );
	Click ( "!ItemsTableAdd" );
	Items.EndEditRow ();
	Set ( "!ItemsItem", this.Item, Items );
	Set ( "!ItemsQuantityPkg", 1000, Items );
	Set ( "!ItemsPrice", 3, Items );
	Click ( "!FormPostAndClose" );
	#endregion

	RegisterEnvironment ( id );

EndProcedure
