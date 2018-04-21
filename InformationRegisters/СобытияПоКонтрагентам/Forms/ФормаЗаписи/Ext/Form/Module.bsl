﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Контрагент") И Не ЗначениеЗаполнено(ЭтотОбъект.Запись.Контрагент) Тогда
		ЭтотОбъект.Запись.Контрагент = Параметры.Контрагент;
	КонецЕсли;
	Если Параметры.Свойство("ТорговыйПредставитель") И Не ЗначениеЗаполнено(ЭтотОбъект.Запись.ТорговыйПредставитель) Тогда
		ЭтотОбъект.Запись.ТорговыйПредставитель = Параметры.ТорговыйПредставитель;
	КонецЕсли;
	Если Параметры.Свойство("Период") И Не ЗначениеЗаполнено(ЭтотОбъект.Запись.Период) Тогда
		ЭтотОбъект.Запись.Период = Параметры.Период;
	КонецЕсли;
	Если Параметры.Свойство("РежимОткрытия") И Параметры.РежимОткрытия = "ДляВводаЗначения" Тогда
		Элементы.Контрагент.ТолькоПросмотр = Истина;
		Элементы.ТорговыйПредставитель.ТолькоПросмотр = Истина;
		Элементы.Период.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Элементы.ДатаСледующегоПосещения.МинимальноеЗначение = КонецДня(ТекущаяДата()) + 1;
	Элементы.ДатаСледующегоПосещения.МаксимальноеЗначение = НачалоДня(ТекущаяДата()) + 31 * 86400;
	
	СписокДнейНедели = Новый Соответствие;
	СписокДнейНедели.Вставить(1, "Пн");	СписокДнейНедели.Вставить(2, "Вт");	СписокДнейНедели.Вставить(3, "Ср");
	СписокДнейНедели.Вставить(4, "Чт");	СписокДнейНедели.Вставить(5, "Пт");	СписокДнейНедели.Вставить(6, "Сб");	СписокДнейНедели.Вставить(7, "Вс");
	
	Если ЗначениеЗаполнено( Запись.ДатаСледующегоПосещения )  Тогда
		Всп = СписокДнейНедели.Получить( ДеньНедели( Запись.ДатаСледующегоПосещения ) );
		Элементы.ДекорацияДеньНедели.Заголовок = Всп;
	Иначе
		Элементы.ДекорацияДеньНедели.Заголовок = "";
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Всп = "";
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если Запись.ДатаСледующегоПосещения < Элементы.ДатаСледующегоПосещения.МинимальноеЗначение Тогда
		Сообщить("Некорректная дата посещения");
		Отказ = Истина;
	ИначеЕсли Запись.ДатаСледующегоПосещения > Элементы.ДатаСледующегоПосещения.МаксимальноеЗначение Тогда
		Сообщить("Некорректная дата посещения");
		Отказ = Истина;
	Иначе
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДатаСледующегоПосещенияПриИзменении(Элемент)
	СписокДнейНедели = Новый Соответствие;
	СписокДнейНедели.Вставить(1, "Пн");	СписокДнейНедели.Вставить(2, "Вт");	СписокДнейНедели.Вставить(3, "Ср");
	СписокДнейНедели.Вставить(4, "Чт");	СписокДнейНедели.Вставить(5, "Пт");	СписокДнейНедели.Вставить(6, "Сб");	СписокДнейНедели.Вставить(7, "Вс");
	
	Если ЗначениеЗаполнено( Запись.ДатаСледующегоПосещения )  Тогда
		Всп = СписокДнейНедели.Получить( ДеньНедели( Запись.ДатаСледующегоПосещения ) );
		Элементы.ДекорацияДеньНедели.Заголовок = Всп;
	Иначе
		Элементы.ДекорацияДеньНедели.Заголовок = "";
	КонецЕсли; 
КонецПроцедуры

