Class {
	#name : 'TestPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'labelPresenter',
		'buttonPresenter',
		'fieldPresenter',
		'comboboxPresenter',
		'multComboboxPresenter',
		'form',
		'radioGroup',
		'checkboxGroupPresenter',
		'wizard',
		'searchTable',
		'date'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'layout' }
TestPresenter >> defaultLayout [

	| tmp1 |
	tmp1 := SpBoxLayout new.
	tmp1 add: wizard.
	^ tmp1 yourself
]

{ #category : 'initialization' }
TestPresenter >> initializePresenters [

	| tmp1 tmp2 step1 step2 step3 rules steps step4 step5 step6 step7 step8 dummyPresenter |
	labelPresenter := LabelPresenter new.
	labelPresenter
		text: 'Привіт Pharo';
		color: '#green';
		fontSize: 18;
		bold.
	fieldPresenter := TextInputPresenter new.
	tmp1 := ValidationRules new.
	tmp1 addRulePair: (ValidationRules minLength: 3).
	fieldPresenter := TextInputPresenter new.
	fieldPresenter
		placeholder: 'E-mail';
		backgroundColor: '#b3dcfd';
		isValidationField: true;
		addValidationRules: tmp1;
		addValidationRule: [ :arg1 | arg1 includes: $@ ]
		message: 'Невірний email'.
	comboboxPresenter := ComboBoxPresenter new.
	comboboxPresenter items:
		#( 'Kyiv' 'Lviv' 'Kharkiv' 'Odesa' 'Dnipro' 'Lutsk' ).

	multComboboxPresenter := MultiSelectComboBoxPresenter new.
	multComboboxPresenter items:
		#( 'Apple' 'Banana' 'Kiwi' 'Mango' 'Orange' ).
	multComboboxPresenter whenSelectionChangedDo: [ :selected |
			Transcript
				show: 'Selected: ' , selected printString;
				cr ].

	buttonPresenter := ButtonPresenter new.
	buttonPresenter backgroundColor: '#red'.
	buttonPresenter onClick: [
			NotificationPresenter new
				title: 'Помилка';
				message: 'Неможливо підключитися до серверу';
				type: #error;
				position: #center;
				duration: 3;
				application: self application;
				show ].

	rules := Dictionary newFromPairs: {
			         (#notEmpty -> 'Це поле обов’язкове').
			         (#minLength -> 'Мінімум 3 символи') }.

	tmp2 := FormStyle new.
	tmp2
		labelColor: '#0000ff';
		buttonWidth: 100;
		buttonHeight: 60;
		labelFontSize: 12;
		inputBorderColor: '#gray';
		headerFontSize: 16.
	form := DynamicFormBuilder new.
	form
		style: tmp2;
		header: 'Тестова форма';
		hideHeader;
		textField: #name
		label: 'Ім’я'
		placeholder: 'Введіть ім’я'
		rules: nil;
		textField: #email
		label: 'Електронна пошта'
		placeholder: 'email@example.com'
		rules: nil;
		checkbox: #agree label: 'Погоджуюсь з умовами';
		checkboxGroup: #fruits
		label: 'Фрукти'
		items: #( 'Яблуко' 'Апельсин' 'Ківі' 'Груша' )
		columns: 2
		frame: false;
		radioGroup: #gender
		label: 'Стать'
		items: #( 'Чоловік' 'Жінка' )
		columns: 1
		frame: false;
		dropList: #city label: 'Місто' items: #( 'Київ' 'Львів' 'Харків' );
		comboBox: #country
		label: 'Країна'
		items: #( 'Україна' 'Польща' 'Німеччина' );
		multiComboBox: #skills
		label: 'Навички'
		items: #( 'Smalltalk' 'Python' 'C#' 'SQL' );
		datePicker: #birthdate label: 'Дата народження';
		timePicker: #meeting label: 'Час зустрічі'.


	form onSubmit: [ :values |
			Transcript
				show: 'Отримані дані: ';
				cr.
			Transcript
				show: form collectValues;
				cr ].
	form onBack: [
			Transcript
				show: 'Натиснуто "Скасувати"';
				cr ].


	radioGroup := RadioGroupPresenter new.
	radioGroup
		items:
			#( 'Option 1' 'Option 2' 'Option 3' 'Option 4' 'Option 5'
			   'Option 1' 'Option 2' 'Option 3' 'Option 4' 'Option 5'
			   'Option 6' 'Option 6' 'Option 1' 'Option 2' 'Option 3'
			   'Option 4' 'Option 5' 'Option 1' 'Option 2' 'Option 3'
			   'Option 4' 'Option 5' 'Option 6' 'Option 6' );
		title: 'Choose an option:';
		enableScrolling: true;
		сolumnCount: 1.

	radioGroup whenIndexChangedDo: [ :selectedIndex |
			Transcript
				show: 'Selected index: ' , selectedIndex asString;
				cr ].

	checkboxGroupPresenter := CheckboxGroupPresenter new.
	checkboxGroupPresenter
		title: 'Улюблені фрукти';
		items: #( 'Яблуко' 'Банан' 'Апельсин' 'Ківі' 'Груша' );
		showTitle: true;
		showFrame: true;
		сolumnCount: 2.
	checkboxGroupPresenter whenSelectionChangedDo: [ :indexes |
			Transcript
				show: 'Вибрано індекси: ' , indexes printString;
				cr ].




	step1 := Dictionary new.
	step1
		at: #title put: 'Registration';
		at: #content
		put:
			(SpPresenter new layout: (SpBoxLayout new add: comboboxPresenter)).

	step2 := Dictionary new.
	step2
		at: #title put: 'Personal Details';
		at: #content
		put: (SpPresenter new layout: (SpBoxLayout new add: radioGroup)).

	step3 := Dictionary new.
	step3
		at: #title put: 'Confirmation';
		at: #content
		put:
			(SpPresenter new layout:
					 (SpBoxLayout new add: checkboxGroupPresenter)).

	step4 := Dictionary new.
	step4
		at: #title put: 'Preferences';
		at: #content put: (SpPresenter new layout:
					 (SpBoxLayout new add:
							  (LabelPresenter new text: 'Preferences step'))).

	step5 := Dictionary new.
	step5
		at: #title put: 'Security';
		at: #content put: (SpPresenter new layout:
					 (SpBoxLayout new add:
							  (LabelPresenter new text: 'Preferences step'))).

	step6 := Dictionary new.
	step6
		at: #title put: 'Summary';
		at: #content put: (SpPresenter new layout:
					 (SpBoxLayout new add:
							  (LabelPresenter new text: 'Preferences step'))).

	step7 := Dictionary new.
	step7
		at: #title put: 'Agreement';
		at: #content put: (SpPresenter new layout:
					 (SpBoxLayout new add:
							  (LabelPresenter new text: 'Preferences step'))).

	step8 := Dictionary new.
	step8
		at: #title put: 'Finish';
		at: #content put: (SpPresenter new layout:
					 (SpBoxLayout new add:
							  (LabelPresenter new text: 'Preferences step'))).

	steps := {
		         step1.
		         step2.
		         step3.
		         step4.
		         step5.
		         step6.
		         step7.
		         step8 }.


	wizard := WizardPresenter new.
	wizard steps: steps.
	wizard stepCircleRadius: 20.
	wizard stepCircleTitleColor: Color gray.
	wizard activeColor: '#99e699'.
	wizard whenStepChangedDo: [ :index |
			Transcript
				show: 'Новий крок: ' , index printString;
				cr ].
	wizard whenStepExitDo: [ :index |
			Transcript
				show: 'Вихід із кроку: ' , index printString;
				cr ].
	wizard onFinishDo: [
			Transcript
				show: 'Виконано!';
				cr ].


	searchTable := SearchableTablePresenter new.
	searchTable columns: {
			('Ім’я' -> #name).
			('Email' -> #email).
			('Місто' -> #city).
			('Телефон' -> #phone) }.
	searchTable items: {
			(Dictionary newFromPairs:
				 { #name. 'Олег'. #email. 'oleh@example.com'. #city. 'Львів'.
				 #phone. '123-456' }).
			(Dictionary newFromPairs:
				 { #name. 'Марія'. #email. 'maria@example.com'. #city. 'Київ'.
				 #phone. '234-567' }).
			(Dictionary newFromPairs:
				 { #name. 'Іван'. #email. 'ivan@pharo.org'. #city. 'Одеса'. #phone.
				 '345-678' }).
			(Dictionary newFromPairs:
				 { #name. 'Олена'. #email. 'olena@edu.ua'. #city. 'Харків'.
				 #phone. '456-789' }).
			(Dictionary newFromPairs:
				 { #name. 'Петро'. #email. 'petro@abc.com'. #city. 'Луцьк'. #phone.
				 '567-890' }).
			(Dictionary newFromPairs:
				 { #name. 'Андрій'. #email. 'andriy@xyz.com'. #city. 'Ужгород'.
				 #phone. '678-901' }).
			(Dictionary newFromPairs:
				 { #name. 'Світлана'. #email. 'svitlana@org.ua'. #city. 'Запоріжжя'.
				 #phone. '789-012' }).
			(Dictionary newFromPairs:
				 { #name. 'Ірина'. #email. 'iryna@mail.com'. #city. 'Житомир'.
				 #phone. '890-123' }).
			(Dictionary newFromPairs:
				 { #name. 'Василь'. #email. 'vasyl@net.ua'. #city. 'Дніпро'.
				 #phone. '901-234' }).
			(Dictionary newFromPairs:
				 { #name. 'Тетяна'. #email. 'tania@ukr.net'. #city. 'Черкаси'.
				 #phone. '012-345' }) }.

	date := TimePickerPresenter new.
	date color: Color blue
]
