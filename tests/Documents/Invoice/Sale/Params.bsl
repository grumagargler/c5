﻿StandardProcessing = false;

p = new Structure ();
p.Insert ( "Action", "PostAndClose" );
p.Insert ( "Date" );
p.Insert ( "Customer" );
p.Insert ( "TaxGroup" );
p.Insert ( "CustomerTaxGroup" );
p.Insert ( "CustomerTaxGroupCreationParams" );
p.Insert ( "Warehouse" );
p.Insert ( "Department" );
p.Insert ( "Currency", __.LocalCurrency );
p.Insert ( "Rate", 1 );
p.Insert ( "Factor", 1 );
p.Insert ( "ContractCurrency", __.LocalCurrency );
p.Insert ( "ContractRate", 1 );
p.Insert ( "ContractFactor", 1 );
p.Insert ( "Terms" );

p.Insert ( "Items", new Array () );
p.Insert ( "Services", new Array () );

return p;
