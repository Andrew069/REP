//#Если НЕ ТонкийКлиент И НЕ ВебКлиент Тогда

//Функция ПолучитьСлужбуWMI() Экспорт

//	// Настройка разрешений http://www.microsoft.com/resources/documentation/windows/xp/all/proddocs/en-us/wmi_add_user_or_group.mspx?mfr=true
//	// wmimgmt.msc
//	
//	//http://msdn.microsoft.com/en-us/library/windows/desktop/aa389763(v=vs.85).aspx
//	Локатор = Новый COMОбъект("WbemScripting.SWbemLocator");
//	Попытка
//		// ConnectServer - http://msdn.microsoft.com/en-us/library/windows/desktop/aa393720%28v=vs.85%29.aspx
//		СлужбаWMI = Локатор.ConnectServer("localhost", "root\cimv2"); 
//	Исключение
//		ОписаниеОшибки = ОписаниеОшибки();
//	КонецПопытки; 
//	Возврат СлужбаWMI;

//КонецФункции

//Функция ПолучитьСкриптМенеджер(Язык = "javascript") Экспорт
//	
//	Попытка
//		СкриптМенеджер = Новый COMОбъект("MSScriptControl.ScriptControl");
//		СкриптМенеджер.Language = Язык;
//	Исключение
//		// Это 64-х разрядный процесс
//		ОписаниеОшибки = ОписаниеОшибки();
//	КонецПопытки; 
//	Возврат СкриптМенеджер;
//	
//КонецФункции

//#КонецЕсли

Функция ПолучитьПараметрыЗамеровОпераций() Экспорт 
	
	Результат = ЗамерыОперацийСервер.ПолучитьПараметрыЗамеровОпераций();
	Возврат Результат;
	
КонецФункции 

