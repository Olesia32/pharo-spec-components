Class {
	#name : 'TestPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'labelPresenter',
		'buttonPresenter',
		'fieldPresenter'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'layout' }
TestPresenter >> defaultLayout [

	| tmp2 |
	tmp2 := SpBoxLayout newVertical.
	tmp2
		add: labelPresenter expand: false;
		add: buttonPresenter expand: false;
		add: fieldPresenter expand: false.
	^ tmp2 yourself
]

{ #category : 'initialization' }
TestPresenter >> initializePresenters [

	labelPresenter := LabelPresenter new.
	labelPresenter
		text: 'Hello from Spec 2!';
		italic;
		fontSize: 24;
		color: '#4f7942';
		bold.
	buttonPresenter := ButtonPresenter new.
	buttonPresenter
		label: 'Go';
		italic;
		fontSize: 16;
		fontColor: '#4f7942';
		width: 150;
		height: 60;
		backgroundColor: '#f0f8ff';
		bold.

	fieldPresenter := TextInputPresenter new.
	fieldPresenter
		placeholder: 'Email';
		addValidationRule: [ :text | text notEmpty ]
		message: 'Поле не може бути порожнім';
		addValidationRule: [ :text | text includes: $@ ]
		message: 'Має містити символ "@"';
		width: 100;
		height: 50;
		backgroundColor: '#white'
]
