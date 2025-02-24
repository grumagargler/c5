// *****************************************
// *********** Form events

&AtServer
Procedure OnCreateAtServer ( Cancel, StandardProcessing )
	
	if ( Object.Ref.IsEmpty () ) then
		raise Output.InteractiveCreationForbidden ();
	endif;
	if ( not PermissionForm.Completed ( Object )
		and Constraints.CanApprove () ) then
		PermissionForm.Init ( Object );
	endif;
	readAppearance ();
	Appearance.Apply ( ThisObject );

EndProcedure

&AtServer
Procedure readAppearance ()

	rules = new Array ();
	rules.Add ( "
	|Expired show Object.Resolution = Enum.AllowDeny.Allow;
	|" );
	Appearance.Read ( ThisObject, rules );

EndProcedure

&AtServer
Procedure AfterWriteAtServer ( CurrentObject, WriteParameters )
	
	PermissionForm.NotifyUser ( Object );
	
EndProcedure

&AtClient
Procedure AfterWrite ( WriteParameters )

	Notify ( Enum.MessagePermissionIsSaved (), Object.Document );

EndProcedure

// *****************************************
// *********** Group Form

&AtClient
Procedure ResolutionOnChange ( Item )
	
	PermissionForm.ApplyResolution ( Object );
	Appearance.Apply ( ThisObject, "Object.Resolution" );

EndProcedure
