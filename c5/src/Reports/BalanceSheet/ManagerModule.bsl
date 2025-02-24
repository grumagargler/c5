#if ( Server or ThickClientOrdinaryApplication or ExternalConnection ) then

Function Events () export
	
	p = Reporter.Events ();
	p.BeforeOpen = true;
	p.OnDetail = true;
	p.OnCompose = true;
	return p;
	
EndFunction 

Procedure BeforeOpen ( Form ) export
	
	Form.GenerateOnOpen = true;
	
EndProcedure 

Procedure OnDetail ( Menu, StandardMenu, UseMainAction, Filters ) export
	
	Reporter.DisableMenu ( StandardMenu );
	Menu = new ValueList ();
	Reporter.AddReport ( Menu, "AccountBalance" );
	Reporter.AddReport ( Menu, "AccountAnalysis" );
	Reporter.AddReport ( Menu, "Transactions" );
	
EndProcedure

Procedure ApplyDetails ( Composer, Params ) export
	
	filters = GetFromTempStorage ( Params.Filters );
	balanceSheet = Params.ReportName = "BalanceSheet";
	analyticTransactions = Params.ReportName = "AnalyticTransactions";
	parent = Params.Parent;
	incomeStatement = false;
	debts = false;
	debtDetails = false;
	if ( parent = "IncomeStatement" ) then
		incomeStatement = true;
	elsif ( parent = "Debts"
		or parent = "VendorDebts" ) then
		debts = true;
	elsif ( parent = "DebtDetails"
		or parent = "VendorDebtDetails" ) then
		debtDetails = true;
	endif;
	periodDefined = false;
	filterType = Type ( "DataCompositionFilterItem" );
	for each filter in filters do
		filterName = filter.Name;
		if ( filterName = "Class" ) then
			if ( balanceSheet ) then
				DC.SetFilter ( Composer, "Account.Class", filter.Item.Value, , true );
				filter.StandardProcessing = false;
			endif;
		elsif ( filterName = "Period" ) then
			filter.StandardProcessing = false;
			if ( periodDefined ) then
				continue;
			endif;
			if ( filter.Field ) then
				if ( incomeStatement ) then
					period = getPeriod ( filter.Item.Value, filters );
				else
					period = filter.Item.Value;
				endif; 
				DC.SetParameter ( Composer, "Period", period );
			elsif ( filter.Parameter ) then
				DC.SetParameter ( Composer, "Period", filter.Item.Value );
			endif; 
			periodDefined = true;
		elsif ( filterName = "Customer"
			or filterName = "Vendor" ) then
			if ( debts
				or debtDetails ) then
				if ( balanceSheet ) then
					DC.AddFilter ( Composer, "Dim1", filter.Item.Value, , true );
					DC.SetParameter ( Composer, "ShowDimensions", 1 );
				elsif ( analyticTransactions ) then
					DC.SetParameter ( Composer, "DimType1", ChartsOfCharacteristicTypes.Dimensions.Organizations );
					DC.SetParameter ( Composer, "Dim1", filter.Item.Value );
				endif; 
			endif; 
		elsif ( filterName = "Contract" ) then
			if ( debts
				or debtDetails ) then
				if ( balanceSheet ) then
					DC.AddFilter ( Composer, "Dim2", filter.Item.Value, , true );
					DC.SetParameter ( Composer, "ShowDimensions", 2 );
				elsif ( analyticTransactions ) then
					DC.SetParameter ( Composer, "DimType2", ChartsOfCharacteristicTypes.Dimensions.Contracts );
					DC.SetParameter ( Composer, "Dim2", filter.Item.Value );
				endif; 
			endif; 
		elsif ( filterName = "ReportDate" ) then
			if ( balanceSheet
				or analyticTransactions ) then
				if ( debts ) then
					Reporter.DateToPeriod ( Composer, filter );
					periodDefined = true;
				endif; 
			endif;
		elsif ( filter.Filter
			and TypeOf ( filter.Item ) = filterType ) then
			userFilter = "" + filter.Item.LeftValue;
			if ( userFilter = "Currency" ) then
				if ( debts
					or debtDetails ) then
					if ( balanceSheet
						or analyticTransactions ) then
						filter.StandardProcessing = filter.Item.RightValue <> Application.Currency ();
					endif; 
				endif; 
			endif; 
		endif;
	enddo; 
	Reporter.ApplyDetails ( Composer, filters );
	
EndProcedure 

Function getPeriod ( Period, Filters )
	
	start = Period;
	end = Period;
	for each filter in Filters do
		if ( filter.Name = "Periodicity"
			and filter.Parameter ) then
			periodicity = filter.Item.Value;
			if ( periodicity = 2 ) then
				end = EndOfWeek ( Period );
			elsif ( periodicity = 3 ) then
				end = start + 10 * 86400;
			elsif ( periodicity = 4 ) then
				End = AddMonth ( start, 1 );
			elsif ( periodicity = 5 ) then
				start = AddMonth ( start, 3 );
			elsif ( periodicity = 6 ) then
				start = AddMonth ( start, 6 );
			elsif ( periodicity = 7 ) then
				start = AddMonth ( start, 12 );
			endif; 
			break;
		endif; 
	enddo; 
	return new StandardPeriod ( start, EndOfDay ( end ) );
	
EndFunction 

Procedure SetTitle ( Params, Period, Account = undefined ) export
	
	s = Metadata.Reports [ Params.Name ].Presentation ();
	if ( Account <> undefined ) then
		s = s + ": " + Account;
	endif;
	if ( TypeOf ( Period ) = Type ( "Date" ) ) then
		if ( Period <> Date ( 1, 1, 1 ) ) then
			s = s + ", " + Output.AsOf () + " " + Format ( Period, "DF='MMMM dd, yyyy'" );
		endif;
	elsif ( Period.Use ) then
		value = Period.Value;
		s = s + ", " + PeriodPresentation ( value.StartDate, value.EndDate, "FP=true" );
	endif; 
	p = Params.Settings.OutputParameters.FindParameterValue ( new DataCompositionParameter ( "Title" ) );
	p.Value = s;
	
EndProcedure

#endif