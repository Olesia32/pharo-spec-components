Class {
	#name : 'StyleManager',
	#superclass : 'Object',
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'as yet unclassified' }
StyleManager class >> applyStyleNamed: styleName to: app [ 
	| sheet |
	sheet := self namedStyles at: styleName ifAbsent: [ ^self error: 'Style not found' ].
	sheet styles do: [ :style | app styleSheet addStyle: style ].
]

{ #category : 'as yet unclassified' }
StyleManager class >> generatedStyles [
    ^ Smalltalk at: #StyleManager_GeneratedStyles ifAbsentPut: [ OrderedCollection new ]
]

{ #category : 'as yet unclassified' }
StyleManager class >> installGeneratedStyleFrom: dict in: app [ 
	| styleName stonString parsed sheet |
	styleName := 'generatedStyle_' , UUID new asString first: 6.
	stonString := self stonFromProperties: dict.
	parsed := SpStyleVariableSTONReader fromString: '
.application [ .' , styleName , ' [ ' , stonString , ' ] ]'.
	sheet := parsed.
	sheet styles do: [ :style | app styleSheet addStyle: style ].
	^ styleName
]

{ #category : 'as yet unclassified' }
StyleManager class >> namedStyles [ 
	^ Smalltalk at: #StyleManager_NamedStyles ifAbsentPut: [ Dictionary new ]
]

{ #category : 'as yet unclassified' }
StyleManager class >> registerNamedStyle: styleDict as: styleName in: app [

	| stonString parsed |
	stonString := self stonFromProperties: styleDict.
	parsed := SpStyleVariableSTONReader fromString: '
.application [ .' , styleName , ' [ ' , stonString , ' ] ]'.
	app styleSheet addStyle: parsed styles first
]

{ #category : 'as yet unclassified' }
StyleManager class >> removeStyleNamed: styleName [ 
	self namedStyles removeKey: styleName ifAbsent: [ "Do nothing" ]
]

{ #category : 'initialization' }
StyleManager class >> resetGeneratedStyles [
    Smalltalk at: #StyleManager_GeneratedStyles put: OrderedCollection new
]

{ #category : 'as yet unclassified' }
StyleManager class >> saveStyle: dict as: styleName [ 
	| stonString parsed |
	stonString := self stonFromProperties: dict.
	parsed := SpStyleVariableSTONReader fromString: '
.application [ .' , styleName , ' [ ' , stonString , ' ] ]'.
	self namedStyles at: styleName put: parsed.
]

{ #category : 'as yet unclassified' }
StyleManager class >> stonFromProperties: dict [ 

    | container font draw geometry text sections |
    container := OrderedCollection new.
    font := OrderedCollection new.
    draw := OrderedCollection new.
    geometry := OrderedCollection new.
    text := OrderedCollection new.
    sections := OrderedCollection new.

    dict keysAndValuesDo: [ :k :v |
        (k = #borderColor or: [ k = #borderWidth or: [ k = #padding ] ]) ifTrue: [
            container add: k -> v ].

        (k = #fontSize or: [ k = #bold or: [ k = #italic or: [ k = #name ] ] ]) ifTrue: [
            | targetKey |
            targetKey := k = #fontSize
                         ifTrue: [ #size ]
                         ifFalse: [ k ].
            font add: targetKey -> v ].

        (k = #color or: [ k = #backgroundColor ]) ifTrue: [
            draw add: k -> v ].

        ( #(height width minHeight maxHeight hResizing vResizing) includes: k ) ifTrue: [
            geometry add: k -> v ].

        ( #(alignment textColor readOnly textWrapping) includes: k ) ifTrue: [
            text add: k -> v ].
    ].

    container isEmpty ifFalse: [
        sections add: 'Container { ' , (self stonMap: container) , ' }' ].
    font isEmpty ifFalse: [
        sections add: 'Font { ' , (self stonMap: font) , ' }' ].
    draw isEmpty ifFalse: [
        sections add: 'Draw { ' , (self stonMap: draw) , ' }' ].
    geometry isEmpty ifFalse: [
        sections add: 'Geometry { ' , (self stonMap: geometry) , ' }' ].
    text isEmpty ifFalse: [
        sections add: 'Text { ' , (self stonMap: text) , ' }' ].

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
