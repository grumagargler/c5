﻿// Check advance returning with Income Tax
// Pay to Vendor and withdraw income tax
// Vendor Refund

Call ( "Common.Init" );
CloseAll ();

this.Insert ( "ID", Call ( "Common.ScenarioID", "2BFC7E47" ) );
getEnv ();
createEnv ();

#region payToVendor
Commando("e1cib/command/Document.VendorPayment.Create");
Put ( "#Vendor", this.vendor );
Put ( "#Amount", 100 );
Put ( "#IncomeTax", "CC" );
Set ( "#IncomeTaxRate", 5 );
Next ();
Click ( "#FormPostAndClose" );
#endregion

#region venorRefund
Commando("e1cib/command/Document.VendorRefund.Create");
Put ( "#Vendor", this.vendor );
Put ( "#Amount", 100 );
Click ( "#FormPost" );
Click ( "#FormReportRecordsShow" );
With ();
CheckTemplate ( "#TabDoc" );
#endregion

// *************************
// Procedures
// *************************

Procedure getEnv ()

	id = this.ID;
	this.Insert ( "Vendor", "Vendor " + id );

EndProcedure

Procedure createEnv ()

	id = this.ID;
	if ( EnvironmentExists ( id ) ) then
		return;
	endif;
	
	#region createVendor
	p = Call ( "Catalogs.Organizations.CreateVendor.Params" );
	p.Description = this.Vendor;
	Call ( "Catalogs.Organizations.CreateVendor", p );
	#endregion

	RegisterEnvironment ( id );

EndProcedure
