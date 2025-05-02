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
	tmp1 add: comboboxPresenter.
	^ tmp1 yourself
]

{ #category : 'initialization' }
TestPresenter >> initializePresenters [

	comboboxPresenter := ComboBoxPresenter new.
	comboboxPresenter items:
		#( 'Kyiv' 'Lviv' 'Kharkiv' 'Odesa' 'Dnipro' 'Lutsk' ).
	comboboxPresenter whenSelectedItemChangedDo: [ :item | Transcript show: 'Обрано: ', item asString; cr ].

]
