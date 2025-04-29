Class {
	#name : 'StyleManager',
	#superclass : 'Object',
	#classInstVars : [
		'Default'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'as yet unclassified' }
StyleManager class >> generatedStyles [
    ^ Smalltalk at: #StyleManager_GeneratedStyles ifAbsentPut: [ OrderedCollection new ]
]

{ #category : 'as yet unclassified' }
StyleManager class >> installGeneratedStyleFrom: dict in: app [

	| stonString styleName parsed sheet |
	styleName := 'generatedStyle_' , UUID new asString first: 6.
	stonString := self stonFromProperties: dict.
	parsed := SpStyleVariableSTONReader fromString: '
.application [ .' , styleName , ' [ ' , stonString , ' ] ]'.
	self generatedStyles add: parsed.

	sheet := self generatedStyles first.
	self generatedStyles allButFirst do: [ :each |
		sheet := sheet mergeWith: each ].

	sheet styles do: [ :style | app styleSheet addStyle: style ].
	^ styleName
]

{ #category : 'initialization' }
StyleManager class >> resetGeneratedStyles [
    Smalltalk at: #StyleManager_GeneratedStyles put: OrderedCollection new
]

{ #category : 'as yet unclassified' }
StyleManager class >> stonFromProperties: dict [

	| container font draw sections |
	container := OrderedCollection new.
	font := OrderedCollection new.
	draw := OrderedCollection new.
	sections := OrderedCollection new.
	dict keysAndValuesDo: [ :k :v |
		(k = #borderColor or: [ k = #borderWidth ]) ifTrue: [
			container add: k -> v ].

		(k = #fontSize or: [ k = #bold ]) ifTrue: [
			| targetKey |
			targetKey := k = #fontSize
				             ifTrue: [ #size ]
				             ifFalse: [ #bold ].
			font add: targetKey -> v ].

		(k = #color or: [ k = #backgroundColor ]) ifTrue: [
			draw add: k -> v ] ].

	container isEmpty ifFalse: [
		sections add: 'Container { ' , (self stonMap: container) , ' }' ].
	font isEmpty ifFalse: [
		sections add: 'Font { ' , (self stonMap: font) , ' }' ].
	draw isEmpty ifFalse: [
		sections add: 'Draw { ' , (self stonMap: draw) , ' }' ].

	^ String streamContents: [ :stream |
		  sections doWithIndex: [ :part :i |
			  stream nextPutAll: part.
			  i < sections size ifTrue: [ stream nextPutAll: ', ' ] ] ]
]

{ #category : 'as yet unclassified' }
StyleManager class >> stonMap: assocCollection [
    | strings stream |
    strings := assocCollection collect: [:each | each key storeString , ': ', each value storeString ].
    stream := String streamContents: [ :s |
        strings doWithIndex: [ :str :i |
            s nextPutAll: str.
            i < strings size ifTrue: [ s nextPutAll: ', ' ] ] ].
    ^ stream

]
