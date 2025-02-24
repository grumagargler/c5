#if ( Server or ThickClientOrdinaryApplication or ExternalConnection ) then

	
Function Events () export
	
	p = Reporter.Events ();
	p.FullAccessRequest = true;
	p.BeforeOpen = true;
	p.OnCompose = true;
	p.OnGetColumns = true;
	return p;
	
EndFunction 

Function FullAccessRequest ( Params ) export
	
	return true;

EndFunction

Procedure BeforeOpen ( Form ) export
	
	Form.GenerateOnOpen = true;
	composer = Form.Object.SettingsComposer;
	warehouse = DC.FindParameter ( composer, "Warehouse" ).Value;
	if ( ValueIsFilled ( warehouse ) ) then
		return;
	endif;
	warehouse = Logins.Settings ( "Warehouse" ).Warehouse;
	if ( warehouse.IsEmpty () ) then
		Form.GenerateOnOpen = false;
		return;
	endif;
	DC.SetParameter ( composer, "Warehouse", warehouse, true );
	
EndProcedure

Procedure OnGetColumns ( Variant, Columns ) export
	
	if ( Variant = "#Mobile" ) then
		Columns = new Array ();
		Columns.Add ( Reporter.ColumnStruct ( "Warehouse", 15 ) );
		Columns.Add ( Reporter.ColumnStruct ( "QuantityClosingBalance", 7 ) );
	endif; 
	
EndProcedure 

#endif