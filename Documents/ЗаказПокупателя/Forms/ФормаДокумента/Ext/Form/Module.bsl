﻿&НаКлиенте
Перем РазрешитьЗаписьДокумента;

&НаКлиенте
Процедура ДобавитьТовар()
	//Отказ = Истина;
	Парам = Новый Структура("ТипЦен,АдресХранилищаТоваров,Контрагент,ДатаДоставки,Посещение,ДоговорКонтрагента,ТекДокумент"
	,		Объект.ТипЦен, ПолучитьАдресХранилищаТоваров(), Объект.Контрагент, Объект.ДатаДоставки, Объект.Посещение, Объект.ДоговорКонтрагента, Объект.Ссылка);
	Если Объект.ВидЗаказа = ПредопределенноеЗначение("Перечисление.ВидыЗаказов.ЗаказНаОтгрузкуБонусаПоВозвратам") Тогда
		Парам.Вставить("ДопустимаяСуммаЗаказаНаБонусЗаВозврат", ДопустимаяСуммаЗаказаНаБонусЗаВозврат);
	КонецЕсли;
	//ОкнаКлиентскогоПриложения = ПолучитьОкна();
	//Сообщить(ОкнаКлиентскогоПриложения.Количество());
	//НовоеОкно = Новый ОкноКлиентскогоПриложения;
	//ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора",Парам,ЭтаФорма,,НовоеОкно,,,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
	//ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора",Парам,ЭтаФорма);	
	ОткрытьФорму( "Справочник.Номенклатура.ФормаВыбора", Парам, ЭтаФорма, , , , , );
КонецПроцедуры

// КЛИЕНТСКИЕ ПРОЦЕДУРЫ И ФУНКЦИИ //

&НаКлиенте
Процедура ТоварыПослеУдаления(Элемент)
	ОбновитьНадписьТовары();
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	ОбновитьНадписьТовары();
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
	ДобавитьТовар()
	//Парам = Новый Структура("ТипЦен,АдресХранилищаТоваров,Контрагент,ДатаДоставки,Посещение,ДоговорКонтрагента,ТекДокумент",Объект.ТипЦен, ПолучитьАдресХранилищаТоваров(), Объект.Контрагент, Объект.ДатаДоставки, Объект.Посещение, Объект.ДоговорКонтрагента, Объект.Ссылка);
	//ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора", Парам, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ДобавленыТовары" И Источник.ВладелецФормы = ЭтаФорма Тогда
		ЗагрузитьТоварыИзХранилища(Параметр);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПриПодтвержденииЗаписиДокумента(Результат, ДопПараметры) Экспорт
	Если Результат = Неопределено Тогда
		РазрешитьЗаписьДокумента = Ложь;
	Иначе
		Парам = ПолучитьИзВременногоХранилища(Результат);
		ЗаполнитьЗначенияСвойств(Объект,Парам);
		ЗагрузитьТаблицуДопРеквизитов(Парам.ТаблицаДопРеквизитов);
		
		РазрешитьЗаписьДокумента = Истина;
		Если ТипЗнч(ДопПараметры) = Тип("РежимЗаписиДокумента") Тогда
			Записать( Новый Структура("РежимЗаписи", ДопПараметры) );
		Иначе
			Записать();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриПодтвержденииПроведенияДокумента(Результат, ДопПараметры) Экспорт
	Если Результат = Неопределено Тогда
		РазрешитьЗаписьДокумента = Ложь;
	Иначе
		Парам = ПолучитьИзВременногоХранилища(Результат);
		ЗаполнитьЗначенияСвойств(Объект,Парам);
		ЗагрузитьТаблицуДопРеквизитов(Парам.ТаблицаДопРеквизитов);
		
		РазрешитьЗаписьДокумента = Истина;
		Записать( Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение) );
		
		Если ТипЗнч(ДопПараметры) = Тип("Структура") И ДопПараметры.Свойство("Закрыть") И ДопПараметры.Закрыть Тогда
			Закрыть();
		КонецЕсли; 
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВывестиОкноПодтвержденияЗаписиЗаказа(ИмяПроцедурыОповещения, ПараметрыЗаписи) Экспорт
	Данные = Новый Структура("ВидДокумента,ДополнениеКАдресуДоставки,ПредЗаказ");
	ЗаполнитьЗначенияСвойств(Данные,Объект);
	Данные.Вставить("ТаблицаДопРеквизитов", АдресТаблицыДопРеквизитов());
	Парам = Новый Структура("ДатаДоставки,КоличествоСтрок,СуммаДокумента,РеквизитыДокумента,Проведен,ПредЗаказ"
	,	Объект.ДатаДоставки, Объект.Товары.Количество(), Объект.Товары.Итог("Сумма"), ПоместитьВоВременноеХранилище(Данные,Новый УникальныйИдентификатор), Объект.Проведен, Объект.Предзаказ);
	НоваяФорма = ПолучитьФорму("Документ.ЗаказПокупателя.Форма.ФормаПодтверждения", Парам, ЭтаФорма);
	Если Объект.ВидЗаказа = ПредопределенноеЗначение("Перечисление.ВидыЗаказов.ЗаказНаОтгрузкуБонусаПоВозвратам") Тогда
		Попытка
			НоваяФорма.Элементы.ОтдельнаяНакладная.Доступность = Ложь;
			НоваяФорма.Элементы.Предзаказ.Доступность = Ложь;
		Исключение
		КонецПопытки;
	КонецЕсли;
	НоваяФорма.ЗакрыватьПриЗакрытииВладельца = Истина;
	НоваяФорма.ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения( ИмяПроцедурыОповещения, ЭтотОбъект, ПараметрыЗаписи );
	НоваяФорма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
	НоваяФорма.Открыть();
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если Не ЗначениеЗаполнено(Объект.Ссылка) И Объект.Товары.Количество() = 0 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;	
	
	Если РазрешитьЗаписьДокумента Тогда
	ИначеЕсли Объект.ВидЗаказа <> ПредопределенноеЗначение("Перечисление.ВидыЗаказов.ЗаказНаОтгрузкуБонусаПоВозвратам") Тогда
		Отказ = Истина;
		ВывестиОкноПодтвержденияЗаписиЗаказа("ПриПодтвержденииЗаписиДокумента", ПараметрыЗаписи);
	КонецЕсли; 
	//Данные = Новый Структура("ВидДокумента,ДополнениеКАдресуДоставки,ПредЗаказ");
	//ЗаполнитьЗначенияСвойств(Данные,Объект);
	//Данные.Вставить("ТаблицаДопРеквизитов", АдресТаблицыДопРеквизитов());
	//Парам = Новый Структура("ДатаДоставки,КоличествоСтрок,СуммаДокумента,РеквизитыДокумента,Проведен,ПредЗаказ"
	//,	Объект.ДатаДоставки, Объект.Товары.Количество(), Объект.Товары.Итог("Сумма"), ПоместитьВоВременноеХранилище(Данные,Новый УникальныйИдентификатор), Объект.Проведен, Объект.Предзаказ);
	//Рез = ОткрытьФормуМодально("Документ.ЗаказПокупателя.Форма.ФормаПодтверждения",Парам);
	//Если Рез = Неопределено Тогда
	//	Отказ = Истина;
	//Иначе
	//	Парам = ПолучитьИзВременногоХранилища(Рез);
	//	ЗаполнитьЗначенияСвойств(Объект,Парам);
	//	ЗагрузитьТаблицуДопРеквизитов(Парам.ТаблицаДопРеквизитов);
	//КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ТекСтрока = Элементы.Товары.ТекущиеДанные;
	
	Парам = Новый Структура("Номенклатура,ХарактеристикаНоменклатуры,Цена,ЕдиницаИзмерения,ПроцентСкидкиНаценки");
	ЗаполнитьЗначенияСвойств(Парам,ТекСтрока);
	Парам.Вставить("Контрагент"        ,Объект.Контрагент);
	Парам.Вставить("КоличествоЗаказано",ТекСтрока.Количество);
	Парам.Вставить("СуммаЗаказано"     ,ТекСтрока.Сумма);
	
	СтандартнаяОбработка = ЛОЖЬ;
	ДополнительныеПараметры = Новый Структура("ТекСтрока",ТекСтрока);
	ОписаниеОповещения = Новый ОписаниеОповещения("ТоварыВыборЗавершение",ЭтаФорма,ДополнительныеПараметры);
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаВводаПараметровНоменклатуры", Парам,,,,,ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыВыборЗавершение(Рез, ДополнительныеПараметры) Экспорт
	Если Рез <> Неопределено Тогда
		Если Рез.КоличествоЗаказано = 0 Тогда
			Объект.Товары.Удалить(ДополнительныеПараметры.ТекСтрока.НомерСтроки-1);
		Иначе
			ТекСтрока = ДополнительныеПараметры.ТекСтрока;
			ЗаполнитьЗначенияСвойств(ТекСтрока,Рез,"Цена,ПроцентСкидкиНаценки");
			ТекСтрока.Количество = Рез.КоличествоЗаказано;
			ТекСтрока.Сумма      = ТекСтрока.Цена * ТекСтрока.Количество * (1 - ТекСтрока.ПроцентСкидкиНаценки / 100);
		КонецЕсли;
		//Модифицированность = Истина;
	КонецЕсли; 
КонецПроцедуры	

// СЕРВЕРНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ //

&НаСервере
Процедура ЗагрузитьТаблицуДопРеквизитов(Адрес)
	Если ЭтоАдресВременногоХранилища(Адрес) Тогда
		Объект.ДополнительныеРеквизиты.Загрузить(ПолучитьИзВременногоХранилища(Адрес));
	КонецЕсли;
КонецПроцедуры	

&НаСервере
Функция АдресТаблицыДопРеквизитов() Экспорт
	Возврат ПоместитьВоВременноеХранилище(Объект.ДополнительныеРеквизиты.Выгрузить());
КонецФункции	

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Ссылка") И ТипЗнч(Параметры.Ссылка) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
		ЗначениеВРеквизитФормы(Параметры.Ссылка.ПолучитьОбъект(), "Объект");
	КонецЕсли;
	
	//Если Объект.Проведен Тогда
	//	ЭтаФорма.ТолькоПросмотр = Истина;
	//КонецЕсли;	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Ответственный      = Константы.ТекущийПользователь.Получить();
		Объект.ДоговорКонтрагента = Объект.Контрагент.ОсновнойДоговор;
		Объект.ТипЦен             = ДополнительныеФункцииСервер.ПолучитьАктуальныйДоговорКонтрагента(Объект.Контрагент).ТипЦен;
		
		Если Параметры.Свойство("Основание") И ТипЗнч(Параметры.Основание) = Тип("Структура") И Параметры.Основание.Свойство("ВидЗаказа") Тогда
			Объект.ВидЗаказа = Параметры.Основание.ВидЗаказа;
		КонецЕсли;
		Если Параметры.Свойство("Основание") И ТипЗнч(Параметры.Основание) = Тип("Структура") И Параметры.Основание.Свойство("ВидДокумента") Тогда
			Объект.ВидДокумента = Параметры.Основание.ВидДокумента;
		КонецЕсли;
	КонецЕсли;	
	Заголовок = "Заказ на " + ОбщийМодульСервер.ФорматДаты(Объект.ДатаДоставки, Истина) + " контрагент: " + Объект.Контрагент;
	ОбновитьИсториюПродажТоваров();
	ОбновитьНадписьТовары();
	//ОбновитьДеревоТоваров();
КонецПроцедуры

&НаСервере
Процедура ОбновитьНадписьТовары ()
	SKUВЗаказе  = Объект.Товары.Количество();
	СуммаЗаказа = Объект.Товары.Итог("Сумма");
	Элементы.НадписьДобавьте.Видимость = Объект.Товары.Количество() = 0;
	Элементы.НадписьАкция.Видимость    = Не ПустаяСтрока(Элементы.НадписьАкция.Заголовок);
КонецПроцедуры	

&НаСервере
Функция ПолучитьАдресХранилищаТоваров ()
	Рез = Объект.Товары.Выгрузить();
	Возврат ПоместитьВоВременноеХранилище(Рез,ЭтаФорма.УникальныйИдентификатор);
КонецФункции	

&НаСервере
Процедура ЗагрузитьТоварыИзХранилища (Параметр)
	Если ТипЗнч(Параметр) = Тип("Массив") Тогда
		Объект.Товары.Очистить();
		Для каждого структСтроки Из Параметр Цикл
			Если ТипЗнч(структСтроки) = Тип("Структура") Тогда
				ЗаполнитьЗначенияСвойств(Объект.Товары.Добавить(), структСтроки);
			КонецЕсли;
		КонецЦикла;
		ТабТовары = Объект.Товары.Выгрузить();
		
		СтруктураШапки = Новый Структура("Контрагент,ДатаОтгрузки",Объект.Контрагент,Объект.ДатаДоставки);
		ТекстСообщения = "";
		Балмико_УправлениеАкциями.ЗаполнитьТабличнуюЧастьПоАкции(ТабТовары,СтруктураШапки,ТекстСообщения);
		Элементы.НадписьАкция.Заголовок = ТекстСообщения;
		Объект.Товары.Загрузить(ТабТовары);		
		ОбновитьИсториюПродажТоваров();
		Для Каждого СтрокаТЧ Из Объект.Товары Цикл
			СтрокаТЧ.ЕдиницаИзмерения = СтрокаТЧ.Номенклатура.ЕдиницаХраненияОстатков;
		КонецЦикла;
		Если ТабТовары.Количество() > 0 Тогда
			Модифицированность = Истина;
		КонецЕсли;
		
	ИначеЕсли ЭтоАдресВременногоХранилища(Параметр) Тогда
		ТабТовары = ПолучитьИзВременногоХранилища(Параметр); 
		СтруктураШапки = Новый Структура("Контрагент,ДатаОтгрузки",Объект.Контрагент,Объект.ДатаДоставки);
		ТекстСообщения = "";
		Балмико_УправлениеАкциями.ЗаполнитьТабличнуюЧастьПоАкции(ТабТовары,СтруктураШапки,ТекстСообщения);
		Элементы.НадписьАкция.Заголовок = ТекстСообщения;
		Объект.Товары.Загрузить(ТабТовары);		
		ОбновитьИсториюПродажТоваров();
		Для Каждого СтрокаТЧ Из Объект.Товары Цикл
			СтрокаТЧ.ЕдиницаИзмерения = СтрокаТЧ.Номенклатура.ЕдиницаХраненияОстатков;
		КонецЦикла;
		Если ТабТовары.Количество() > 0 Тогда
			Модифицированность = Истина;
		КонецЕсли;
	КонецЕсли;	
	//ОбновитьДеревоТоваров();
	ОбновитьНадписьТовары();
КонецПроцедуры	

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("НовыйЗаказ");
	ОбщийМодульКлиент.ЗафиксироватьМестоположение(Объект.Ссылка, "Оформлен заказ");
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ОбновитьИсториюПродажТоваров();
КонецПроцедуры

&НаСервере
Процедура ОбновитьИсториюПродажТоваров()
	ДополнительныеФункцииСервер.ЗаполнитьИсториюПродажТоваров(ЭтаФорма,Объект.Товары,Объект.Контрагент,Объект.ДатаДоставки,Объект.Ссылка);		
КонецПроцедуры	

// ДЕРЕВО ТОВАРОВ //

&НаСервере
Процедура ОбновитьДеревоТоваров()
	мДерево = РеквизитФормыВЗначение("ДеревоТоваров");
	мДерево.Строки.Очистить();
	
	Рез = ДополнительныеФункцииСервер.ПолучитьИсториюПродажТоваров(Объект.Товары.Выгрузить().ВыгрузитьКолонку("Номенклатура"),Объект.Контрагент);

	Для Каждого СтрокаТЧ Из Объект.Товары Цикл
		//мРодитель = ПолучитьРодителяНоменклатуры(СтрокаТЧ.Номенклатура);
		//ИскомаяСтрока = мДерево.Строки.Найти(мРодитель);
		//Если ИскомаяСтрока = Неопределено Тогда
		//	ИскомаяСтрока = мДерево.Строки.Добавить();
		//	ИскомаяСтрока.ГруппаНоменклатуры = мРодитель;
		//КонецЕсли;	
		//НоваяСтрока = ИскомаяСтрока.Строки.Добавить();
		НоваяСтрока = мДерево.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,СтрокаТЧ);
		
		ИскомыеСтроки = Рез.НайтиСтроки(Новый Структура("Номенклатура",СтрокаТЧ.Номенклатура));
		СЧ = 5;
		Для Каждого ИскомаяСтрока Из ИскомыеСтроки Цикл
			СЧ = СЧ - 1;
			Если СЧ = 0 Тогда
				Прервать;
			КонецЕсли;
			НоваяСтрока["ПродажиВозвраты" + СЧ] =  "" + Формат(ИскомаяСтрока.КоличествоОборот,"ЧДЦ=; ЧН=0; ЧГ=0") + "/" + Формат(ИскомаяСтрока.КоличествоВозвратОборот,"ЧДЦ=; ЧН=0; ЧГ=0");  
		КонецЦикла;
		
		Если СЧ >= 1 Тогда
			Пока СЧ > 1 Цикл
				СЧ = СЧ - 1;
				НоваяСтрока["ПродажиВозвраты" + СЧ] = "0/0";
			КонецЦикла;	
		КонецЕсли;	
	КонецЦикла;	
	мДерево.Строки.Сортировать("ГруппаНоменклатуры Возр");
	ЗначениеВРеквизитФормы(мДерево,"ДеревоТоваров");
КонецПроцедуры	

&НаСервереБезКонтекста
Функция ПолучитьРодителяНоменклатуры(Номенклатура)
	Если Номенклатура.Родитель = Справочники.Номенклатура.ПустаяСсылка() Тогда
		Возврат Справочники.Номенклатура.ПустаяСсылка();
	ИначеЕсли Номенклатура.Родитель.Родитель = Справочники.Номенклатура.ПустаяСсылка() Тогда
		Возврат Справочники.Номенклатура.ПустаяСсылка();
	ИначеЕсли Номенклатура.Родитель.Родитель.Родитель = Справочники.Номенклатура.ПустаяСсылка() Тогда
		Возврат Номенклатура.Родитель;
	ИначеЕсли Номенклатура.Родитель.Родитель.Родитель.Родитель = Справочники.Номенклатура.ПустаяСсылка() Тогда
		Возврат Номенклатура.Родитель.Родитель;
	ИначеЕсли Номенклатура.Родитель.Родитель.Родитель.Родитель.Родитель = Справочники.Номенклатура.ПустаяСсылка() Тогда
		Возврат Номенклатура.Родитель.Родитель.Родитель;
	КонецЕсли;	
КонецФункции	

&НаКлиенте
Процедура ДеревоТоваровВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ТекСтрока = Элементы.ДеревоТоваров.ТекущиеДанные;
	
	Если Не ЗначениеЗаполнено(ТекСтрока.ГруппаНоменклатуры) Тогда
		СтандартнаяОбработка = ЛОЖЬ;
		Парам = Новый Структура("Номенклатура,ХарактеристикаНоменклатуры,Цена,ЕдиницаИзмерения,ПроцентСкидкиНаценки");
		ЗаполнитьЗначенияСвойств(Парам,ТекСтрока);
		Парам.Вставить("Контрагент"        ,Объект.Контрагент);
		Парам.Вставить("КоличествоЗаказано",ТекСтрока.Количество);
		Парам.Вставить("СуммаЗаказано"     ,ТекСтрока.Сумма);
		ДополнительныеПараметры = Новый Структура("ТекСтрока",ТекСтрока);
		ОписаниеОповещения      = Новый ОписаниеОповещения("ДеревоТоваровВыборЗавершение",ЭтаФорма, ДополнительныеПараметры);
		ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаВводаПараметровНоменклатуры",Парам,ЭтаФорма,,,,ОписаниеОповещения);
		ОбновитьНадписьТовары();
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоТоваровВыборЗавершение(Рез, ДополнительныеПараметры) Экспорт 
	Если Рез <> Неопределено Тогда
		ТекСтрока = ДополнительныеПараметры.ТекСтрока;
		
		ИскомыеСтроки = Объект.Товары.НайтиСтроки(Новый Структура("Номенклатура",ТекСтрока.Номенклатура));
		Для Каждого ИскомаяСтрока Из ИскомыеСтроки Цикл
			Если Рез.КоличествоЗаказано = 0 Тогда	
				Объект.Товары.Удалить(ИскомаяСтрока);
			Иначе	
				ЗаполнитьЗначенияСвойств(ИскомаяСтрока,Рез,"Цена,ПроцентСкидкиНаценки");
				ИскомаяСтрока.Количество = Рез.КоличествоЗаказано;
				ИскомаяСтрока.Сумма      = ИскомаяСтрока.Цена * ИскомаяСтрока.Количество * (1 - ИскомаяСтрока.ПроцентСкидкиНаценки / 100);
				ЗаполнитьЗначенияСвойств(ТекСтрока,ИскомаяСтрока);
			КонецЕсли;
		КонецЦикла;
		
		Если Рез.КоличествоЗаказано = 0 Тогда     
			ТекРодитель = ТекСтрока.ПолучитьРодителя();
			Если ТекРодитель <> Неопределено Тогда
				ТекРодитель.ПолучитьЭлементы().Удалить(ТекСтрока);
				Если ТекРодитель.ПолучитьЭлементы().Количество() = 0 Тогда
					ДеревоТоваров.ПолучитьЭлементы().Удалить(ТекРодитель);
				КонецЕсли;	
			Иначе
				ДеревоТоваров.ПолучитьЭлементы().Удалить(ТекСтрока);					
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;		
КонецПроцедуры	

&НаКлиенте
Процедура ДеревоТоваровПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
	
	ДобавитьТовар();
	//Парам = Новый Структура("ТипЦен,АдресХранилищаТоваров,Контрагент,ДатаДоставки,Посещение,ДоговорКонтрагента,ТекДокумент",Объект.ТипЦен,ПолучитьАдресХранилищаТоваров(),Объект.Контрагент,Объект.ДатаДоставки,Объект.Посещение,Объект.ДоговорКонтрагента,Объект.Ссылка);
	//ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора",Парам,ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ДеревоТоваровПередУдалением(Элемент, Отказ)
	ТекСтрока = Элементы.ДеревоТоваров.ТекущиеДанные;
	Если Не ЗначениеЗаполнено(ТекСтрока.ГруппаНоменклатуры) Тогда
		ИскомыеСтроки = Объект.Товары.НайтиСтроки(Новый Структура("Номенклатура",ТекСтрока.Номенклатура));
		Для Каждого ИскомаяСтрока Из ИскомыеСтроки Цикл
			Объект.Товары.Удалить(ИскомаяСтрока);
		КонецЦикла;	
		ТекРодитель = ТекСтрока.ПолучитьРодителя();
		Если ТекРодитель <> Неопределено И ТекРодитель.ПолучитьЭлементы().Количество() = 1 Тогда
			ДеревоТоваров.ПолучитьЭлементы().Удалить(ТекРодитель);
			Отказ = Истина;
		КонецЕсли;	
	Иначе
		Для Каждого СтрокаПодч Из ТекСтрока.ПолучитьЭлементы() Цикл
			ИскомыеСтроки = Объект.Товары.НайтиСтроки(Новый Структура("Номенклатура",СтрокаПодч.Номенклатура));
			Для Каждого ИскомаяСтрока Из ИскомыеСтроки Цикл
				Объект.Товары.Удалить(ИскомаяСтрока);
			КонецЦикла;	
		КонецЦикла;	
	КонецЕсли;
	ОбновитьНадписьТовары();
КонецПроцедуры

&НаКлиенте
Процедура КомандаДобавить(Команда)
	ДобавитьТовар();	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Объект.ВидЗаказа = ПредопределенноеЗначение("Перечисление.ВидыЗаказов.ЗаказНаОтгрузкуБонусаПоВозвратам") Тогда
		ДопустимаяСуммаЗаказаНаБонусЗаВозврат = ОбщийМодульСервер.РассчитатьДопустимуюСуммаЗаказаНаБонусЗаВозврат( Объект.Контрагент );
		
		Элементы.ДекорацияВидЗаказа.Видимость = Истина;
		Элементы.ДекорацияВидЗаказа.Заголовок = "Заказ на бонус за возврат до " + Формат(ДопустимаяСуммаЗаказаНаБонусЗаВозврат, "ЧДЦ=2") + " руб.";
	Иначе
		Элементы.ДекорацияВидЗаказа.Видимость = Ложь;
		ДопустимаяСуммаЗаказаНаБонусЗаВозврат = 0;
	КонецЕсли; 
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПодключитьОбработчикОжидания("ДобавитьТовар", 0.1, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КомандаПровестиИЗакрыть(Команда)
	Если Не ЗначениеЗаполнено(Объект.Ссылка) И Объект.Товары.Количество() = 0 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Объект.ВидЗаказа = ПредопределенноеЗначение("Перечисление.ВидыЗаказов.ЗаказНаОтгрузкуБонусаПоВозвратам") Тогда
		РазрешитьЗаписьДокумента = Истина;
		Если Записать( Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение) ) Тогда
			Закрыть();
		КонецЕсли;
	Иначе
		ВывестиОкноПодтвержденияЗаписиЗаказа( "ПриПодтвержденииПроведенияДокумента", Новый Структура("Закрыть", Истина) );
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписать(Команда)
	Если Не ЗначениеЗаполнено(Объект.Ссылка) И Объект.Товары.Количество() = 0 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;	
	
	Если Объект.ВидЗаказа = ПредопределенноеЗначение("Перечисление.ВидыЗаказов.ЗаказНаОтгрузкуБонусаПоВозвратам") Тогда
		РазрешитьЗаписьДокумента = Истина;
		Записать();
	Иначе
		ВывестиОкноПодтвержденияЗаписиЗаказа("ПриПодтвержденииЗаписиДокумента", Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КомандаПровести(Команда)
	Если Не ЗначениеЗаполнено(Объект.Ссылка) И Объект.Товары.Количество() = 0 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;	
	
	Если Объект.ВидЗаказа = ПредопределенноеЗначение("Перечисление.ВидыЗаказов.ЗаказНаОтгрузкуБонусаПоВозвратам") Тогда
		РазрешитьЗаписьДокумента = Истина;
		Записать( Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение) );
	Иначе
		ВывестиОкноПодтвержденияЗаписиЗаказа( "ПриПодтвержденииПроведенияДокумента", Неопределено );
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если ТекущийОбъект.ВидЗаказа = Перечисления.ВидыЗаказов.ЗаказНаОтгрузкуБонусаПоВозвратам
		И ТекущийОбъект.Товары.Итог("Сумма") > ДопустимаяСуммаЗаказаНаБонусЗаВозврат Тогда
		
		Отказ = Истина;
		Сообщить("Нельзя вводить заказ на компенсацию возврата на сумму больше чем сумма бонуса.
		|Вам необходимо уменьшить сумму заказа!");
		
	КонецЕсли;
КонецПроцедуры

РазрешитьЗаписьДокумента = Ложь;
