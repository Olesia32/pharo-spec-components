"
I am a manually composed form-based presenter for event registration.

I demonstrate how to construct a full-featured UI by assembling various presenters from `SpecComponentsLibrary`. I validate input, collect user responses, and display them in the `Transcript` upon submission.

### Instance Variables

- _nameField_ (`TextInputPresenter`) — group of radio buttons for gender selection.
- _genderGroup_ (`RadioGroupPresenter`) — group of radio buttons for gender selection.
- _interestsBox_ (`MultiSelectComboBoxPresenter`) — multi-select list of interests.
- _countryBox_ (`ComboBoxPresenter`) — dropdown list of available countries.
- _languagesBox_ (`CheckboxGroupPresenter`) — group of checkboxes for spoken languages.
- _notificationCheck_ (`CheckboxPresenter`) — checkbox for enabling event notifications.
- _preferredTime_ (`TimePickerPresenter`) — time selection component.
- _submitButton_ (`ButtonPresenter`) — button that triggers form validation and prints results.
- _headerLabel_ (`LabelPresenter`) — stylized header label for the form.

### Public API

- `SimplePresenter>>#submit` - validates the form and prints all submitted values to the `Transcript` if valid.

### Usage

```smalltalk
SimplePresenter new open

"
Class {
	#name : 'SimplePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'nameField',
		'genderGroup',
		'interestsBox',
		'countryBox',
		'languagesBox',
		'notificationCheck',
		'preferredTime',
		'submitButton',
		'headerLabel'
	],
	#category : 'SpecComponentsLibrary-Examples-SimpleExamples',
	#package : 'SpecComponentsLibrary-Examples',
	#tag : 'SimpleExamples'
}

{ #category : 'layout' }
SimplePresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		  spacing: 10;
		  add: headerLabel;
		  add: nameField;
		  add: genderGroup;
		  add: countryBox;
		  add: interestsBox;
		  add: languagesBox;
		  add: preferredTime;
		  add: notificationCheck;
		  add: submitButton
]

{ #category : 'initialization' }
SimplePresenter >> initializePresenters [

	headerLabel := LabelPresenter new.
	headerLabel
		text: 'Реєстрація на подію';
		color: '#013220';
		bold;
		fontSize: 16.

	nameField := TextInputPresenter new.
	nameField
		placeholder: 'Ваше повне ім’я';
		isValidationField: true;
		height: 50;
		backgroundColor: '#d2dad5';
		addValidationRules: (ValidationRules new
				 addRulePair: ValidationRules nonEmpty;
				 addRule: [ :txt | (txt anySatisfy: [ :ch | ch isDigit ]) not ]
				 message: 'Ім’я не повинно містити цифр';
				 yourself).

	genderGroup := RadioGroupPresenter new.
	genderGroup
		items: #( 'Чоловік' 'Жінка' 'Інше' );
		сolumnCount: 3;
		showFrame: true.

	interestsBox := MultiSelectComboBoxPresenter new.
	interestsBox items:
		#( 'Програмування' 'Дизайн' 'Математика' 'Історія' ).

	countryBox := ComboBoxPresenter new.
	countryBox items: #( 'Україна' 'Польща' 'Німеччина' 'США' 'Інше' ).

	languagesBox := CheckboxGroupPresenter new.
	languagesBox
		items: #( 'Англійська' 'Українська' 'Німецька' 'Французька' );
		сolumnCount: 2;
		title: 'Мови';
		showFrame: false;
		showTitle: true.

	notificationCheck := CheckboxPresenter new.
	notificationCheck mainPresenter label:
		'Отримувати сповіщення про події'.

	preferredTime := TimePickerPresenter new.

	submitButton := ButtonPresenter new.
	submitButton
		label: 'Зареєструватися';
		backgroundColor: '#a6b6ad';
		onClick: [ self submit ]
]

{ #category : 'initialization' }
SimplePresenter >> initializeWindow: arg1 [

	arg1
		title: 'Реєстрація'
]

{ #category : 'submit' }
SimplePresenter >> submit [

	| time |
	nameField validate.
	nameField isValid ifFalse: [
			Transcript
				crShow: 'Форма невалідна — перевірте ім’я.';
				flush.
			^ self ].
	time := preferredTime value.
	Transcript
		cr;
		show: '--- Дані з форми ---';
		cr;
		show: 'Ім’я: ';
		show: nameField text;
		cr;
		show: 'Стать: ';
		show: genderGroup itemSelected asString;
		cr;
		show: 'Країна: ';
		show: countryBox selectedItem asString;
		cr;
		show: 'Інтереси: ';
		show: ((interestsBox selectedItems asOrderedCollection) joinUsing: ', ');
		cr;
		show: 'Мови: ';
		show: ((languagesBox selectedItems asOrderedCollection) joinUsing: ', ');
		cr;
		show: 'Час участі: ';
		show: (time hour) asString , ':' , (time minutes ) asString;
		cr;
		show: 'Сповіщення: ';
		show: (notificationCheck mainPresenter state
				 ifTrue: [ 'так' ]
				 ifFalse: [ 'ні' ]);
		cr;
		flush
]
