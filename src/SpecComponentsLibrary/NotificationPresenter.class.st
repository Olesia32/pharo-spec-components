Class {
	#name : 'NotificationPresenter',
	#superclass : 'Object',
	#instVars : [
		'title',
		'message',
		'type',
		'duration',
		'application',
		'position',
		'font',
		'backgroundColor',
		'textColor',
		'width',
		'height'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'accessing' }
NotificationPresenter >> application [

	^ application
]

{ #category : 'accessing' }
NotificationPresenter >> application: anObject [

	application := anObject
]

{ #category : 'accessing' }
NotificationPresenter >> backgroundColor [

	^ backgroundColor
]

{ #category : 'accessing' }
NotificationPresenter >> backgroundColor: anObject [

	backgroundColor := anObject
]

{ #category : 'as yet unclassified' }
NotificationPresenter >> computePositionFor: morph in: window [

	| margin container containerBounds x y |
	margin := 3.
	containerBounds := window adapter widget bounds origin.
	container := window adapter widget.

	^ position
		  caseOf: {
				  (#topRight -> [
					   x := container width + containerBounds x - morph width
					        - margin.
					   y := containerBounds y + margin.
					   x @ y ]).

				  (#topLeft -> [
					   x := containerBounds x + margin.
					   y := containerBounds y + margin.
					   x @ y ]).

				  (#bottomLeft -> [
					   x := containerBounds x + margin.
					   y := container height + containerBounds y - morph height
					        - margin.
					   x @ y ]).

				  (#bottomRight -> [
					   x := container width + containerBounds x - morph width
					        - margin.
					   y := container height + containerBounds y - morph height
					        - margin.
					   x @ y ]).

				  (#center -> [
					   x := container width + containerBounds x // 2
					        - (morph width // 2).
					   y := container height + containerBounds y // 2
					        - (morph height // 2).
					   x @ y ]) }
		  otherwise: [ "За замовчуванням — як #bottomRight"
				  x := container width + containerBounds x - morph width - margin.
				  y := container height + containerBounds y - morph height
				       - margin.
				  x @ y ]
]

{ #category : 'accessing' }
NotificationPresenter >> duration [

	^ duration
]

{ #category : 'accessing' }
NotificationPresenter >> duration: anObject [

	duration := anObject
]

{ #category : 'accessing' }
NotificationPresenter >> font [

	^ font
]

{ #category : 'accessing' }
NotificationPresenter >> font: anObject [

	font := anObject
]

{ #category : 'accessing' }
NotificationPresenter >> height [

	^ height
]

{ #category : 'accessing' }
NotificationPresenter >> height: anObject [

	height := anObject
]

{ #category : 'initialization' }
NotificationPresenter >> initialize [
   super initialize.
	title := 'Сповіщення'.
	message := ''.
	type := #info.
	duration := 3.
	position := #bottomRight.
	font := TextStyle defaultFont.
	backgroundColor := Color gray.
	textColor := Color white.
	width := 300.
	height := 80
]

{ #category : 'accessing' }
NotificationPresenter >> message [

	^ message
]

{ #category : 'accessing' }
NotificationPresenter >> message: anObject [

	message := anObject
]

{ #category : 'accessing' }
NotificationPresenter >> position [

	^ position
]

{ #category : 'accessing' }
NotificationPresenter >> position: anObject [

	position := anObject
]

{ #category : 'as yet unclassified' }
NotificationPresenter >> resolveColorFromType [
    | colors |
    colors := Dictionary new.
    colors
        at: #info put: (Color r: 0.40 g: 0.60 b: 0.85);
        at: #success put: (Color r: 0.50 g: 0.75 b: 0.50);
        at: #warning put: (Color r: 0.95 g: 0.75 b: 0.40);
        at: #error put: (Color r: 0.85 g: 0.45 b: 0.45).
    ^ colors at: type ifAbsent: [ (Color r: 0.75 g: 0.75 b: 0.75)  ]

]

{ #category : 'accessing' }
NotificationPresenter >> show [

	| container titleMorph messageMorph window delay offset |
	titleMorph := StringMorph contents: title.
	titleMorph
		font: font;
		color: textColor.

	messageMorph := StringMorph contents: message.
	messageMorph
		font: font;
		color: textColor.

	container := Morph new.
	container
		color: self resolveColorFromType;
		borderWidth: 0;
		cornerStyle: #rounded;
		layoutPolicy: ProportionalLayout new;
		extent: width @ height.

	container addMorph: titleMorph.
	titleMorph position: 10 @ 5.

	container addMorph: messageMorph.
	messageMorph position: 10 @ 35.

	window := application topWindow.
	World addMorph: container.

	offset := self computePositionFor: container in: window.
	container position: offset.

	delay := Delay forSeconds: duration.
	[
		delay wait.
		container ifNotNil: [ container delete ] ] fork
]

{ #category : 'accessing' }
NotificationPresenter >> textColor [

	^ textColor
]

{ #category : 'accessing' }
NotificationPresenter >> textColor: anObject [

	textColor := anObject
]

{ #category : 'accessing' }
NotificationPresenter >> title [

	^ title
]

{ #category : 'accessing' }
NotificationPresenter >> title: anObject [

	title := anObject
]

{ #category : 'accessing' }
NotificationPresenter >> type [

	^ type
]

{ #category : 'accessing' }
NotificationPresenter >> type: anObject [

	type := anObject
]

{ #category : 'accessing' }
NotificationPresenter >> width [

	^ width
]

{ #category : 'accessing' }
NotificationPresenter >> width: anObject [

	width := anObject
]
