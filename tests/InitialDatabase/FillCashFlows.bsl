add ( "251", "Внутрннее перемещение", "(250) Internal Movement" );
add ( "50", "Выплата подоходного налога", "Type_050" );
add ( "40", "Выплата процентов", "Type_040" );
add ( "100", "Денежные выплаты на приобретение долгосрочных активов", "Type_100" );
add ( "30", "Денежные выплаты персоналу и отчисления на социальное страхование", "Type_030" );
add ( "160", "Денежные выплаты по кредитам и займам", "Type_160" );
add ( "20", "Денежные выплаты поставщикам и подрядчикам", "Type_020" );
add ( "190", "Денежные выплаты при выкупе собственных акций", "Type_190" );
add ( "150", "Денежные поступления в виде кредитов и займов", "Type_150" );
add ( "90", "Денежные поступления от выбытия долгосрочных активов", "Type_090" );
add ( "180", "Денежные поступления от эмиссии собственных акций", "Type_180" );
add ( "171", "Дивиденды, выплаченные нерезидентам", "Type_171" );
add ( "170", "Дивиденды, выплаченные резидентам", "Type_170" );
add ( "120", "Дивиденды, полученные внутри страны", "Type_120" );
add ( "121", "Дивиденды, полученные из-за рубежа", "Type_121" );
add ( "250", "Положительные (отрицательные) курсовые разницы", "Type_250" );
add ( "10", "Поступление денежных средств", "Type_010" );
add ( "110", "Проценты полученные", "Type_110" );
add ( "70", "Прочие выбытия денежных средств", "Type_070" );
add ( "130", "Прочие поступления (выбытия) денежных средств", "Type_130" );
//add ( "200", "Прочие поступления (выбытия) денежных средств", "Type_200" );
add ( "60", "Прочие поступления денежных средств", "Type_060" );
add ( "230", "Чрезвычайное поступление (выбытие) денежных средств", "Type_230" );

Procedure add ( Code, Description, Type )

	Commando ( "e1cib/data/Catalog.CashFlows" );
	With ( "Cash Flows (create)" );
	Put ( "#Description", Description );
	Put ( "#FlowType", Type );
	Put ( "#Code", Code );
	Click ( "Yes", Forms.Get1C () ); 
	Click ( "#FormWriteAndClose" );

EndProcedure


