Class {
	#name : 'EventRegistrationForm',
	#superclass : 'SpPresenter',
	#instVars : [
		'form'
	],
	#category : 'SpecComponentsLibrary-Examples-SimpleExamples',
	#package : 'SpecComponentsLibrary-Examples',
	#tag : 'SimpleExamples'
}

{ #category : 'layout' }
EventRegistrationForm >> defaultLayout [

	^ SpBoxLayout new add: form; yourself 
]

{ #category : 'initialization' }
EventRegistrationForm >> initializePresenters [

	| formStyles |
	form := DynamicFormBuilder new.
	formStyles := FormStyle new.
	formStyles
		headerColor: '#013220';
		isHeaderBold: true;
		headerFontSize: 16;
		inputHeight: 30;
		buttonBackground: '#a6b6ad';
		labelFontSize: 11;
		isLabelBold: true;
		buttonWidth: 200;
		buttonHeight: 50.
	form
		header: 'Форма реєстрації на подію';
		style: formStyles;
		textField: #name
		label: 'Ім’я'
		placeholder: 'Ваше повне ім’я'
		rules: (ValidationRules new
				 addRulePair: ValidationRules nonEmpty;
				 addRule: [ :txt | (txt anySatisfy: [ :ch | ch isDigit ]) not ]
				 message: 'Ім’я не повинно містити цифр');
		radioGroup: #gender
		label: 'Стать'
		items: #( 'Чоловік' 'Жінка' 'Інше' )
		columns: 3
		frame: false;
		comboBox: #country
		label: 'Країна'
		items: #( 'Україна' 'Польща' 'Німеччина' 'США' 'Інше' );
		multiComboBox: #interests
		label: 'Інтереси'
		items: #( 'Програмування' 'Дизайн' 'Математика' 'Історія' );
		checkboxGroup: #languages
		label: 'Мови'
		items: #( 'Англійська' 'Українська' 'Німецька' 'Французька' )
		columns: 2
		frame: false;
		checkbox: #notify
		label: 'Сповіщення'
		text: 'Отримувати сповіщення про подію';
		timePicker: #time label: 'Час участі';
		onSubmit: [ :vals | self show: vals]
]

{ #category : 'initialization' }
EventRegistrationForm >> initializeWindow: arg1 [

	arg1 title: 'Реєстрація'
]

{ #category : 'layout' }
EventRegistrationForm >> show: values [

	| name gender country interests languages time notify summaryText |
	name := values at: #name ifAbsent: [ '?' ].
	gender := values at: #gender ifAbsent: [ '?' ].
	country := values at: #country ifAbsent: [ '?' ].
	interests := (values at: #interests ifAbsent: [ #(  ) ]) asArray
		             joinUsing: ', '.
	languages := (values at: #languages ifAbsent: [ #(  ) ]) asArray
		             joinUsing: ', '.
	time := values at: #time ifAbsent: [ Dictionary new ].
	notify := (values at: #notify ifAbsent: [ false ])
		          ifTrue: [ 'так' ]
		          ifFalse: [ 'ні' ].

	summaryText := Text streamContents: [ :s |
			               s
				               nextPutAll: 'Ім’я: ' , name;
				               cr;
				               nextPutAll: 'Стать: ' , gender;
				               cr;
				               nextPutAll: 'Країна: ' , country;
				               cr;
				               nextPutAll: 'Інтереси: ' , interests;
				               cr;
				               nextPutAll: 'Мови: ' , languages;
				               cr;
				               nextPutAll:
					               'Час участі: '
					               , (time at: #hour ifAbsent: [ '?' ]) asString
					               , ':'
					               , (time at: #minutes ifAbsent: [ '?' ]) asString;
				               cr;
				               nextPutAll: 'Сповіщення: ' , notify ].
	NotificationPresenter new
		type: '#success';
		window: self window;
		height: 220;
		message: summaryText;
		textColor: Color black;
		title: 'Отримані дані';
		duration: 5;
		position: 'bottomLeft';
		show
]
