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
		'wizard'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'layout' }
TestPresenter >> defaultLayout [

	| tmp1 |
	tmp1 := SpBoxLayout new.
	tmp1 add: multComboboxPresenter expand: false.
	^ tmp1 yourself
]

{ #category : 'initialization' }
TestPresenter >> initializePresenters [

	| tmp1 tmp2 step1 step2 step3|
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
   multComboboxPresenter items: #( 'Apple' 'Banana' 'Kiwi' 'Mango' 'Orange' ).
   multComboboxPresenter whenSelectionChangedDo: [ :selected |
    Transcript show: 'Selected: ', selected printString; cr ].

		
		
		
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
		header: 'Тестова форма';
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
				(Dictionary newFromPairs: { #key. #favoriteFruits. #type. 'checkbox-group'. #title. 'Фрукти'. #label. 'Обрані фрукти'. #items. #( 'Яблуко' 'Груша' 'Ківі' 'Апельсин' ). #columns. 2}).
				(Dictionary newFromPairs:
						 { #type. 'radiogroup'. #key. #gender. #label. 'Стать'. #items. #( 'Чоловік' 'Жінка' 'Інше' ). #columns. 3}).
				(Dictionary newFromPairs: {
							 #type.
							 'dropdown'.
							 #key.
							 #city.
							 #label.
							 'Місто'.
							 #items.
							 #( 'Львів' 'Київ' 'Одеса' ) }) }.
form onSubmit: [ :values |
    Transcript show: 'Отримані дані: '; cr.
    values keysAndValuesDo: [ :k :v |
        Transcript show: k asString , ' -> ' , v printString; cr ].
].
form onBack: [ Transcript show: 'Натиснуто "Скасувати"'; cr ].


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
		showFrame: false;
		сolumnCount: 2.
	checkboxGroupPresenter whenSelectionChangedDo: [ :indexes |
			Transcript
				show: 'Вибрано індекси: ' , indexes printString;
				cr ].
			
step1 := Dictionary new.
step1 at: #title put: 'Registration';
       at: #content put: (SpPresenter new layout: (SpBoxLayout new add: form)).

step2 := Dictionary new.
step2 at: #title put: 'Personal Details';
       at: #content put: (SpPresenter new layout: (SpBoxLayout new add: radioGroup )).

step3 := Dictionary new.
step3 at: #title put: 'Confirmation';
       at: #content put: (SpPresenter new layout: (SpBoxLayout new add: checkboxGroupPresenter )).

wizard := WizardPresenter new.
wizard steps: { step1. step2. step3 }.
wizard stepCircleRadius: 20.
wizard stepCircleTitleColor: Color gray.
wizard activeColor: '#99e699'.
wizard whenStepChangedDo: [ :index | Transcript show: 'Новий крок: ', index printString; cr ].
wizard whenStepExitDo: [ :index | Transcript show: 'Вихід із кроку: ', index printString; cr ].
wizard onFinishDo: [ Transcript show: 'Виконано!'; cr ].

]
