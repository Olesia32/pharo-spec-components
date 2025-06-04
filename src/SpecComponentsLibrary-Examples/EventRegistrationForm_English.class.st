"
I am a simple registration form example built using `DynamicFormBuilder`.

I demonstrate how to declaratively construct and style a complex user form with validation, grouping, and post-submission feedback. My layout includes various types of interactive fields and displays a summary of the collected data upon submission.

### Instance Variables

- _form_ (`DynamicFormBuilder`) — the builder used to define, validate, and layout all input fields.

### Public API

- `EventRegistrationForm>>#show:` - builds and displays a notification with formatted submitted values.

## Usage

```smalltalk
EventRegistrationForm new open

"
Class {
	#name : 'EventRegistrationForm_English',
	#superclass : 'SpPresenter',
	#instVars : [
		'form'
	],
	#category : 'SpecComponentsLibrary-Examples-SimpleExamples',
	#package : 'SpecComponentsLibrary-Examples',
	#tag : 'SimpleExamples'
}

{ #category : 'layout' }
EventRegistrationForm_English >> defaultLayout [

	^ SpBoxLayout new add: form; yourself 
]

{ #category : 'initialization' }
EventRegistrationForm_English >> initializePresenters [

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
		header: 'Event Registration Form';
		submitButtonLabel: 'Submit';
		backButtonLabel: 'Cancel';
		style: formStyles;
		textField: #name
		label: 'Name'
		placeholder: 'Your full name'
		rules: (ValidationRules new
				 addRulePair: ValidationRules nonEmpty;
				 addRule: [ :txt | (txt anySatisfy: [ :ch | ch isDigit ]) not ]
				 message: 'Name must not contain digits');
		radioGroup: #gender
		label: 'Gender'
		items: #( 'Male' 'Female' 'Other' )
		columns: 3
		frame: false;
		comboBox: #country
		label: 'Country'
		items: #( 'Ukraine' 'Poland' 'Germany' 'USA' 'Other' );
		multiComboBox: #interests
		label: 'Interests'
		items: #( 'Programming' 'Design' 'Music' 'Gaming' 'Traveling' );
		checkboxGroup: #languages
		label: 'Languages'
		items: #( 'English' 'Ukrainian' 'German' 'French' )
		columns: 2
		frame: false;
		checkbox: #notify
		label: 'Notifications'
		text: 'Receive updates about the event';
		timePicker: #time label: 'Participation Time';
		onSubmit: [ :vals | self show: vals ]
]

{ #category : 'initialization' }
EventRegistrationForm_English >> initializeWindow: arg1 [

	arg1 title: 'Registration'
]

{ #category : 'layout' }
EventRegistrationForm_English >> show: values [

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
		          ifTrue: [ 'yes' ]
		          ifFalse: [ 'no' ].

summaryText := Text streamContents: [ :s |
	s
		nextPutAll: 'Name: ', name;
		cr;
		nextPutAll: 'Gender: ', gender;
		cr;
		nextPutAll: 'Country: ', country;
		cr;
		nextPutAll: 'Interests: ', interests;
		cr;
		nextPutAll: 'Languages: ', languages;
		cr;
		nextPutAll: 'Participation Time: ',
			(time at: #hour ifAbsent: [ '?' ]) asString,
			':',
			(time at: #minutes ifAbsent: [ '?' ]) asString;
		cr;
		nextPutAll: 'Notifications: ', notify
].

NotificationPresenter new
	type: '#success';
	window: self window;
	height: 220;
	message: summaryText;
	textColor: Color black;
	title: 'Submitted Data';
	duration: 5;
	position: 'bottomLeft';
	show.

]
