&AtClient
var DebtsRow export;

// *****************************************
// *********** Form events

&AtServer
Procedure OnReadAtServer ( CurrentObject )
	
	DebtsForm.OnReadAtServer ( ThisObject );
	
EndProcedure

&AtServer
Procedure OnCreateAtServer ( Cancel, StandardProcessing )
	
	DebtsForm.OnCreateAtServer ( ThisObject );
	
EndProcedure

&AtClient
Procedure BeforeWrite ( Cancel, WriteParameters )
	
	StandardButtons.AdjustSaving ( ThisObject, WriteParameters );
	Forms.DeleteLastRow ( Object.Debts, "Customer" );
	
EndProcedure

// *****************************************
// *********** Group Form

&AtClient
Procedure AccountOnChange ( Item )
	
	applyAccount ();
	
EndProcedure

&AtServer
Procedure applyAccount () 

	DebtsForm.ApplyAccount ( ThisObject );

EndProcedure

&AtClient
Procedure CurrencyOnChange ( Item )
	
	Appearance.Apply ( ThisObject, "Object.Currency" );
	
EndProcedure

// *****************************************
// *********** Table Debts

&AtClient
Procedure DebtsOnActivateRow ( Item )
	
	DebtsRow = Item.CurrentData;
	
EndProcedure

&AtClient
Procedure DebtsCustomerOnChange ( Item )
	
	applyCustomer ();
	
EndProcedure

&AtClient
Procedure applyCustomer () 

	data = DF.Values ( DebtsRow.Customer, "CustomerContract, CustomerContract.Company as Company, CustomerContract.Currency as Currency" );
	if ( data.Company = Object.Company
		and data.Currency = Object.Currency ) then
		DebtsRow.Contract = data.CustomerContract;
	endif; 

EndProcedure

&AtClient
Procedure DebtsAmountOnChange ( Item )
	
	DebtsForm.DebtsAmountOnChange ( ThisObject );
	
EndProcedure

&AtClient
Procedure DebtsAdvanceOnChange ( Item )
	
	DebtsForm.DebtsAdvanceOnChange ( ThisObject );
	
EndProcedure

&AtClient
Procedure DebtsOnEditEnd ( Item, NewRow, CancelEdit )
	
	DebtsForm.CalcTotals ( ThisObject );
	
EndProcedure

&AtClient
Procedure DebtsAfterDeleteRow ( Item )
	
	DebtsForm.CalcTotals ( ThisObject );
	
EndProcedure
