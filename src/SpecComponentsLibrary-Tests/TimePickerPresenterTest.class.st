Class {
	#name : 'TimePickerPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'picker'
	],
	#category : 'SpecComponentsLibrary-Tests',
	#package : 'SpecComponentsLibrary-Tests'
}

{ #category : 'running' }
TimePickerPresenterTest >> setUp [ 
	super setUp.
	picker := TimePickerPresenter new.
	picker initializePresenters.
]

{ #category : 'tests' }
TimePickerPresenterTest >> testAdditionColor [

	picker additionColor: Color blue.
	self
		assert: (picker instVarNamed: 'additionalColor')
		equals: Color blue
]

{ #category : 'tests' }
TimePickerPresenterTest >> testColor [
	picker color: Color red.

	self assert: (picker instVarNamed: 'color') equals: Color red.
]

{ #category : 'tests' }
TimePickerPresenterTest >> testHour [ 
	picker hour: 15.
	self assert: picker hour equals: 15.

	picker hour: 0.
	self assert: picker hour equals: 0.
]

{ #category : 'tests' }
TimePickerPresenterTest >> testMinutes [
	picker minutes: 45.
	self assert: picker minutes equals: 45.

	picker minutes: 0.
	self assert: picker minutes equals: 0.
]

{ #category : 'tests' }
TimePickerPresenterTest >> testOpenDialog [
   
| called |
	called := false.

	picker whenTimeChangedDo: [ called := true ].

	"імітація відповіді з діалогу — якби onOk: був викликаний"
	picker perform: #hour: with: 8.
	picker perform: #minutes: with: 30.
	(picker instVarNamed: 'timeFieldPresenter') text: '8:30'.
	(picker instVarNamed: 'onTimeChanged') value.

	self assert: picker hour equals: 8.
	self assert: picker minutes equals: 30.
	self assert: (picker instVarNamed: 'timeFieldPresenter') text equals: '8:30'.
	self assert: called.
]

{ #category : 'tests' }
TimePickerPresenterTest >> testTimeFieldIsNotEditable [ 
	self deny: (picker instVarNamed: 'timeFieldPresenter') mainPresenter isEditable.
]

{ #category : 'tests' }
TimePickerPresenterTest >> testWhenTimeChangedDo [

	| triggered |
	triggered := false.

	picker whenTimeChangedDo: [ triggered := true ].
	(picker instVarNamed: 'onTimeChanged') value.
	self assert: triggered
]
