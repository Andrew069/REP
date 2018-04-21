﻿Функция ПолучитьМассивЗамеров() Экспорт 
	
	Результат = ЗамерыОперацийОбщий.ПолучитьМассивЗамеров();
	Возврат Результат;
	
КонецФункции

Функция УстановитьМассивЗамеров(МассивЗамеров) Экспорт 
	
	ЗамерыОперацийОбщий.УстановитьМассивЗамеров(МассивЗамеров);
	Возврат Неопределено;
	
КонецФункции

Функция ЗарегистрироватьЗамер(ИмяОперации, Длительность, СсылкаОбъекта, ИмяКомпьютера, Комментарий) Экспорт 
	
	НастройкиЗамеров = ЗамерыОперацийКэшируемый.ПолучитьПараметрыЗамеровОпераций();
	Если СсылкаОбъекта <> Неопределено Тогда
		МетаданныеОбъекта = СсылкаОбъекта.Метаданные();
	КонецЕсли; 
	//Если НастройкиЗамеров.РегистрироватьВЖурналеРегистрации Тогда
	//	Разделитель = "^;^";
	//	//ЗаписьЖурналаРегистрации("КонтрольнаяОперация", УровеньЖурналаРегистрации.Предупреждение, МетаданныеОбъекта, СсылкаОбъекта,
	//	//	ИмяОперации + Разделитель + Формат(Длительность, "ЧГ=") + Разделитель + Комментарий, РежимТранзакцииЗаписиЖурналаРегистрации.Независимая);   <<PSV>>
	//КонецЕсли; 
	Если НастройкиЗамеров.РегистрироватьВРегистре Тогда
		
		СистемнаяИнформация = ПолучитьСистемнуюИнформацию();
		#Если Не МобильноеПриложениеКлиент И Не МобильноеПриложениеСервер Тогда
			НомерСеанса = НомерСеансаИнформационнойБазы();
		#Иначе
			НомерСеанса = 0;
		#КонецЕсли	
		
		ПолноеИмяМетаданных = "";
		Если МетаданныеОбъекта <> Неопределено Тогда
			ПолноеИмяМетаданных = МетаданныеОбъекта.ПолноеИмя();
		КонецЕсли; 
		Если НастройкиЗамеров.ЭтоФайловаяБаза Тогда
			ЗамерыОперацийСервер.ЗаписатьЗамерВРегистр(ИмяОперации, Длительность, СсылкаОбъекта, ПолноеИмяМетаданных, ТекущаяДата(), ИмяКомпьютера, 
				СистемнаяИнформация.ВерсияОС, СистемнаяИнформация.ВерсияПриложения, СистемнаяИнформация.ОперативнаяПамять, СистемнаяИнформация.Процессор, НомерСеанса, Комментарий);
		Иначе
			ПараметрыВызова = Новый Массив;
			ПараметрыВызова.Добавить(ИмяОперации);
			ПараметрыВызова.Добавить(Длительность);
			ПараметрыВызова.Добавить(СсылкаОбъекта);
			ПараметрыВызова.Добавить(ПолноеИмяМетаданных);
			ПараметрыВызова.Добавить(ТекущаяДата());
			ПараметрыВызова.Добавить(ИмяКомпьютера);
			ПараметрыВызова.Добавить(СистемнаяИнформация.ВерсияОС);
			ПараметрыВызова.Добавить(СистемнаяИнформация.ВерсияПриложения);
			ПараметрыВызова.Добавить(СистемнаяИнформация.ОперативнаяПамять);
			ПараметрыВызова.Добавить(СистемнаяИнформация.Процессор);
			ПараметрыВызова.Добавить(НомерСеанса);
			ПараметрыВызова.Добавить(Комментарий);
			ФоновыеЗадания.Выполнить("ЗамерыОперацийСервер.ЗаписатьЗамерВРегистр", ПараметрыВызова, Новый УникальныйИдентификатор, "Фоновая регистрация замера операции");
		КонецЕсли; 
	КонецЕсли; 
	
КонецФункции
	
Функция ЗаписатьЗамерВРегистр(ИмяОперации, Длительность, СсылкаОбъекта, ПолноеИмяМетаданных, ДатаКонца, Компьютер, ВерсияОС, ВерсияПриложения, ОперативнаяПамять, Процессор, НомерСеанса, Комментарий) Экспорт 
	
	МенеджерЗаписи = РегистрыСведений.ЗамерыОпераций.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ДатаКонца = ДатаКонца;
	МенеджерЗаписи.ИмяОперации = ИмяОперации;
	МенеджерЗаписи.Данные = СсылкаОбъекта;
	МенеджерЗаписи.Метаданные = ПолноеИмяМетаданных;
	МенеджерЗаписи.Длительность = Длительность / 1000;
	МенеджерЗаписи.Пользователь = ПараметрыСеанса.ТекущийПользователь; 
	МенеджерЗаписи.Компьютер = Компьютер;
	МенеджерЗаписи.Комментарий = Комментарий;
	МенеджерЗаписи.ВерсияОС = ВерсияОС;
	МенеджерЗаписи.ВерсияПриложения = ВерсияПриложения;
	МенеджерЗаписи.ОперативнаяПамять = ОперативнаяПамять;
	МенеджерЗаписи.Процессор = Процессор;
	МенеджерЗаписи.НомерСеанса = НомерСеанса;
	
	Попытка
		МенеджерЗаписи.Записать(Ложь);
	Исключение
	КонецПопытки;
	
КонецФункции

Функция ЭтоФоновоеЗадание() Экспорт 

	//НомерСеанса = НомерСеансаИнформационнойБазы();
	//Сеансы = ПолучитьСеансыИнформационнойБазы();
	//Для Каждого Сеанс Из Сеансы Цикл
	//	Если Сеанс.НомерСеанса = НомерСеанса Тогда
	//		Результат = НРег(Сеанс.ИмяПриложения) = НРег("BackgroundJob");
	//		Прервать;
	//	КонецЕсли; 
	//КонецЦикла;
	//Возврат Результат;

	Возврат Ложь;
	
КонецФункции // ЭтоФоновоеЗадание()

Функция ПолучитьПараметрыЗамеровОпераций() Экспорт 
	
	МенеджерЗаписи = РегистрыСведений.ЗамерыОперацийНастройки.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Прочитать();
	Если Не МенеджерЗаписи.Выбран() Тогда
		// заполним настройки по умолчанию 
		//МенеджерЗаписи.РегистрироватьВЖурналеРегистрации = Истина;
		МенеджерЗаписи.РегистрироватьВРегистреСразу = Истина;
		МенеджерЗаписи.СрокХраненияДанныхВРегистре = 30;
		//МенеджерЗаписи.РегистрироватьАвтозадания = Ложь;
		МенеджерЗаписи.Записать();
	КонецЕсли; 
	Настройки = Новый Структура;
	Настройки.Вставить("ЭтоФоновоеЗадание", ЭтоФоновоеЗадание());
	Настройки.Вставить("ЭтоФайловаяБаза", Истина);//Не ПустаяСтрока(НСтр(СтрокаСоединенияИнформационнойБазы(), "File")));  <<PSV>>
	//Настройки.Вставить("РегистрироватьВЖурналеРегистрации", МенеджерЗаписи.РегистрироватьВЖурналеРегистрации);
	Настройки.Вставить("РегистрироватьВРегистре", МенеджерЗаписи.РегистрироватьВРегистреСразу);
	Настройки.Вставить("СрокХраненияДанныхВРегистре", МенеджерЗаписи.СрокХраненияДанныхВРегистре);
	Настройки.Вставить("ЗамерыВключены", Ложь
		//Или МенеджерЗаписи.РегистрироватьВЖурналеРегистрации
		Или МенеджерЗаписи.РегистрироватьВРегистреСразу);
	//Настройки.Вставить("РегистрироватьАвтозадания", МенеджерЗаписи.РегистрироватьАвтозадания);
	Возврат Настройки;
	
КонецФункции 

Функция ПолучитьСистемнуюИнформацию() Экспорт
	
	СисИнфо = Новый СистемнаяИнформация;	
	
	Возврат СисИнфо;
	
КонецФункции	