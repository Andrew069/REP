﻿&НаСервереБезКонтекста
Функция РасстояниеДоТочки(Контрагент, Широта, Долгота) Экспорт
	ЧислоПи = 3.1415926535897932;
	Если ТипЗнч(Контрагент) = Тип("СправочникСсылка.Контрагенты") И Не Контрагент.Пустая() Тогда
		Кл = Контрагент.ПолучитьОбъект();
		ШиротаКлиента = Кл.ГеографическаяШирота * ЧислоПи / 180;
		ДолготаКлиента = Кл.ГеографическаяДолгота * ЧислоПи / 180;
	
		Расстояние = 2
		*	aSin( Sqrt( Sin( (Широта*ЧислоПи/180 - ШиротаКлиента)/2 ) * Sin( (Широта * ЧислоПи / 180 - ШиротаКлиента)/2 )
		+		Cos( Широта*ЧислоПи/180 ) * Cos( ШиротаКлиента ) * Sin( (Долгота*ЧислоПи/180 - ДолготаКлиента)/2 ) * Sin( (Долгота*ЧислоПи/180 - ДолготаКлиента)/2 ) ) )
		*	6372795;
		Возврат Расстояние;
	Иначе
		Возврат 0;
	КонецЕсли;
КонецФункции	// РасстояниеДоТочки

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//Замер времени выполнения Начало
	//ЗамерыОперацийОбщий.НачатьИлиОбновитьЗамер("ОткрытиеФормы.НачалоАктивности", "",,,,Истина);
	
	ОбязательныйКомментарий = Ложь;
	
	Контрагент         = Параметры.Контрагент;
	Сотрудник          = Параметры.Сотрудник;
	АктуальныйМаршрут  = ОбщийМодульСервер.ПолучитьАктуальныйМаршрут(Сотрудник);
	// 2017-04-28 МСН
	ИскомаяСтрока = АктуальныйМаршрут.ЗаданияТП.Найти(Контрагент);
	Если ИскомаяСтрока <> Неопределено Тогда
		Элементы.КомандаВнеплановоеПосещение.Видимость = Ложь;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТипыПосещенийКлиентовТорговымиПредставителямиЗаданияТорговомуПредставителю.Ссылка,
		|	МАКСИМУМ(ТипыПосещенийКлиентовТорговымиПредставителямиЗаданияТорговомуПредставителю.Обязательное) КАК Обязательное
		|ИЗ
		|	Справочник.ТипыПосещенийКлиентовТорговымиПредставителями.ЗаданияТорговомуПредставителю КАК ТипыПосещенийКлиентовТорговымиПредставителямиЗаданияТорговомуПредставителю
		|ГДЕ
		|	ТипыПосещенийКлиентовТорговымиПредставителямиЗаданияТорговомуПредставителю.Ссылка = &ТипПосещения
		|	И ТипыПосещенийКлиентовТорговымиПредставителямиЗаданияТорговомуПредставителю.ВидЗадания = &ВидыЗаданий_Комментарий
		|
		|СГРУППИРОВАТЬ ПО
		|	ТипыПосещенийКлиентовТорговымиПредставителямиЗаданияТорговомуПредставителю.Ссылка";
		Запрос.УстановитьПараметр("ТипПосещения", ИскомаяСтрока.ТипПосещения);
		Запрос.УстановитьПараметр("ВидыЗаданий_Комментарий", ОбщийМодульПовтИсп.ВидыЗаданийТорговымПредставителямПолучитьПредопределенныйЭлемент("Комментарий"));
		
		РезультатЗапроса = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		ОбязательныйКомментарий = (ВыборкаДетальныеЗаписи.Следующий() И ВыборкаДетальныеЗаписи.Обязательное);
		
	Иначе
		ИскомаяСтрока      = АктуальныйМаршрут.ПланПосещений.Найти(Контрагент);
		Если ИскомаяСтрока = Неопределено Тогда
			Элементы.КомандаПлановоеПосещение.Видимость = Ложь;
		Иначе
			Элементы.КомандаВнеплановоеПосещение.Видимость = Ложь;
			
			Отбор = Новый Структура("ИдентификаторПлана", ИскомаяСтрока.Идентификатор);
			НайденныеСтроки = АктуальныйМаршрут.Задания.НайтиСтроки(Отбор);
			
			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				Если НайденнаяСтрока.Задание = "Комментарий" Тогда
					ОбязательныйКомментарий = Истина;
				КонецЕсли;	
			КонецЦикла;
			
		КонецЕсли;
	КонецЕсли;
	
	Если Истина
		И ЗначениеЗаполнено(Контрагент.СетьБренд)
		И Контрагент.СетьБренд.ТипСети = Перечисления.ТипыСетей.ФедеральнаяСеть
		Тогда
		
		ОбязательныйКомментарий = Истина;
	КонецЕсли;
	
	ЗаполнитьРеквизитыПоКонтрагенту();
	
	признЕстьКоординаты = Ложь;	Долгота = 0;	Широта = 0;
	#ЕСЛИ МОБИЛЬНОЕПРИЛОЖЕНИЕСЕРВЕР ТОГДА
		Попытка
			Координаты = ОбщийМодульСервер.ПолучитьТекущиеКоординатыСервер();
			Если Координаты <> Неопределено Тогда
				Рез = ОбщийМодульСервер.МэппингСтруктурКоординатСервер(Координаты);
				Долгота = Рез.Долгота;		Широта = Рез.Широта;
				признЕстьКоординаты = Истина;
			КонецЕсли;
		Исключение
		КонецПопытки;
	#КОНЕЦЕСЛИ
	
	Если признЕстьКоординаты Тогда
		Всп = РасстояниеДоТочки(Контрагент, Широта, Долгота);
		СинхронизацияСервер.ЗаписьЛога( Контрагент, "Широта " + Широта + ", долгота " + Долгота + ", расстояние " + Всп );
		Если Всп > 0 Тогда
			Элементы.КонтрагентАдрес.Заголовок = "Адрес доставки:    Расстояние до точки " + Формат(Всп, "ЧДЦ=0") + " м";
		КонецЕсли;
	КонецЕсли;
	
	//Замер времени выполнения Конец
	//ЗамерыОперацийОбщий.ЗавершитьЗамер("ОткрытиеФормы.НачалоАктивности",,);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВнеплановоеПосещение(Команда)
	
	//Замер времени выполнения Начало
	//ЗамерыОперацийОбщий.НачатьИлиОбновитьЗамер("ВыполнениеКоманды.ВнеплановоеПосещение",,,,,Истина);
	
	ОткрытьФормуПосещения(ПредопределенноеЗначение("Перечисление.ВидыПосещений.ВнеплановоеПосещение"));
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПлановоеПосещение(Команда)
	
	//Замер времени выполнения Начало
	//ЗамерыОперацийОбщий.НачатьИлиОбновитьЗамер("ВыполнениеКоманды.ПлановоеПосещение",,,,,Истина);
	
	ОткрытьФормуПосещения(ПредопределенноеЗначение("Перечисление.ВидыПосещений.ПлановоеПосещение"));
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаТелефонныйЗвонок(Команда)
	
	//Замер времени выполнения Начало
	//ЗамерыОперацийОбщий.НачатьИлиОбновитьЗамер("ВыполнениеКоманды.ТелефонныйЗвонок",,,,,Истина);
	
	ОткрытьФормуПосещения(ПредопределенноеЗначение("Перечисление.ВидыПосещений.ТелефонныйЗвонок"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВводаЦелиПосещения(Результат, ДопПараметры) Экспорт
	Если Результат <> Неопределено И ТипЗнч(Результат) = Тип("Структура")
		И Результат.Свойство("НачатьПосещение") И Результат.НачатьПосещение И Результат.Свойство("ЦельПосещения") Тогда
		
		ДопПараметры.Вставить("ЦельПосещения", Результат.ЦельПосещения);
		
		Закрыть(ДопПараметры);
	ИначеЕсли Результат <> Неопределено Тогда
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуПосещения(дВидОперации)
	Если дВидОперации <> ПредопределенноеЗначение("Перечисление.ВидыПосещений.ТелефонныйЗвонок") Тогда
		Парам = Новый Структура("Контрагент,ЦельПосещения", Контрагент, "");
		ДопПараметры = Новый Структура("ВидПосещения, Контрагент, Сотрудник, ОбязательныйКомментарий", дВидОперации, Контрагент, Сотрудник, ОбязательныйКомментарий);
		НоваяФорма = ОткрытьФорму( "ОбщаяФорма.ФормаВводаЦелиПосещения", Парам, ЭтаФорма, , , , Новый ОписаниеОповещения( "ПослеВводаЦелиПосещения", ЭтотОбъект, ДопПараметры ), );
		НоваяФорма.ЗакрыватьПриЗакрытииВладельца = Истина;
		
	Иначе
		Парам = Новый Структура("ВидПосещения, Контрагент, Сотрудник, ОбязательныйКомментарий", дВидОперации, Контрагент, Сотрудник, ОбязательныйКомментарий);
		Закрыть(Парам);
		
	КонецЕсли; 
КонецПроцедуры	

&НаКлиенте
Процедура КомандаНачатьПосещение(Команда)
	Если ПустаяСтрока(ЦельПосещения) Тогда
		ПоказатьПредупреждение(, "Не указана цель посещения");
	Иначе
		Парам = Новый Структура("ВидПосещения, Контрагент, Сотрудник, ОбязательныйКомментарий, ЦельПосещения", ВидОперации, Контрагент, Сотрудник, ОбязательныйКомментарий, ЦельПосещения);
		Закрыть(Парам);
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтменить(Команда)
	Закрыть();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыПоКонтрагенту()
	
	ДоговорКонтрагента = ДополнительныеФункцииСервер.ПолучитьАктуальныйДоговорКонтрагента(Контрагент);
	ЮридическийАдрес   = ДополнительныеФункцииСервер.ПолучитьЗначениеКИОбъекта(Контрагент, Константы.ВидКИ_ЮридическийАдрес.Получить());
	КонтактныйТелефон  = ДополнительныеФункцииСервер.ПолучитьЗначениеКИОбъекта(Контрагент, Константы.ВидКИ_Телефон.Получить());
	
	Рез     = ОбщийМодульСервер.ПолучитьНачалоКонецНедели();
	ДатаНач = Рез.НачалоНедели;
	ДатаКон = Рез.КонецНедели;
	
	Запрос        = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаНач",ДатаНач);
	Запрос.УстановитьПараметр("ДатаКон",ДатаКон);
	Запрос.УстановитьПараметр("ТорговыйПредставитель",ПараметрыСеанса.ТекущийПользователь.ФизЛицо);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НАЧАЛОПЕРИОДА(Маршрут.Дата, ДЕНЬ) КАК ДатаПосещения,
	|	Маршрут.Ссылка КАК Маршрут,
	|	ТипыПосещенийКлиентовТорговымиПредставителямиЗаданияТорговомуПредставителю.НомерСтроки,
	|	ТипыПосещенийКлиентовТорговымиПредставителямиЗаданияТорговомуПредставителю.ВидЗадания.Наименование,
	|	ЗНАЧЕНИЕ(Справочник.ШаблонАнкетыДляТП.ПустаяСсылка) КАК Поле1,
	|	ТипыПосещенийКлиентовТорговымиПредставителямиЗаданияТорговомуПредставителю.ВидЗадания КАК ВидЗадания,
	|	ТипыПосещенийКлиентовТорговымиПредставителямиЗаданияТорговомуПредставителю.Обязательное КАК Обязательное
	|ИЗ
	|	Документ.Маршрут КАК Маршрут
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Маршрут.ЗаданияТП КАК МаршрутЗаданияТП
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ТипыПосещенийКлиентовТорговымиПредставителями.ЗаданияТорговомуПредставителю КАК ТипыПосещенийКлиентовТорговымиПредставителямиЗаданияТорговомуПредставителю
	|			ПО МаршрутЗаданияТП.ТипПосещения = ТипыПосещенийКлиентовТорговымиПредставителямиЗаданияТорговомуПредставителю.Ссылка
	|		ПО (МаршрутЗаданияТП.Контрагент = &Контрагент)
	|			И Маршрут.Ссылка = МаршрутЗаданияТП.Ссылка
	|ГДЕ
	|	Маршрут.ТорговыйПредставитель = &ТорговыйПредставитель
	|	И Маршрут.Дата МЕЖДУ &ДатаНач И &ДатаКон
	|	И Маршрут.Проведен
	|	И МаршрутЗаданияТП.Контрагент = &Контрагент
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НАЧАЛОПЕРИОДА(МаршрутПланПосещений.Ссылка.Дата, ДЕНЬ),
	|	МаршрутПланПосещений.Ссылка,
	|	МаршрутЗадания.ИдентификаторЗадания,
	|	МаршрутЗадания.Задание,
	|	МаршрутЗадания.ШаблонАнкеты,
	|	ЗНАЧЕНИЕ(Справочник.ВидыЗаданийТорговымПредставителям.ПустаяСсылка),
	|	ЛОЖЬ
	|ИЗ
	|	Документ.Маршрут.ПланПосещений КАК МаршрутПланПосещений
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Маршрут.Задания КАК МаршрутЗадания
	|		ПО МаршрутПланПосещений.Ссылка = МаршрутЗадания.Ссылка
	|			И МаршрутПланПосещений.Идентификатор = МаршрутЗадания.ИдентификаторПлана
	|ГДЕ
	|	МаршрутПланПосещений.Ссылка.ТорговыйПредставитель = &ТорговыйПредставитель
	|	И МаршрутПланПосещений.Ссылка.Дата МЕЖДУ &ДатаНач И &ДатаКон
	|	И МаршрутПланПосещений.Ссылка.Проведен
	|	И МаршрутПланПосещений.Контрагент = &Контрагент
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаПосещения
	|ИТОГИ ПО
	|	ДатаПосещения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СРЕДНЕЕ(ТЧ.ПродажиСумма) КАК ПродажиСумма
	|ИЗ
	|	(ВЫБРАТЬ
	|		ОС_ДанныеПродажДляМП.Дата КАК Дата,
	|		СУММА(ОС_ДанныеПродажДляМП.ПродажиСумма) КАК ПродажиСумма
	|	ИЗ
	|		РегистрСведений.ОС_ДанныеПродажДляМП КАК ОС_ДанныеПродажДляМП
	|	ГДЕ
	|		ОС_ДанныеПродажДляМП.Контрагент = &Контрагент
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ОС_ДанныеПродажДляМП.Дата) КАК ТЧ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КомментарииПоКонтрагентам.Комментарий
	|ИЗ
	|	РегистрСведений.КомментарииПоКонтрагентам КАК КомментарииПоКонтрагентам
	|ГДЕ
	|	КомментарииПоКонтрагентам.Контрагент = &Контрагент";
	
	РЗ = Запрос.ВыполнитьПакет();
	
	ВыборкаИтог =  РЗ[0].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаИтог.Следующий() Цикл
		РазностьДатВДнях = ((ВыборкаИтог.ДатаПосещения - ДатаНач) / (60 * 60 * 24));
		Элементы["ДекорацияГрафикПосещений" + (РазностьДатВДнях + 1)].Заголовок = "1";
		Элементы["ДекорацияГрафикПосещений" + (РазностьДатВДнях + 1)].ЦветФона = Новый Цвет(30,230,30);
	КонецЦикла;	
	
	ВыборкаСумма = РЗ[1].Выбрать();
	Если ВыборкаСумма.Следующий() Тогда
		СреднийРазмерОтгрузки = ВыборкаСумма.ПродажиСумма;
	КонецЕсли;
	
	// 2017-06-12 МСН
	ВыборкаКомментарий = РЗ[2].Выбрать();
	Если ВыборкаКомментарий.Следующий() Тогда
		КомментарийПоКонтрагенту = ВыборкаКомментарий.Комментарий;
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	признЕстьКоординаты = Ложь;	Долгота = 0;	Широта = 0;
	#ЕСЛИ МОБИЛЬНОЕПРИЛОЖЕНИЕСЕРВЕР ТОГДА
		Попытка
			Координаты = ОбщийМодульСервер.ПолучитьТекущиеКоординатыСервер();
			Если Координаты <> Неопределено Тогда
				Рез = ОбщийМодульСервер.МэппингСтруктурКоординатСервер(Координаты);
				Долгота = Рез.Долгота;		Широта = Рез.Широта;
				признЕстьКоординаты = Истина;
			КонецЕсли;
		Исключение
		КонецПопытки;
	#КОНЕЦЕСЛИ
	
	Если признЕстьКоординаты Тогда
		Всп = РасстояниеДоТочки(Контрагент, Широта, Долгота);
		Если Всп > 0 Тогда
			Элементы.КонтрагентАдрес.Заголовок = "Адрес доставки:    Расстояние до точки " + Формат(Всп, "ЧДЦ=2");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
