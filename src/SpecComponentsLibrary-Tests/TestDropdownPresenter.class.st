"
I am a minimal subclass of `AbstractDropdownPresenter` used exclusively for unit testing.

I exist to provide concrete implementations of abstract methods like `#connectPresenters`, `#createMorphList`, and `#filterList`, allowing tests for the shared functionality of dropdown presenters to execute without errors.

I do not implement any UI logic or filtering behavior beyond what is necessary to satisfy base class expectations.

"
Class {
	#name : 'TestDropdownPresenter',
	#superclass : 'AbstractDropdownPresenter',
	#category : 'SpecComponentsLibrary-Tests',
	#package : 'SpecComponentsLibrary-Tests'
}

{ #category : 'initialization' }
TestDropdownPresenter >> connectPresenters [ 
	"Нічого не робимо для тесту"
]

{ #category : 'private' }
TestDropdownPresenter >> createMorphList [

	^ PluggableListMorph new
]

{ #category : 'private' }
TestDropdownPresenter >> filterList [ 
	"Фейкова фільтрація: копіює allItems у filteredItems"
	self filteredItems: self allItems.
]

{ #category : 'initialization' }
TestDropdownPresenter >> initializePresenters [

	super initializePresenters.
	textInput build.
	toggleButton build.
]
