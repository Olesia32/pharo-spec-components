"
Клас для генерації та встановлення стилів Spec-компонентів на основі словникових властивостей.

Перетворює властивості стилю у STON-формат, генерує унікальну назву стилю, і додає його до стилів активного застосунку.

"
Class {
	#name : 'StyleManager',
	#superclass : 'Object',
	#category : 'SpecComponentsLibrary-Style',
	#package : 'SpecComponentsLibrary',
	#tag : 'Style'
}

{ #category : 'adding' }
StyleManager class >> installGeneratedStyleFrom: dict in: app [

	| styleManager styleName stonString parsed |
	styleManager := self new.
	styleName := '' , UUID new asString first: 8.
	stonString := styleManager stonFromProperties: dict.
	parsed := SpStyleVariableSTONReader fromString: '
.application [ .' , styleName , ' [ ' , stonString , ' ] ]'.
	parsed styles do: [ :style | app styleSheet addStyle: style ].
	^ styleName
]

{ #category : 'style' }
StyleManager >> stonFromProperties: dict [

	| container font draw geometry text sections |
	container := OrderedCollection new.
	font := OrderedCollection new.
	draw := OrderedCollection new.
	geometry := OrderedCollection new.
	text := OrderedCollection new.
	sections := OrderedCollection new.

	dict keysAndValuesDo: [ :k :v |
			(k = #borderColor or: [ k = #borderWidth or: [ k = #padding ] ])
				ifTrue: [ container add: k -> v ].

			(k = #fontSize or: [
				 k = #bold or: [ k = #italic or: [ k = #name ] ] ]) ifTrue: [
					| targetKey |
					targetKey := k = #fontSize
						             ifTrue: [ #size ]
						             ifFalse: [ k ].
					font add: targetKey -> v ].

			(k = #color or: [ k = #backgroundColor ]) ifTrue: [
				draw add: k -> v ].

			(#( height width minHeight maxHeight hResizing vResizing )
				 includes: k) ifTrue: [ geometry add: k -> v ].

			(#( alignment textColor readOnly textWrapping ) includes: k)
				ifTrue: [ text add: k -> v ] ].

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

{ #category : 'style' }
StyleManager >> stonMap: assocCollection [

	| strings |
	strings := assocCollection collect: [ :each |
			           | keyStr valStr |
			           keyStr := each key storeString.
			           valStr := each value storeString.

			           "Якщо value — символ у лапках (наприклад: '#''red'''), то прибираємо зовнішні лапки"
			           (valStr beginsWith: '''') & (valStr endsWith: '''')
				           ifTrue: [
				           valStr := valStr copyFrom: 2 to: valStr size - 1 ].

			           keyStr , ': ' , valStr ].

	^ String streamContents: [ :s |
			  strings doWithIndex: [ :str :i |
					  s nextPutAll: str.
					  i < strings size ifTrue: [ s nextPutAll: ', ' ] ] ]
]
