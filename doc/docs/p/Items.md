﻿Обработка общего назначения. Используется для подбора товаров в документы системы. Является вспомогательным механизмом наполнения документов номенклатурным составом.

В зависимости от используемого документа, форма настраивает отображаемые поля и опции. Например, такие документы как: [Заказ покупателя](/d/SalesOrder), [Внутренняя заявка](/d/InternalOrder), [Заказ поставщику](/d/PurchaseOrder) и другие позволяют на этапе подбора товара задавать варианты его резервации и размещения. Подробнее о резервировании и размещении см. [Резервирование и размещение](/Warehousing).

Выводимая информация об остатках и ценах определяются системой на дату документа. В случае ввода нового документа, дата считается неопределенной, и информация  будет получена согласно текущих данных системы. При необходимости, дату получения информации можно установить вручную, используя поле дата:

![](../img/2018_06_24_02_42_231.png)

!!!warning "Внимание!"
	Следует помнить, что ввод информации задним числом не является штатным режимом работы системы, и в случае большого документооборота, может приводить к существенному замедлению работы программы

# Список товаров

В основной части формы располагается список товаров. Как правило, в список выводятся товары и услуги, вне зависимости от места вызова подбора. Это сделано для того, чтобы у пользователя была возможность использовать механизм, для выбора товаров и/или услуг, без закрытия формы.

## Колонка Остаток

Колонка содержит информацию о количественном остатке товара на складе, за минусом произведенного ранее резерва. Таким образом, если на складе, фактически, есть остаток, но он полностью находится под резервом, в данной колонке будет 0.

В качестве склада используется склад, указанный в шапке исходного документа.

## Флаг Запрашивать детали

В зависимости от используемого документа, подбор товаров может сопровождаться запросом на ввод дополнительных данных. Например, при подборе в документ заказ покупателя, может потребоваться размещение или резервация. Для того, чтобы система запрашивала дополнительно информацию, необходимо включить данных флаг.

Подробнее о резервировании и размещении см. [Резервирование и размещение](/Warehousing).

## Флаг Показывать выбор

Данная опция делает видимой информационную панель с данными о подобранных ранее позициях и общей сумме.

## Флаг Показывать резервы

При включенной опции, в список товаров и остатков по складам добавляется колонка резерв. Информация о резерве может быть полезна при использовании подбора, в процессе выписки расходных накладных.