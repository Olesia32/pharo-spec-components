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
StyleManager class >> installGeneratedStyleFrom: dict in: app [
    | stonString styleName parsed |
    styleName := 'generatedStyle_', UUID new asString first: 6.
    stonString := self stonFromProperties: dict.
    parsed := SpStyleVariableSTONReader fromString: '
.application [ .' , styleName , ' [ ', stonString, ' ] ]'.
    app styleSheet mergeWith: parsed.
    ^ styleName
]

{ #category : 'as yet unclassified' }
StyleManager class >> parsedDefaultStyleSheet [
    ^ SpStyleVariableSTONReader fromString: self stonStyles
]

{ #category : 'as yet unclassified' }
StyleManager class >> stonFromProperties: dict [
    | container font draw |
    container := OrderedCollection new.
    font := OrderedCollection new.
    draw := OrderedCollection new.

    dict keysAndValuesDo: [ :k :v |
        (k = #borderColor or: [k = #borderWidth]) ifTrue: [
            container add: k -> v.
        ].
        (k = #fontSize or: [k = #bold]) ifTrue: [
            font add: k -> v.
        ].
        (k = #color or: [k = #backgroundColor]) ifTrue: [
            draw add: k -> v.
        ].
    ].

    ^ String streamContents: [ :s |
        (container isEmpty not) ifTrue: [
            s nextPutAll: 'Container { ', (self stonMap: container), ' }. '
        ].
        (font isEmpty not) ifTrue: [
            s nextPutAll: 'Font { ', (self stonMap: font), ' }. '
        ].
        (draw isEmpty not) ifTrue: [
            s nextPutAll: 'Draw { ', (self stonMap: draw), ' }. '
        ].
    ]
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

{ #category : 'as yet unclassified' }
StyleManager class >> stonStyles [

	^ '
.application [
    .errorField [ Container { #borderWidth: 1, #borderColor: #red} ],
    .validField [ Container { #borderWidth: 1, #borderColor: #green} ],
    .customTitle [ Font { #size: 20 } ]
]'
]
