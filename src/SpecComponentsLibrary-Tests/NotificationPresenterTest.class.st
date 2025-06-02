Class {
	#name : 'NotificationPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'presenter',
		'mockWindow'
	],
	#category : 'SpecComponentsLibrary-Tests',
	#package : 'SpecComponentsLibrary-Tests'
}

{ #category : 'accessing' }
NotificationPresenterTest >> classToTest [ 
  ^NotificationPresenter 
]

{ #category : 'running' }
NotificationPresenterTest >> setUp [
	super setUp.

	mockWindow := SpWindowPresenter new.
	mockWindow initialExtent: 400@300.
	mockWindow build.

	presenter := NotificationPresenter new.
	presenter
		window: mockWindow;
		width: 200;
		height: 100;
		duration: 1;
		font: TextStyle defaultFont.
]

{ #category : 'tests' }
NotificationPresenterTest >> testComputePositionForIn [

	| morph origin width height container expected pos |
	morph := Morph new extent: 100 @ 50.
	origin := mockWindow adapter widget bounds origin.
	container := mockWindow adapter widget.
	width := morph width.
	height := morph height.

	{
		(#topRight
		 -> (container width + origin x - width - 3 @ (origin y + 3))).
		(#topLeft -> (origin x + 3 @ (origin y + 3))).
		(#bottomLeft
		 -> (origin x + 3 @ (container height + origin y - height - 3))).
		(#bottomRight -> (container width + origin x - width - 3
		  @ (container height + origin y - height - 3))).
		(#center -> (container width + origin x // 2 - (width // 2)
		  @ (container height + origin y // 2 - (height // 2)))).
		(nil -> (container width + origin x - width - 3 @ (origin y + 3))) "default fallback" }
		do: [ :assoc |
				presenter position: assoc key.
				pos := presenter computePositionFor: morph in: mockWindow.
				expected := assoc value.

				self assert: pos equals: expected ]
]

{ #category : 'tests' }
NotificationPresenterTest >> testResolveColorFromType [

	presenter type: '#info'.
	self
		assert: presenter backgroundColor
		equals: (Color r: 0.40 g: 0.60 b: 0.85).

	presenter type: '#success'.
	self
		assert: presenter backgroundColor
		equals: (Color r: 0.50 g: 0.75 b: 0.50).

	presenter type: '#warning'.
	self
		assert: presenter backgroundColor
		equals: (Color r: 0.95 g: 0.75 b: 0.40).

	presenter type: '#error'.
	self
		assert: presenter backgroundColor
		equals: (Color r: 0.85 g: 0.45 b: 0.45)
]

{ #category : 'tests' }
NotificationPresenterTest >> testShow [

	| initialMorphs finalMorphs addedMorphs |
	initialMorphs := World submorphs.

	presenter
		title: 'Test';
		message: 'Message';
		position: #center;
		type: '#info';
		window: mockWindow;
		show.

	(Delay forSeconds: 0.1) wait.

	finalMorphs := World submorphs.
	addedMorphs := finalMorphs difference: initialMorphs.

	self assert: addedMorphs notEmpty.

	addedMorphs do: [ :m | m delete ]
]
