﻿Справочник хранит информацию по подразделениям компании.

# Реквизиты

## Использовать отгрузки

Если флаг включен, подсистема учета заказов будет формировать специального вида документы [Отгрузка](/d/Shipment), предназначенные для автоматизации оперативного учета службы складского хозяйства. Флаг имеет смысл включать, только если в компании используются задания на погрузку, с оперативным контролем состояния отгружаемых заказов.

## Флаг Производственное и таблица Продукция

Флаг доступен при включенной опции `Использовать производственные операции` (см. меню `Настройки / Приложение / Опции`).

Включение флага означает, что данное подразделения является производственным и используются в подсистеме производственных операций.

При активации флага, становится доступной для ввода таблица `Продукция`. В таблицу вводятся активы, которые могут быть выпущены данным подразделением. Эта информация используется в процессе заполнения заказа на производство (см. документ [Заказ на производство](/d/ProductionOrder)), в случае предварительного размещения требований.