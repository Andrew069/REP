﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Не ОбщийМодульСервер.ПолучитьЗначениеКонстанты("ПолныйДоступ") Тогда
		Отказ = Истина;
	КонецЕсли;
	
	СписокТиповОбъектов.Добавить("Справочники", "Справочник", , БиблиотекаКартинок.Справочник);
	СписокТиповОбъектов.Добавить("Документы", "Документ", , БиблиотекаКартинок.Документ);
	СписокТиповОбъектов.Добавить("ПланыОбмена", "План обмена", , БиблиотекаКартинок.ПланОбмена);
	СписокТиповОбъектов.Добавить("РегистрыСведений", "Регистры сведений", , БиблиотекаКартинок.РегистрСведений);
	
	Элементы.СписокТиповОбъектов.Видимость = Истина;
	Элементы.СписокОбъектовМД.Видимость = Ложь;
КонецПроцедуры

&НаСервере
Функция ЗаполнитьСписокМетаданных(Мета)
	Для Каждого Эл Из Метаданные[Мета] Цикл
		СписокОбъектовМД.Добавить(Эл.ПолноеИмя(),Эл.Синоним);
	КонецЦикла;
	СписокОбъектовМД.СортироватьПоПредставлению();
КонецФункции	

&НаКлиенте
Процедура СписокТиповОбъектовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если Элементы.СписокТиповОбъектов.ТекущиеДанные <> Неопределено Тогда
		СписокОбъектовМД.Очистить();
		ЗаполнитьСписокМетаданных( Элементы.СписокТиповОбъектов.ТекущиеДанные.Значение );
		
		Элементы.СписокТиповОбъектов.Видимость = Ложь;
		Элементы.СписокОбъектовМД.Видимость = Истина;
		Элементы.СписокОбъектовМД.Обновить();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокОбъектовМДВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если Элементы.СписокОбъектовМД.ТекущиеДанные <> Неопределено Тогда
		ОткрытьФорму(Элементы.СписокОбъектовМД.ТекущиеДанные.Значение + ".ФормаСписка");
		Закрыть();
	КонецЕсли;
КонецПроцедуры

//&НаКлиенте
//Процедура ПриОткрытии(Отказ)
//	//ПодключитьОбработчикОжидания("мВыбор",0.3,Истина);
//КонецПроцедуры
//
//&НаКлиенте
//Процедура мВыбор()
//	мСписок = Новый СписокЗначений;
//	мСписок.Добавить("Справочники","Справочник" ,,БиблиотекаКартинок.Справочник);
//	мСписок.Добавить("Документы"  ,"Документ"   ,,БиблиотекаКартинок.Документ);
//	мСписок.Добавить("ПланыОбмена"     ,"План обмена",,БиблиотекаКартинок.ПланОбмена);
//	мСписок.Добавить("РегистрыСведений","Регистры сведений",,БиблиотекаКартинок.РегистрСведений);
//	Рез = ВыбратьИзСписка(мСписок,Элементы.Декорация1);
//	Если Рез <> Неопределено Тогда
//		ИмяОбъектаМета = Рез.Значение;
//		мСписок2 = ОграничениеТипов(Рез.Значение);
//		Для Каждого Эл Из мСписок2 Цикл
//			Эл.Картинка = Рез.Картинка;
//		КонецЦикла;	
//		Рез = ВыбратьИзСписка(мСписок2,Элементы.Декорация1);
//		Если Рез <> Неопределено Тогда
//			ОткрытьФорму(Рез.Значение + ".ФормаСписка");
//		КонецЕсли;	
//	КонецЕсли;	
//	Закрыть();
//КонецПроцедуры	
//&НаСервере
//Функция ОграничениеТипов(Мета)
//	мСписок = Новый СписокЗначений;
//	Для Каждого Эл Из Метаданные[Мета] Цикл
//		мСписок.Добавить(Эл.ПолноеИмя(),Эл.Синоним);
//	КонецЦикла;
//	Возврат мСписок;
//КонецФункции	
