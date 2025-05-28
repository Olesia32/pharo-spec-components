"
I am a minimal subclass of `AbstractSelectableGroupPresenter` created for testing purposes.  
I override the `buildButton` method to return a dummy label, allowing tests to instantiate  
and evaluate shared logic in the base class without relying on concrete subclasses like  
`RadioGroupPresenter` or `CheckboxGroupPresenter`.

"
Class {
	#name : 'TestSelectableGroupPresenter',
	#superclass : 'AbstractSelectableGroupPresenter',
	#category : 'SpecComponentsLibrary-Tests',
	#package : 'SpecComponentsLibrary-Tests'
}

{ #category : 'building' }
TestSelectableGroupPresenter >> buildButton [

	^ LabelPresenter new text: 'dummy'
]
