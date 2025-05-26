# 📘 SpecComponentsLibrary Documentation

## 1. Introduction

### Motivation

While Spec 2 offers a powerful MVP-based framework for building Pharo UIs, it lacks several commonly used components (such as time pickers, filtered tables, multiselect dropdowns), and its style system, based on STON configuration, can be verbose and error-prone.

SpecComponentsLibrary was developed to address these limitations by:
- Introducing missing components ready for production use
- Enabling inline styling via code instead of STON blocks
- Providing high-level builders and reusable UI patterns

The components integrate seamlessly with existing Spec applications and remain fully compatible with `SpPresenter`, `SpApplication`, and Spec’s layout system.

### Architecture

The core architectural ideas include:

- `BasePresenter` — shared superclass for all stylable components, with built-in support for visual property setters (`color:`, `fontSize:`, `borderWidth:`, etc.)
- `StyleManager` — utility class that converts a dictionary of visual properties into a valid Spec 2 `SpStyle` and registers it in the application
- `PresenterDecorator` — lightweight wrapper that enables styling on existing Spec 2 presenters (such as `SpButtonPresenter`, `SpLabelPresenter`, etc.) by embedding them into a `BasePresenter`. It is useful when you want to style a core Spec component without subclassing it.
- Component groups organized by purpose: input, forms, collections, flow, and feedback
- Declarative construction: components like `DynamicFormBuilder` allow defining forms using a key-based DSL

All components are implemented as Spec presenters and can be used standalone or embedded in other presenters, windows, or Spec applications.

---
## 2. Styling and Configuration

`SpecComponentsLibrary` allows you to style UI components directly in code, without writing STON blocks or managing global stylesheets. This makes it easier to quickly build and customize interfaces, especially during prototyping or when working in the Playground.
All components that support styling inherit from `BasePresenter` and expose a consistent styling API.

---

### Styling API

You can use the following methods on any stylable component:

* `color:` — text color
* `backgroundColor:` — background color
* `fontSize:`, `fontFamily:`, `bold`, `italic` — font styling
* `width:`, `height:` — size
* `borderColor:`, `borderWidth:` — border styling
* `hResizing:`, `vResizing:` — layout behavior

These methods apply changes immediately and register the generated style in the current application context.

#### Example

```smalltalk
label := LabelPresenter new.
label
  text: 'Email';
  fontSize: 14;
  fontFamily: 'Source Sans Pro';
  color: Color darkGray;
  italic.
```

---

### Using `PresenterDecorator`

If you want to apply styles to a standard Spec 2 component (such as `SpButtonPresenter`), you can wrap it using `PresenterDecorator`.

```smalltalk
styled := PresenterDecorator wrap: SpButtonPresenter.
styled
  backgroundColor: Color green;
  fontSize: 16.
styled mainPresenter label: 'Confirm'.
```

Alternatively, wrap an existing instance:

```smalltalk
raw := SpLabelPresenter new.
raw label: 'Status:'.

styled := PresenterDecorator wrap: raw.
styled
  color: Color gray;
  italic.
```

> ⚠️ Only use this for basic Spec 2 presenters. Do not wrap components that already inherit from `BasePresenter` or belong to this library.

---

### Ready-to-Use Stylable Components

Instead of wrapping presenters manually, most common UI elements already have stylable wrappers included in the library. These classes inherit from `BasePresenter`, are ready to use, and support the full styling API.

| Component | Stylable Wrapper    |
| --------- | ------------------- |
| Label     | `LabelPresenter`    |
| Button    | `ButtonPresenter`   |
| Checkbox  | `CheckboxPresenter` |
| RadioButton  | `RadioButtonPresenter` |
| List      | `ListPresenter`     |

#### Example

```smalltalk
button := ButtonPresenter new.
button
  label: 'Save';
  backgroundColor: Color blue;
  fontSize: 13;
  onClick: [ self saveData ].
```

These components integrate smoothly into Spec layouts and can be used anywhere a `SpPresenter` is expected.

---

## 3. Input Components

This section covers the basic input controls included in the library, designed to simplify user input and enhance interaction.
All input components support styling via the same API shown earlier.

---

### 🔤 `TextInputPresenter`

A stylable input field for entering single-line text, with optional validation logic.
The component supports placeholder text and dynamic styling through `BasePresenter`. Validation rules can be attached to check user input automatically after each keystroke.

#### API

* `text:` — set the current value
* `placeholder:` — hint text displayed when empty
* `addValidationRule: message:` — add a single validation rule (a block and its error message)
* `addValidationRules:` — apply a set of predefined rules from a `ValidationRules` object
* `isValid` — check if the current text passes all validations
* `onValidationChangedDo:` — register a callback for validation status changes

#### Example

```smalltalk
field := TextInputPresenter new.
field
  placeholder: 'Enter your email';
  addValidationRule: [ :txt | txt includes: '@' ] message: 'Invalid email';
  onValidationChangedDo: [ :isValid |
    isValid ifTrue: [ Transcript show: 'Valid input' ]
  ].
```

### ValidationRules

`ValidationRules` is a utility class for defining reusable validation logic for text input fields. It allows bundling multiple rule blocks with error messages and applying them to any `TextInputPresenter` instance.

Each rule is a pair:

* **block** — a predicate that takes the current text and returns a boolean
* **message** — a string to be shown if the rule fails

#### API

* `addRule: aBlock message: aString` — adds a rule with its error message
* `addRulePair: aBlock -> aString` — alternative form
* `all` — returns all added rules
* `applyTo: aPresenter` — applies all rules to a given input field using `addValidationRule:message:`

#### Built-in Rule Factories (Class Side)

```smalltalk
ValidationRules nonEmpty.
ValidationRules isEmail.
ValidationRules minLength: 5.
ValidationRules maxLength: 20.
```

These return rule pairs (`block -> message`) that you can add with `addRulePair:` or include in collections.

#### Example. Custom Rule Set

```smalltalk
rules := ValidationRules new.
rules
  addRule: [ :txt | txt notEmpty ] message: 'Field is required';
  addRule: [ :txt | txt includes: '@' ] message: 'Email must contain @'.

input addValidationRules: rules.
```

---

#### Example. Using Built-in Rules

```smalltalk
rules := ValidationRules new.
rules
  addRulePair: ValidationRules nonEmpty;
  addRulePair: ValidationRules isEmail;
  addRulePair: (ValidationRules minLength: 8).

input addValidationRules: rules.
```

These rules will be automatically triggered when the user types, if the field is marked as a validation field.
