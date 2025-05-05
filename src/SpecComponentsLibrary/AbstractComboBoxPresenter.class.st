Class {
	#name : 'AbstractComboBoxPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'textInput',
		'toggleButton',
		'list',
		'allItems',
		'isOpen'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'testing' }
AbstractComboBoxPresenter class >> isAbstract [ 
^ true
]

{ #category : 'initialization' }
AbstractComboBoxPresenter >> connectPresenters [ 
 self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
AbstractComboBoxPresenter >> createListPresenter [ 
    ^ SpPresenter new "Підклас може перевизначити на ListPresenter чи SpComponentListPresenter"
]

{ #category : 'layout' }
AbstractComboBoxPresenter >> defaultLayout [ 
	^ SpBoxLayout newTopToBottom
		add: (SpBoxLayout newLeftToRight
			add: textInput mainPresenter;
			add: toggleButton withConstraints: [ :c | c width: 25; expand: false ]);
		add: list withConstraints: [ :c | c height: 150; expand: false ];
		yourself
]

{ #category : 'private' }
AbstractComboBoxPresenter >> filterList [ 
 self subclassResponsibility 
]

{ #category : 'initialization' }
AbstractComboBoxPresenter >> initialize [ 
	super initialize.
	allItems := #().
	announcer := Announcer new.
]

{ #category : 'initialization' }
AbstractComboBoxPresenter >> initializePresenters [ 
	textInput := TextInputPresenter new.
	isOpen := false.
	toggleButton := ButtonPresenter new.
	list := self createListPresenter.
	toggleButton onClick: [ self toggleList ]; backgroundColor: '#white'.
	self updateToggleButtonIcon.
	self connectPresenters.
]

{ #category : 'api' }
AbstractComboBoxPresenter >> items: aCollection [ 
	allItems := aCollection reject: [ :each | each isNil ].
	self filterList
]

{ #category : 'as yet unclassified' }
AbstractComboBoxPresenter >> toggleList [ 
	isOpen := isOpen not.
	list mainPresenter visibleIf: isOpen.
	self updateToggleButtonIcon.
]

{ #category : 'as yet unclassified' }
AbstractComboBoxPresenter >> updateToggleButtonIcon [ 
	toggleButton mainPresenter icon: (self iconNamed: (isOpen ifTrue: [#arrowUp] ifFalse: [#arrowDown]))
]

{ #category : 'enumerating' }
AbstractComboBoxPresenter >> whenSelectionChangedDo: aBlock [ 
    announcer
        when: ComboBoxItemSelected
        do: [ :event | aBlock value: event item ]
        for: self.
]
