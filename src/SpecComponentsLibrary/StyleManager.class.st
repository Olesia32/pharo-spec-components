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

		(k = #fontSize or: [
			 k = #bold or: [ k = #italic or: [ k = #name ] ] ]) ifTrue: [
			| targetKey |
			targetKey := k = #fontSize
				             ifTrue: [ #size ]
				             ifFalse: [
					             k = #bold
						             ifTrue: [ #bold ]
						             ifFalse: [
							             k = #italic
								             ifTrue: [ #italic ]
								             ifFalse: [ #name ] ] ].
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
	| strings |
	strings := assocCollection collect: [ :each |
		| keyStr valStr |
		keyStr := each key storeString.
		valStr := each value storeString.
		
		"Якщо value — символ у лапках (наприклад: '#''red'''), то прибираємо зовнішні лапки"
		(valStr beginsWith: '''') & (valStr endsWith: '''') ifTrue: [
			valStr := valStr copyFrom: 2 to: valStr size - 1 ].

		keyStr , ': ' , valStr
	].

	^ String streamContents: [ :s |
		strings doWithIndex: [ :str :i |
			s nextPutAll: str.
			i < strings size ifTrue: [ s nextPutAll: ', ' ] ] ]

]
