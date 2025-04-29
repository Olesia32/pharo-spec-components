Class {
	#name : 'TestPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'mainPresenter'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'layout' }
TestPresenter >> defaultLayout [

	^ SpBoxLayout new add: mainPresenter
]

{ #category : 'initialization' }
TestPresenter >> initialize [

	super initialize.
	mainPresenter := LabelPresenter new.
	mainPresenter
		text: 'Hello from Spec 2!';
		fontSize: 24;
		bold
]
