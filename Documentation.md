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

### TextInputPresenter

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

---

### ComboBoxPresenter

A dropdown list with built-in filtering and single selection.
The component combines a text input field for search and a dropdown list of options. Users can filter the list by typing, and select a single item by clicking.

#### API

- `items:` — set the list of values
- `selectedItem` — returns the currently selected item
- `selectIndex:` — programmatically select item by index
- `whenSelectionChangedDo:` — triggered when the selection changes

#### Example

```smalltalk
combo := ComboBoxPresenter new.
combo
  items: #('Apple' 'Banana' 'Cherry');
  whenSelectionChangedDo: [ :selected |
    Transcript show: 'Selected: ', selected asString; cr ].
```

The selected value is displayed in the text input once chosen. Filtering is case-insensitive.

---

### MultiSelectComboBoxPresenter

A dropdown that allows multiple selections using checkboxes.
Instead of returning a single item, this component allows the user to select many values by checking boxes inside the dropdown list.

#### API

- `items:` — set the list of values
- `selectedItems` — returns the set of selected values
- `selectedIndexes:` — programmatically select multiple items
- `whenSelectionChangedDo:` — triggered when selection changes

#### Example

```smalltalk
multi := MultiSelectComboBoxPresenter new.
multi
  items: #('Linux' 'Windows' 'macOS');
  selectedIndexes: #(1 3);
  whenSelectionChangedDo: [ :selected |
    Transcript show: 'Selected OS: ', selected asString; cr ].
```

When the dropdown is closed, the text field shows a comma-separated list of selected items. When opened, it switches to filter mode.

> Internally, this component uses `SpComponentListPresenter` with `CheckboxPresenter` elements to render the list.

---

### CheckboxGroupPresenter

A component that displays a group of checkboxes, allowing users to select multiple values from a list.
You can control layout by specifying the number of columns, adding a frame, and enabling scroll support. The presenter provides methods to access selected values and track changes.

#### API

- `items:` — set the list of options  
- `selectedItems` — returns the list of selected values  
- `selectedIndexes` — returns selected indexes  
- `isCheckedAt:` — checks if an item is selected  
- `clearSelection` — deselects all items  
- `whenSelectionChangedDo:` — event fired when selection changes  
- `showFrame:` — display a border around the group  
- `showTitle:` — show a title label  
- `columnCount:` — set the number of columns  
- `title:` — set title text
- `enableButtonAt:` — enable button at index  
- `disableButtonAt:` — disable button at index 

#### Example

```smalltalk
group := CheckboxGroupPresenter new.
group
  items: #('Email' 'SMS' 'Push Notification');
  columnCount: 2;
  showFrame: true;
  showTitle: true;
  title: 'Preferred Contact Methods';
  whenSelectionChangedDo: [ :indexes |
    Transcript show: 'Selected indexes: ', indexes printString; cr ].
```

---

### RadioGroupPresenter

A component that displays a group of radio buttons for selecting one item from a list.
Only one item may be selected at a time. Selecting a new item deselects the previous one. Useful for gender, payment type, etc.

#### API

- `items:` — set the list of options  
- `itemSelected` — returns the selected value  
- `selectedIndex:` — programmatically select by index  
- `clearSelection` — deselects the current selection  
- `whenSelectionChangedDo:` — triggered when user selects a new option  
- `showFrame:` — add a surrounding border  
- `showTitle:` — show group title  
- `columnCount:` — number of columns  
- `title:` — set the title text
- `enableButtonAt:` — enable button at index  
- `disableButtonAt:` — disable button at index 

#### Example

```smalltalk
group := RadioGroupPresenter new.
group
  items: #('Credit Card' 'PayPal' 'Bank Transfer');
  columnCount: 1;
  showTitle: true;
  title: 'Payment Method';
  whenSelectionChangedDo: [ :choice |
    Transcript show: 'Payment option: ', choice asString; cr ].
```

> Use `clearSelection` if you want to reset the group manually.

---

### TimePickerPresenter

A UI component that allows users to select time using an interactive clock dialog.
It consists of a read-only text field and a button with a clock icon. When clicked, a modal dialog opens with a circular time selector powered by Roassal.

#### API

- `hour` / `hour:` — get or set selected hour (0–23)  
- `minutes` / `minutes:` — get or set selected minutes (0–59)  
- `whenTimeChangedDo:` — callback when time changes (after dialog confirmation)  
- `color:` — primary accent color for clock visuals  
- `additionColor:` — secondary UI color

#### Dialog Behavior

When the dialog is opened via `openDialog`, the current time is passed to the internal `TimePickerDialogPresenter`. The user can:

- Switch between hour and minute selection
- Choose AM/PM mode
- Confirm or cancel the selection

After confirmation, the selected time is shown in the main field in `HH:MM` format, and the `whenTimeChangedDo:` callback is triggered.

> Note: The dialog uses Roassal shapes and event handlers for full interaction.

#### Example

```smalltalk
time := TimePickerPresenter new.
time
  hour: 14;
  minutes: 30;
  whenTimeChangedDo: [
    Transcript show: 'Time changed to: ', time hour printString, ':', time minutes printString; cr
  ].
```

## 4. Data Display

This section covers components used to display collections of items, with built-in support for filtering, pagination, and selection.

---

### SearchableTablePresenter

A data table with live filtering support.
This component extends a standard `SpTablePresenter` by adding a search field and a column selector. Users can filter visible rows based on search input and select which columns to include in the filter.
It consists of:
- a `SpTablePresenter` for rendering data
- a `TextInputPresenter` for search queries
- a `MultiSelectComboBoxPresenter` for selecting searchable columns

#### API

- `items:` — set the full dataset  
- `selectedItem` — get currently selected item from the table  
- `whenSelectedItemChangedDo:` — listen for selection changes  
- `filterField` — access the search input field   
- `displayUsing:` — set a custom display block  
- `hideSearchContainer` / `showSearchContainer` — toggle search UI visibility  
- `table` — access the internal `SpTablePresenter`
  
> Column configuration is done by passing a dictionary of column name → accessor key.

#### Example

```smalltalk
table := SearchableTablePresenter new.
table
  columns: {
    'Name' -> #name.
    'Email' -> #email.
    'Role' -> #role.
  };
  items: {
    { #name -> 'Alice'; #email -> 'alice@example.com'; #role -> 'Admin' } asDictionary.
    { #name -> 'Bob'; #email -> 'bob@example.com'; #role -> 'User' } asDictionary.
    { #name -> 'Charlie'; #email -> 'charlie@example.com'; #role -> 'Moderator' } asDictionary.
  };
  whenSelectedItemChangedDo: [ :selected | Transcript inspect: selected ].
```

As the user types into the search field, the table dynamically updates to show matching rows.

---

### 📄 `PaginatedTablePresenter`

A searchable table with pagination support.
Inherits all features from `SearchableTablePresenter` and adds UI for navigating between pages, jumping to a specific page, and customizing the number of rows per page.
Includes:
- page buttons (next, previous, numbered)
- input field for direct page access
- current/total page counter

#### Additional API

- `itemsPerPage:` — set number of rows per page  
- `currentPage` — get current page number  
- `goToPage:` — jump to a specific page  
- `updatePagination` — refresh paging after filtering or data changes  
- `updateDisplayedItems` — update visible items based on current page  
- `previousPage`, `nextPage` — navigate pages  
- `gotoPageInput`, `gotoPageButton` — access navigation input and button  
- `displayedItems` — get items for current page  

#### Example

```smalltalk
table := PaginatedTablePresenter new.
table
  columns: {
    'Name' -> #name.
    'Email' -> #email.
    'Role' -> #role.
  };
  items: {
    { #name -> 'Alice'; #email -> 'alice@example.com'; #role -> 'Admin' } asDictionary.
    { #name -> 'Bob'; #email -> 'bob@example.com'; #role -> 'User' } asDictionary.
    { #name -> 'Charlie'; #email -> 'charlie@example.com'; #role -> 'Moderator' } asDictionary.
  };
  itemsPerPage: 2.
```

The table shows pagination controls below the grid: current page, total pages, navigation arrows, and a text box for jumping directly to a page.

## 5. Form Construction

`DynamicFormBuilder` is a high-level component that allows you to build data entry forms declaratively.  
Instead of manually creating and laying out each field, you define fields using DSL-style methods such as `textField:label:placeholder:rules:`.
The form automatically generates layout, validation hooks, submit/back buttons, and styling support.

---

### 🧾 `DynamicFormBuilder`

A grid-based dynamic form that supports:

- declarative field creation via methods
- validation rules per field
- custom headers and buttons
- styling via `FormStyle`
- data collection and submission

#### Supported Field Types

| Field Method                   | Description                             |
|-------------------------------|-----------------------------------------|
| `textField:label:placeholder:rules:` | Single-line text input (with validation) |
| `comboBox:label:items:`       | Filterable single-select dropdown       |
| `multiComboBox:label:items:`  | Dropdown with checkbox multiselect      |
| `checkbox:label:`             | Single checkbox                         |
| `checkboxGroup:label:items:columns:frame:` | Multi-option checkbox group       |
| `radioGroup:label:items:columns:frame:`    | Radio group for single selection |
| `dropList:label:items:`       | Standard Spec drop-down list            |
| `datePicker:label:`           | Date selector                           |
| `timePicker:label:`           | Time selector                           |

#### Basic Usage

```smalltalk
form := DynamicFormBuilder new.
form
  header: 'User Registration';
  textField: #name label: 'Name' placeholder: 'Enter full name' rules: nil;
  comboBox: #role label: 'Role' items: #('Admin' 'User' 'Guest');
  onSubmit: [ :values | Transcript inspect: values ].
form open.
```

Each field is associated with a key (e.g., `#name`), which is used to retrieve values on submission.

> Call `collectValues` or use the `onSubmit:` block to access entered data.

#### API

The following methods are available to configure the form and extract values:

- `header:` — set the title text above the form  
- `onSubmit:` — provide a block to call when the user clicks the submit button  
- `onBack:` — (optional) callback for the back/cancel button  
- `style:` — apply a `FormStyle` to control fonts, spacing, colors  
- `values` — return current form values as a dictionary  
- `collectValues` — same as `values`, but always recalculates  
- `validateFields` — return `true` if all validation fields pass

You can also control layout visibility:

- `hideHeader`, `showHeader` — toggle header visibility  
- `hideButtons`, `showButtons` — toggle submit/back buttons  
- `topPresenter:` — insert a custom presenter above the form

#### Styling with `FormStyle`

You can apply visual styling to the form using a `FormStyle` object. It supports customizing:

- font size and color for labels and headers
- field sizes, background colors, borders
- button dimensions

```smalltalk
style := FormStyle new.
style
  labelFontSize: 12;
  inputBackground: Color veryLightGray;
  inputBorderColor: Color gray;
  buttonWidth: 100.

form := DynamicFormBuilder new.
form
  style: style;
  header: 'Contact';
  textField: #email label: 'Email' placeholder: '' rules: nil.
```

## 6. Process Control

This section introduces the `WizardPresenter`, a component for building multi-step interfaces — useful for guided input, registration wizards, or complex workflows.

---

### WizardPresenter

`WizardPresenter` manages a linear sequence of steps. Each step is a regular Spec presenter, and the wizard provides built-in navigation (Next, Back) and a header that shows current progress.

Features
- Step-by-step navigation
- Visual step tracker (with optional labels)
- Support for cancel/back actions
- Styled layout and buttons
- Integration with `DynamicFormBuilder` or any custom presenter

#### API

- `steps:` — set an ordered collection of steps (`{#title -> String. #content -> Presenter}`)
- `goToNextStep`, `goToPreviousStep`, `goToStep:` — navigate steps
- `stepPresenterAt:` — access the content presenter of a specific step
- `whenStepChangedDo:` — callback after step is switched
- `onFinishDo:` — callback when the final step is completed
- `visibleStepCount:` — control how many step indicators are shown
- `stepCircleRadius:`, `stepCircleTitleColor:`, `activeColor:` — style customization
- `nextButton`, `backButton` — access navigation buttons for further customization

#### Example

```smalltalk
wizard := WizardPresenter new.

step1 := DynamicFormBuilder new.
step1
  header: 'User Info';
  textField: #name label: 'Full Name' placeholder: '' rules: nil.

step2 := DynamicFormBuilder new.
step2
  header: 'Contact';
  textField: #email label: 'Email' placeholder: 'example@domain.com' rules: nil.

wizard
  addStep: 'Step 1' title: 'User Info' presenter: step1;
  addStep: 'Step 2' title: 'Contact Info' presenter: step2;
  onFinish: [ Transcript show: 'Wizard finished'; cr ].
```

## 7. Notifications

`NotificationPresenter` is a utility class for showing transient in-window messages (toasts).  
It's useful for confirming user actions (e.g. save success, errors, or alerts) without opening modal dialogs.
The notification appears as an overlay in a corner or center of the given window, styled with custom text, colors, and display duration.

---

### NotificationPresenter

You create and configure the presenter via setters, then call `showOn:` to display it over a specific `SpWindowPresenter`.

#### API

- `title:` — header text  
- `message:` — main message body  
- `type:` — predefined type (`#info`, `#success`, `#warning`, `#error`)  
- `duration:` — seconds before the message disappears (default: 3)  
- `position:` — `#topLeft`, `#topRight`, `#bottomLeft`, `#bottomRight`, `#center`  
- `font:` — font used for both title and message  
- `textColor:` — color of text  
- `backgroundColor:` — background fill (overrides type if set)  
- `width:`, `height:` — fixed size of the message box  
- `window:` — the `SpWindowPresenter` to anchor to (required)  
- `show` — render the message

#### Example

```smalltalk
notification := NotificationPresenter new.
notification
  title: 'Saved';
  message: 'Changes have been successfully saved.';
  type: #success;
  position: #topRight;
  window: activeWindow;
  duration: 3;
  show.
```

> The notification disappears automatically after the given duration. No user action is required.
