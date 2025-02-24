Расчет начислений и удержаний с заработной платы сотрудникам организации. Документ производит расчет всех начислений, включая основные (оклады, тарифы) и дополнительные (премии, отпускные, больничные и другие).

Такие документы как [Отпуск](/d/Vacation), [Больничный](/d/SickLeave) и другие, являются вспомогательными по отношению к начислению зарплаты, и самостоятельно не формируют бухгалтерских проводок.

# Обратный расчет

Документ поддерживает расчет начислений как прямым, так и обратным способом, включая основные и дополнительные начисления. Поддерживаются смешанные варианты (например, оклад рассчитывается прямым методом, а талоны на питание или бензин, обратным). Для сотрудников, расчет начислений которых необходимо выполнять от суммы на руки, в документе [Прием на работу](/d/Hiring), для соответствующих начислений, необходимо взвести флаг `На руки`. Также, способ расчета может быть изменен документом [Кадровые изменения](/d/EmployeesTransfer).

# Авансы при обратном расчете

Особое место занимает вопрос начисления заработной платы от обратного, часть которой ранее была выдана авансом (см. документ [Авансы по ЗП](/d/PayAdvances)). Программа учитывает такие ситуации, и при расчете от обратного суммы к начислению, учитывает ранее выданные авансы, удержанные с авансов налоги и примененные освобождения. Для удобства пользователя, обнаруженные авансы система отображает в таблице `Авансы`, на отдельной вкладке документа начисления.

!!!warning "Внимание!"
    Следует учитывать, что программа не предусматривает автоматизации частичного погашения авансов или их переходов на следующий месяц.

# Заполнение документа

Документ может быть заполнен за любой промежуток времени. В течении месяца, начисление зарплаты может вводится несколько раз разными документами.

Если в составе начислений, присутствуют начисления с расчетом от обратного, при заполнении документа, следует уделять внимание параметру `Дата выплаты (для расчетов от обратного)`. Этот параметр влияет на расчет применяемых освобождений. Если значение параметра указано не будет, датой выплаты будет считаться дата конца периода заполнения документа. При этом, расчет примененных освобождений выполняется на начало дня даты выплаты. Такой подход позволяет выполнять перезаполнение/перерасчет начислений без отмены проведения выплат.
