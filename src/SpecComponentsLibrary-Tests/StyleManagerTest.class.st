Class {
	#name : 'StyleManagerTest',
	#superclass : 'TestCase',
	#instVars : [
		'styleManager'
	],
	#category : 'SpecComponentsLibrary-Tests',
	#package : 'SpecComponentsLibrary-Tests'
}

{ #category : 'running' }
StyleManagerTest >> setUp [
	super setUp.
	styleManager := StyleManager new.
]

{ #category : 'tests' }
StyleManagerTest >> testInstallGeneratedStyleFromIn [

	| dict styleName app |
	dict := Dictionary new.
	dict at: #fontSize put: 14.
	dict at: #color put: '#red'.

	app := MockAppWithStyle new.
	styleName := StyleManager installGeneratedStyleFrom: dict in: app.
	self assert: styleName size equals: 8.
	self assert: (app styleSheet styles anySatisfy: [ :s |
			 s name includesSubstring: styleName ])
]

{ #category : 'tests' }
StyleManagerTest >> testStonFromProperties [

	| result dict |
	dict := Dictionary new.
	dict at: #fontSize put: 12.
	dict at: #bold put: true.
	dict at: #italic put: false.
	dict at: #name put: 'Arial'.
	dict at: #color put: '#red'.
	dict at: #backgroundColor put: '#white'.
	dict at: #width put: 300.
	dict at: #height put: 100.
	dict at: #borderColor put: '#gray'.
	dict at: #borderWidth put: 2.
	dict at: #padding put: 5.

	result := styleManager stonFromProperties: dict.
	self assert: (result includesSubstring:
			 'Font { #name: Arial, #italic: false, #bold: true, #size: 12 }').
	self assert: (result includesSubstring:
			 'Draw { #backgroundColor: #white, #color: #red }').
	self assert:
		(result includesSubstring: 'Geometry { #width: 300, #height: 100 }').
	self assert: (result includesSubstring:
			 'Container { #borderColor: #gray, #borderWidth: 2, #padding: 5 }')
]

{ #category : 'tests' }
StyleManagerTest >> testStonMap [

	| dict result |
	dict := Dictionary new.
	dict at: #fontSize put: 14.
	dict at: #bold put: true.
	dict at: #name put: 'Arial'.

	result := styleManager stonMap: dict associations.
	self assert: result equals: '#name: Arial, #bold: true, #fontSize: 14'
]
