﻿
Процедура ПроверитьПлан() Экспорт
	
	
	//Проверим на правильность
	
	ВыборкаПланов = ПланыОбмена.ОС_ОбменСМобильнымиУстройствами.Выбрать();
	
	Сч = 0;
	Пока ВыборкаПланов.Следующий() Цикл
		Сч = Сч + 1;
	КонецЦикла;
	
	//РаботаСЖурналом.ОС_ЗаписьЖурналаРегистрации("Сч: ",, Сч);
	
	Если Сч = 2 Тогда
		//Если ПланыОбмена.ОС_ОбменСМобильнымиУстройствами.ЭтотУзел().ПолучитьОбъект() = Неопределено Тогда
		//	//РаботаСЖурналом.ОС_ЗаписьЖурналаРегистрации("Тес3: ",, "Тест3");
		//	ВыборкаПланов = ПланыОбмена.ОС_ОбменСМобильнымиУстройствами.Выбрать();
		//	
		//	Пока ВыборкаПланов.Следующий() Цикл
		//		
		//		Если ВыборкаПланов.Код = "ЦБ" Тогда
		//			Продолжить;
		//		КонецЕсли;
		//		ПланОбъект = ВыборкаПланов.ПолучитьОбъект();
		//		ПланОбъект.ОбменДанными.Загрузка = Истина;
		//		ПланОбъект.Код = ПланОбъект.Код;
		//		ПланОбъект.ЭтотУзел = Истина;
		//		ПланОбъект.Записать();
		//	КонецЦикла;

		//КонецЕсли;
	ИначеЕсли Сч = 3 Тогда
		Если ЗначениеЗаполнено(ПланыОбмена.ОС_ОбменСМобильнымиУстройствами.ЭтотУзел().Код) Тогда
			//УдалимБезНаименования
			ВыборкаПланов = ПланыОбмена.ОС_ОбменСМобильнымиУстройствами.Выбрать();
			
			Пока ВыборкаПланов.Следующий() Цикл
				
				Если ВыборкаПланов.Код = "ЦБ" Тогда
					Продолжить;
				КонецЕсли;
				Если Не ЗначениеЗаполнено(ВыборкаПланов.Код) Тогда
					ПланОбъект = ВыборкаПланов.ПолучитьОбъект();
					//ПланОбъект.ЭтотУзел = Истина;
					ПланОбъект.Удалить();
				КонецЕсли;
			КонецЦикла;

		Иначе
			//ПоменяемКоды
			ВыборкаПланов = ПланыОбмена.ОС_ОбменСМобильнымиУстройствами.Выбрать();
			
			Пока ВыборкаПланов.Следующий() Цикл
				
				Если ВыборкаПланов.Код = "ЦБ" Тогда
					Продолжить;
				КонецЕсли;
				Если ЗначениеЗаполнено(ВыборкаПланов.Код) Тогда
					Код = ВыборкаПланов.Код;
					Наименование = ВыборкаПланов.Наименование;
					ПланОбъект = ВыборкаПланов.ПолучитьОбъект();
					//ПланОбъект.ЭтотУзел = Истина;
					//ПланОбъект.ОбменДанными.Загрузка = Истина;
					ПланОбъект.Код = "_"+Код;
					ПланОбъект.Наименование = "_"+Наименование;
					ПланОбъект.Записать();
				КонецЕсли;
			КонецЦикла;
			ВыборкаПланов = ПланыОбмена.ОС_ОбменСМобильнымиУстройствами.Выбрать();
			
			Пока ВыборкаПланов.Следующий() Цикл
				
				Если ВыборкаПланов.Код = "ЦБ" Тогда
					Продолжить;
				КонецЕсли;
				Если Не ЗначениеЗаполнено(ВыборкаПланов.Код) Тогда
					ПланОбъект = ВыборкаПланов.ПолучитьОбъект();
					//ПланОбъект.ЭтотУзел = Истина;
					//ПланОбъект.ОбменДанными.Загрузка = Истина;
					ПланОбъект.Код = Код;
					ПланОбъект.Наименование = Наименование;
					ПланОбъект.Записать();
				Иначе
					ПланОбъект = ВыборкаПланов.ПолучитьОбъект();
					//ПланОбъект.ЭтотУзел = Истина;
					ПланОбъект.Удалить();					
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
	КонецЕсли;
			
КонецПроцедуры

Процедура ОчиститьОграничения() Экспорт
	
	НЗ = РегистрыСведений.ОграчениеОтгрузокВозвратообразущейПродукции.СоздатьНаборЗаписей();
	НЗ.Записать();
	Константы.ОграниченияОчищены.Установить(Истина); 
	
КонецПроцедуры


