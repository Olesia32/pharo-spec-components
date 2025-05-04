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
		'radioGroup'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'layout' }
TestPresenter >> defaultLayout [
   
	| tmp1 |
	tmp1 := SpBoxLayout new.
	tmp1
		add: radioGroup.
	^ tmp1 yourself
]

{ #category : 'initialization' }
TestPresenter >> initializePresenters [

	| tmp1 tmp2 |
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
		addValidationRules: tmp1;
		addValidationRule: [ :arg1 | arg1 includes: $@ ]
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
	tmp2 := FormStyle new.
	tmp2
		labelColor: '#013220';
		buttonWidth: 100;
		buttonHeight: 60;
		inputBorderColor: '#gray';
		headerFontSize: 16.
	form := DynamicFormBuilder new.
	form
		style: tmp2;
		fields: {
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
							 tmp1 }).
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
							 #( 'Львів' 'Київ' 'Одеса' ) }) };
		header: 'Тестова форма';
		onSubmit: [ :arg2 |
				Transcript
					show: 'Успішно: ' , arg2 printString;
					cr ].
				
			
		
	radioGroup := RadioGroupPresenter new.
   radioGroup items: #( 'Option 1' 'Option 2' 'Option 3' 'Option 4' 'Option 5' 'Option 6' );
   title: 'Choose an option:';
   setColumnCount: 3. 

radioGroup whenIndexChangedDo: [ :selectedIndex |
    Transcript show: 'Selected index: ', selectedIndex asString; cr.
].
]
