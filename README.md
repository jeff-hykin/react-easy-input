# React-Easy-Input
A react input component that has simple validation and masking. <br>
This readme will likely be updated within a week.


# What does example usage look like?
Usage within a react component:<br>
dummyComponent.jsx:<br>
```jsx
import React from 'react'
import {Input, isInvalid} from 'react-easy-input'


class dummyComponent extends React.Component {
    constructor (props) {
        super(props)
        this.state ={
            name:""
        }
    }
    
    onSubmit = () => {
        if (isInvalid(this.state.emailState)) {
            console.log("Yo, "+this.state.emailState+" is not a valid email")
        }
    }
    
    render() {
        return <div>
            <h1>Hello World</h1>
            <div>What's you name?</div>
            <Input this={this} linkTo="emailState" type="email" />
            <button onClick={this.onSubmit} />
        </div>
    }
}
export default dummyComponent
```


# How am I supposed to use this?
### Use-case 1: a controlled input
First Import the tools `import {Input} from 'react-easy-input'`<br>
Then in the render function put `<Input this={this} linkTo="name"/>` this will bind the input field to this.state.name.<br>
### Use-case 2: a controlled input + styling
First Import the tools`import {Input} from 'react-easy-input'`<br>
Then in the render function put`<Input this={this} linkTo="name"/>` this will bind the input field to this.state.name.<br>
Then in any css file in your project put<br>
```css
.easy-input {
    background-color: purple;
}
```
### Use-case 3: controlled input + validation styling
First Import the tools `import {Input, isInvalid} from 'react-easy-input'`<br>
Then in the render function put `<Input this={this} linkTo="name" type="email"/>`<br>
Then in any css file in your project put<br>
```css
/* the style of the input box when something */
.easy-input-error {
    background-color: red;
}
```
### Use-case 4: controlled input + checking if valid
First Import the tools `import {Input, isInvalid} from 'react-easy-input'`<br>
Then in the render function put `<Input this={this} linkTo="name" type="email"/>`<br>

### Use-case 5: controlled input + custom validator
**yet to be documented**<br>





