﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Контрагент = Параметры.Контрагент;
	СформироватьОтчет();
КонецПроцедуры

&НаСервере
Процедура СформироватьОтчет ()
	Запрос       = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеПродаж.Дата КАК Дата,
	|	СУММА(ДанныеПродаж.ПродажиСумма) КАК Продажи,
	|	СУММА(ДанныеПродаж.ВозвратыСумма) КАК Возвраты,
	|	СУММА(ВЫБОР
	|			КОГДА ДанныеПродаж.ВозвратыКоличество <> 0
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ВозвратыSKU,
	|	СУММА(ВЫБОР
	|			КОГДА ДанныеПродаж.ПродажиКоличество <> 0
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ПродажиSKU
	|ИЗ
	|	РегистрСведений.ОС_ДанныеПродажДляМП КАК ДанныеПродаж
	|ГДЕ
	|	ДанныеПродаж.Контрагент = &Контрагент
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеПродаж.Дата
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата УБЫВ";
	Запрос.УстановитьПараметр("Контрагент" ,Контрагент);
	
	ИтогПродажи  = 0;
	ИтогВозвраты = 0;
	
	Результат.Очистить();
	//НоваяСтрока = Результат.Добавить();
	//НоваяСтрока.Операция = "Тест";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.Продажи <> 0 Тогда
			НоваяСтрока = Результат.Добавить();
			НоваяСтрока.Дата = Выборка.Дата;
			НоваяСтрока.Операция = "Продажа";
			НоваяСтрока.КоличествоSKU = Выборка.ПродажиSKU;
			НоваяСтрока.Сумма = Выборка.Продажи;			
		КонецЕсли;
		Если Выборка.Возвраты <> 0 Тогда
			НоваяСтрока = Результат.Добавить();
			НоваяСтрока.Дата = Выборка.Дата;
			НоваяСтрока.Операция = "Возврат";
			НоваяСтрока.КоличествоSKU = Выборка.ВозвратыSKU;
			НоваяСтрока.Сумма = Выборка.Возвраты;			
		КонецЕсли;		
		ИтогПродажи  = ИтогПродажи  + Выборка.Продажи; 
		ИтогВозвраты = ИтогВозвраты + Выборка.Возвраты; 		
	КонецЦикла;	
	
	Если Результат.Количество() = 0 Тогда
		Элементы.ДекорацияНетДанных.Заголовок = "<< НЕТ ДАННЫХ >>";
	Иначе
		Элементы.ДекорацияНетДанных.Заголовок = "Итого: " + ИтогПродажи + " - " + (-ИтогВозвраты) + " = " + (ИтогПродажи + ИтогВозвраты) + " р.";
	КонецЕсли;	
КонецПроцедуры	


&НаКлиенте
Процедура РезультатВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФорму("Обработка.ОтчетПродажиИВозвраты.Форма.Форма", Новый Структура("Контрагент, Дата, Операция",Контрагент, Элемент.ТекущиеДанные.Дата, Элемент.ТекущиеДанные.Операция));
КонецПроцедуры

