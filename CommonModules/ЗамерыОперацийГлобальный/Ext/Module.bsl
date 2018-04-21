﻿
Процедура УдалитьНезавершенныеЗамерыОпераций() Экспорт 
	
	МассивЗамеров = ЗамерыОперацийОбщий.ПолучитьМассивЗамеров();
	Если МассивЗамеров = Неопределено Тогда
		Возврат;
	КонецЕсли;
	#Если _ Тогда
	    МассивЗамеров = Новый Массив;
	#КонецЕсли
	КоличествоАктивныхЗамеров = МассивЗамеров.Количество();
	СтрокаЗамераНайдена = Ложь;
	Для Счетчик = 1 По КоличествоАктивныхЗамеров Цикл
		Индекс = КоличествоАктивныхЗамеров - Счетчик;
		СтруктураЗамера = ЗамерыОперацийОбщий.ПолучитьСтруктуруЗамера(МассивЗамеров[Индекс]);
		Если СтруктураЗамера.ЗавершатьПриОжиданииПользователя Тогда
			ЗамерыОперацийОбщий.ЗавершитьЗамер(СтруктураЗамера.ИмяОперации, СтруктураЗамера.Ключ);
		Иначе
			//Сообщить("Замеры операций >> Удален незавершенный замер операции " + СтруктураЗамера.ИмяОперации + " при ожидании пользователя");
		КонецЕсли; 
		МассивЗамеров.Удалить(Индекс);
	КонецЦикла;
	ЗамерыОперацийОбщий.УстановитьМассивЗамеров(МассивЗамеров);
	
КонецПроцедуры

