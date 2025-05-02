Class {
	#name : 'TestPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'labelPresenter',
		'buttonPresenter',
		'fieldPresenter',
		'comboboxPresenter'
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
		add: labelPresenter expand: false;
		add: fieldPresenter expand: false;
		add: buttonPresenter expand: false;
		add: comboboxPresenter withConstraints: [ :c |
				c
					width: 100;
					expand: false ].
	^ tmp1 yourself
]

{ #category : 'initialization' }
TestPresenter >> initializePresenters [

	labelPresenter := LabelPresenter new.
	labelPresenter
		text: 'Привіт Pharo';
		color: '#green';
		fontSize: 18;
		bold.
	fieldPresenter := TextInputPresenter new.
	fieldPresenter
		placeholder: 'E-mail';
		backgroundColor: '#b3dcfd';
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
]
