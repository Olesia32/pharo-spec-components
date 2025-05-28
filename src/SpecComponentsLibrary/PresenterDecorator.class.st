"
I am a utility class that wraps a standard Spec 2 presenter into a `BasePresenter` to enable styling.

My main responsibility is to decorate core Spec 2 UI components (like `SpButtonPresenter`, `SpLabelPresenter`, etc.) by embedding them into a `BasePresenter`, thus allowing users to apply visual properties like colors, fonts, sizes, and borders without subclassing.

This decorator works **only with standard Spec 2 presenters** that support styling through Spec’s STON-compatible mechanism. Components that already inherit from `BasePresenter`, or composite/custom presenters with embedded logic, should not be wrapped using me.

I accept either a presenter instance or a class (from which I create an instance). I return a `BasePresenter` with the original component assigned to mainPresenter.

### Public API  
- `PresenterDecorator class>>#wrap:` — wraps a given instance or class of Spec presenter and returns a stylable `BasePresenter`  

### Usage

```smalltalk
""Wrap a class""
styledButton := PresenterDecorator wrap: SpButtonPresenter.
styledButton
  backgroundColor: Color green;
  fontSize: 14.
styledButton mainPresenter label: 'OK'.

""Wrap an instance""
label := SpLabelPresenter new.
label label: 'Name:'.

styledLabel := PresenterDecorator wrap: label.
styledLabel
  color: Color gray;
  italic.

"
Class {
	#name : 'PresenterDecorator',
	#superclass : 'Object',
	#category : 'SpecComponentsLibrary-Style',
	#package : 'SpecComponentsLibrary',
	#tag : 'Style'
}

{ #category : 'decoration' }
PresenterDecorator class >> wrap: aPresenterOrClass [
"Wrap a Spec 2 presenter class or instance into a BasePresenter to enable styling."
	| instance |
	instance := aPresenterOrClass isBehavior
		            ifTrue: [ aPresenterOrClass new ]
		            ifFalse: [ aPresenterOrClass ].

	^ BasePresenter new
		  mainPresenter: instance;
		  yourself
]
