﻿
Процедура ПередЗаписью(Отказ, Замещение)
	
	Для каждого текЗапись Из ЭтотОбъект Цикл
		Если Не ЗначениеЗаполнено(текЗапись.ДатаВыполнения) Тогда
			текЗапись.ДатаВыполнения = ТекущаяДата();
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры
