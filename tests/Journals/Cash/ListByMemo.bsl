﻿// Opens list set filter by memo
Commando ( "e1cib/list/DocumentJournal.Cash" );
Clear("#LocationFilter");
Clear("#CurrencyFilter");
p = Call("Common.Find.Params");
p.Where = "Memo";
p.What = _;
Call("Common.Find", p);
