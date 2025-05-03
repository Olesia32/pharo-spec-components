Class {
	#name : 'TestPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'labelPresenter',
		'buttonPresenter',
		'fieldPresenter',
		'comboboxPresenter',
		'multComboboxPresenter',
		'form'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'layout' }
TestPresenter >> defaultLayout [

	| tmp1 |
	tmp1 := SpBoxLayout newVertical.
	tmp1
		spacing: 5;
		add: form expand: false.
	^ tmp1 yourself
]

{ #category : 'initialization' }
TestPresenter >> initializePresenters [

	| rules style |
	labelPresenter := LabelPresenter new.
	labelPresenter
		text: 'Привіт Pharo';
		color: '#green';
		fontSize: 18;
		bold.
	fieldPresenter := TextInputPresenter new.
	rules := ValidationRules new.
	rules addRulePair: (ValidationRules minLength: 3).

	fieldPresenter := TextInputPresenter new.
	fieldPresenter
		placeholder: 'E-mail';
		backgroundColor: '#b3dcfd';
		addValidationRules: rules;
		addValidationRule: [ :text | text includes: $@ ]
		message: 'Невірний email'.

	buttonPresenter := ButtonPresenter new.
	buttonPresenter
		backgroundColor: '#b3dcfd';
		width: 100;
		hResizing: false;
		height: 60;
		label: 'Вперед'.

	comboboxPresenter := ComboBoxPresenter new.
	comboboxPresenter items:
		#( 'Kyiv' 'Lviv' 'Kharkiv' 'Odesa' 'Dnipro' 'Lutsk' ).

	multComboboxPresenter := MultiSelectComboBoxPresenter new.
	multComboboxPresenter items:
		#( 'Kyiv' 'Lviv' 'Kharkiv' 'Odesa' 'Dnipro' 'Lutsk' ).

	style := FormStyle new.
	style
		labelColor: '#013220';
		buttonWidth: 100;
		buttonHeight: 60;
		inputBorderColor: '#gray';
		headerFontSize: 16.

	form := DynamicFormBuilder new.
	form style: style.
	form fields: {
			(Dictionary newFromPairs:
				 { #type. 'label'. #key. #header. #label. 'Привіт Pharo' }).
			(Dictionary newFromPairs: {
					 #type.
					 'text'.
					 #key.
					 #name.
					 #label.
					 'Ім’я'.
					 #placeholder.
					 'Введіть ім’я'.
					 #validationRules.
					 rules }).
			(Dictionary newFromPairs:
				 { #type. 'checkbox'. #key. #agree. #label. 'Погоджуюсь з умовами' }).
			(Dictionary newFromPairs:
				 { #type. 'radiobutton'. #key. #gender. #label. 'Стать' }).
			(Dictionary newFromPairs: {
					 #type.
					 'dropdown'.
					 #key.
					 #city.
					 #label.
					 'Місто'.
					 #items.
					 #( 'Львів' 'Київ' 'Одеса' ) }) }.
	form header: 'Тестова форма'.
	form onSubmit: [ :values |
    Transcript show: 'Успішно: ', values printString; cr.
].
]
