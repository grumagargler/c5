&AtClient
var TableRow;

// *****************************************
// *********** Form events

&AtServer
Procedure OnCreateAtServer ( Cancel, StandardProcessing )
	
	if ( Object.Ref.IsEmpty () ) then
		copy = not Parameters.CopyingValue.IsEmpty ();
		if ( copy ) then
			BalancesForm.FixDate ( ThisObject );
		else
			BalancesForm.CheckParameters ( ThisObject );
		endif;
		DocumentForm.SetCreator ( Object );
	endif;
	Options.Company ( ThisObject, Object.Company );
	StandardButtons.Arrange ( ThisObject );
	
EndProcedure

&AtClient
Procedure BeforeWrite ( Cancel, WriteParameters )
	
	StandardButtons.AdjustSaving ( ThisObject, WriteParameters );

EndProcedure

// *****************************************
// *********** Table Employees

&AtClient
Procedure EmployeesOnActivateRow ( Item )
	
	TableRow = Item.CurrentData;
	
EndProcedure

&AtClient
Procedure EmployeesEmployeeOnChange ( Item )
	
	HiringForm.SetIndividual ( TableRow );
	
EndProcedure

&AtClient
Procedure EmployeesCompensationOnChange ( Item )
	
	setAccount ();
	
EndProcedure

&AtClient
Procedure setAccount ()
	
	TableRow.Account = DF.Pick ( TableRow.Compensation, "Account" );
	
EndProcedure 
