"
A Metacello baseline for the SpecComponentsLibrary project.

This class defines the set of packages that belong to the SpecComponentsLibrary and provides a way to load them via Metacello. It includes both the core library and example applications that demonstrate how to use the components.

## Packages

- `SpecComponentsLibrary`: The main library with all UI components organized by tag (Dropdown, Groups, Tables, etc).
- `SpecComponentsLibrary-Examples`: Example applications built using the library.

## Usage

To load the library into your Pharo image, execute:

```smalltalk
Metacello new
    baseline: 'SpecComponentsLibrary';
    repository: 'github://yourGithubUsername/SpecComponentsLibrary/src';
    load.
```
"
Class {
	#name : 'BaselineOfSpecComponentsLibrary',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfSpecComponentsLibrary',
	#package : 'BaselineOfSpecComponentsLibrary'
}

{ #category : 'baselines' }
BaselineOfSpecComponentsLibrary >> baseline: spec [

	<baseline>
	spec for: #common do: [
			spec blessing: #baseline.
			spec repository: 'github://Olesia32/pharo-spec-components/src'.

			spec package: 'SpecComponentsLibrary'.
			spec package: 'SpecComponentsLibrary-Examples' ]
]

{ #category : 'accessing' }
BaselineOfSpecComponentsLibrary >> projectClass [ 
	^ MetacelloCypressBaselineProject
]
