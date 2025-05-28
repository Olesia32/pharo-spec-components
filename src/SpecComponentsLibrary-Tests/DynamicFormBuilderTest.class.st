Class {
	#name : 'DynamicFormBuilderTest',
	#superclass : 'TestCase',
	#instVars : [
		'form'
	],
	#category : 'SpecComponentsLibrary-Tests',
	#package : 'SpecComponentsLibrary-Tests'
}

{ #category : 'accessing' }
DynamicFormBuilderTest >> classToTest [ 
  ^ DynamicFormBuilder 
]

{ #category : 'running' }
DynamicFormBuilderTest >> setUp [ 
	super setUp.
	form := DynamicFormBuilder new.
	form initializePresenters.
]

{ #category : 'tests' }
DynamicFormBuilderTest >> testBackButtonLabel [
	form backButtonLabel: 'Cancel'.
	self assert: (form instVarNamed: 'backButton') label equals: 'Cancel'
]

{ #category : 'tests' }
DynamicFormBuilderTest >> testCheckboxGroupLabelItemsColumnsFrame [

	| presenter |
	form
		checkboxGroup: #prefs
		label: 'Prefs'
		items: #( 'Dark' 'Light' )
		columns: 2
		frame: false.
	presenter := form presenterAt: #prefs.

	self assert: (presenter isKindOf: CheckboxGroupPresenter).
	self
		assert: (presenter instVarNamed: 'items') asArray
		equals: #( 'Dark' 'Light' ).
	self assert: (presenter instVarNamed: 'columnCount') equals: 2.
	self deny: (presenter instVarNamed: 'showFrame')
]

{ #category : 'tests' }
DynamicFormBuilderTest >> testCheckboxLabelText [

	| presenter |
	form checkbox: #agree label: 'Agreement' text: 'I agree'.
	presenter := form presenterAt: #agree.

	self assert: (presenter isKindOf: CheckboxPresenter).
	self assert: presenter mainPresenter label equals: 'I agree'
]

{ #category : 'accessing' }
DynamicFormBuilderTest >> testCollectValues [

	| values expected|
	form
		textField: #name
		label: 'Name'
		placeholder: ''
		rules: nil.
	form checkbox: #terms label: 'Terms' text: 'Accept?'.
	form
		dropList: #country
		label: 'Country'
		items: #( 'Ukraine' 'Poland' ).
	form timePicker: #alarm label: 'Alarm'.
	(form presenterAt: #alarm)
		hour: 8;
		minutes: 30.
	(form presenterAt: #name) text: 'Ivan'.
	(form presenterAt: #terms) mainPresenter state: true.
	(form presenterAt: #country) selectItem: 'Poland'.
	values := form collectValues.
	self assert: (values at: #name) equals: 'Ivan'.
	self assert: (values at: #terms).
	self assert: (values at: #country) equals: 'Poland'.
	expected := Dictionary new.
	expected at: #hour put: 8.
	expected at: #minutes put: 30.
	self assert: (values at: #alarm) equals: expected 
]

{ #category : 'tests' }
DynamicFormBuilderTest >> testComboBoxLabelItems [

	| presenter |
	form
		comboBox: #category
		label: 'Category'
		items: #( 'Books' 'Music' ).
	presenter := form presenterAt: #category.

	self assert: (presenter isKindOf: ComboBoxPresenter).
	self assert: presenter allItems equals: #( 'Books' 'Music' )
]

{ #category : 'tests' }
DynamicFormBuilderTest >> testDatePickerLabel [

	| presenter |
	form datePicker: #birth label: 'Birthday'.
	presenter := form presenterAt: #birth.

	self assert: (presenter isKindOf: SpDatePresenter)
]

{ #category : 'tests' }
DynamicFormBuilderTest >> testDropListLabelItems [

	| presenter |
	form
		dropList: #country
		label: 'Country'
		items: #( 'Ukraine' 'Poland' ).
	presenter := form presenterAt: #country.

	self assert: (presenter isKindOf: SpDropListPresenter).
	self assert: presenter items equals: #( 'Ukraine' 'Poland' )
]

{ #category : 'tests' }
DynamicFormBuilderTest >> testHeader [
	form header: 'Registration'.
	self assert: (form instVarNamed: 'headerLabel') text equals: 'Registration'.
]

{ #category : 'tests' }
DynamicFormBuilderTest >> testHideButtons [

	| layout submit back |
	form hideButtons.
	layout := form defaultLayout.
	submit := form instVarNamed: 'submitButton'.
	back := form instVarNamed: 'backButton'.

	self deny: (layout allPresenters anySatisfy: [ :m | m == submit ]).
	self deny: (layout allPresenters anySatisfy: [ :m | m == back ])
]

{ #category : 'tests' }
DynamicFormBuilderTest >> testHideHeader [

	| layout header |
	form header: 'Hidden Header'.
	form hideHeader.
	layout := form defaultLayout.
	header := form instVarNamed: 'headerLabel'.

	self deny: (layout allPresenters anySatisfy: [ :m | m == header ])
]

{ #category : 'tests' }
DynamicFormBuilderTest >> testMultiComboBoxLabelItems [

	| presenter |
	form multiComboBox: #tags label: 'Tags' items: #( 'A' 'B' 'C' ).
	presenter := form presenterAt: #tags.

	self assert: (presenter isKindOf: MultiSelectComboBoxPresenter).
	self assert: presenter allItems equals: #( 'A' 'B' 'C' )
]

{ #category : 'tests' }
DynamicFormBuilderTest >> testOnBack [

	| called |
	called := false.

	form onBack: [ called := true ].
	form connectPresenters.

	(form instVarNamed: 'backButton') mainPresenter click.

	self assert: called
]

{ #category : 'tests' }
DynamicFormBuilderTest >> testOnSubmit [

	| called |
	called := false.

	form textField: #x label: 'X' placeholder: '' rules: nil.
	form onSubmit: [ :_ | called := true ].
	form connectPresenters.

	(form instVarNamed: 'submitButton') mainPresenter click.
	self assert: called.
]

{ #category : 'tests' }
DynamicFormBuilderTest >> testPresenterAt [
	| inputPresenter result |
	form textField: #email label: 'Email' placeholder: 'Type your email' rules: nil.
	inputPresenter := form presenterAt: #email.
	self assert: (inputPresenter isKindOf: TextInputPresenter).
	self assert: inputPresenter equals: (form instVarNamed: 'fieldPresenters') first value.
	
	result := form presenterAt: #nonExistentKey.
	self assert: result isNil.
]

{ #category : 'tests' }
DynamicFormBuilderTest >> testRadioGroupLabelItemsColumnsFrame [

	| presenter |
	form
		radioGroup: #gender
		label: 'Gender'
		items: #( 'M' 'F' )
		columns: 1
		frame: true.
	presenter := form presenterAt: #gender.

	self assert: (presenter isKindOf: RadioGroupPresenter).
	self assert: (presenter instVarNamed: 'items') asArray equals: #( 'M' 'F' ).
	self assert: (presenter instVarNamed: 'columnCount') equals: 1.
	self assert: (presenter instVarNamed: 'showFrame')
]

{ #category : 'tests' }
DynamicFormBuilderTest >> testShowButtons [

	| layout submit back |
	form showButtons.
	layout := form defaultLayout.
	submit := form instVarNamed: 'submitButton'.
	back := form instVarNamed: 'backButton'.

	self assert:
		(layout allPresenters anySatisfy: [ :m | m == submit ]).
	self assert:
		(layout allPresenters anySatisfy: [ :m | m == back ])
]

{ #category : 'tests' }
DynamicFormBuilderTest >> testShowHeader [

	| layout header |
	form header: 'Test Header'.
	form showHeader.
	layout := form defaultLayout.
	header := form instVarNamed: 'headerLabel'.

	self assert:
		(layout allPresenters anySatisfy: [ :m | m == header ])
]

{ #category : 'tests' }
DynamicFormBuilderTest >> testSubmitButtonLabel [
	form submitButtonLabel: 'Send'.
	self assert: (form instVarNamed: 'submitButton') label equals: 'Send'.
]

{ #category : 'tests' }
DynamicFormBuilderTest >> testTextFieldLabelPlaceholderRules [

	| presenter rule|
	rule := ValidationRules new 
	addRulePair: ValidationRules nonEmpty.
	form
		textField: #name
		label: 'Name'
		placeholder: 'Enter'
		rules: rule.
	presenter := form presenterAt: #name.

	self assert: presenter notNil.
	self assert: (presenter isKindOf: TextInputPresenter).
	presenter text: ''.
	presenter validate.
	self deny: presenter isValid.

	presenter text: 'Alice'.
	presenter validate.
	self assert: presenter isValid
]

{ #category : 'tests' }
DynamicFormBuilderTest >> testTimePickerLabel [

	| presenter |
	form timePicker: #alarm label: 'Alarm'.
	presenter := form presenterAt: #alarm.

	self assert: (presenter isKindOf: TimePickerPresenter)
]

{ #category : 'tests' }
DynamicFormBuilderTest >> testTopPresenter [

	| top layout |
	top := form instVarNamed: 'customTopPresenter'.
	layout := form defaultLayout.
	self deny: (layout allPresenters anySatisfy: [ :m | m == top ]).

	form topPresenter: (LabelPresenter new text: 'Above form').
	top := form instVarNamed: 'customTopPresenter'.
	layout := form defaultLayout.
	self assert: (layout allPresenters anySatisfy: [ :m | m == top ])
]

{ #category : 'tests' }
DynamicFormBuilderTest >> testValidateFields [

	form
		textField: #email
		label: 'Email'
		placeholder: ''
		rules: (ValidationRules new addRulePair: ValidationRules nonEmpty).
	form
		comboBox: #category
		label: 'Category'
		items: #( 'Choose' 'News' 'Sport' ).

	(form presenterAt: #category) selectedIndex: 0. "Invalid"
	(form presenterAt: #email) text: ''.

	self deny: form validateFields.

	(form presenterAt: #email) text: 'test'.
	(form presenterAt: #category) selectedIndex: 2.

	self assert: form validateFields
]
