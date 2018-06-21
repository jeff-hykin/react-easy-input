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
            emailState:""
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
            <div>What's you email?</div>
            <Input this={this} linkTo="emailState" type="email"  />
            <button onClick={this.onSubmit}>Click Me</button>
        </div>
    }
}
export default dummyComponent
```


# How am I supposed to use this?
### Use-case 1: basic controlled input
Import the component `import {Input} from 'react-easy-input'`<br>
Then in the render function put `<Input this={this} linkTo="name"/>` this will bind the input field to this.state.name.<br>
### Use-case 2: input + styling
Import the component`import {Input} from 'react-easy-input'`<br>
Then in the render function put`<Input this={this} linkTo="name" style={{backgroundColor:"blue"}} />` this will bind the input field to this.state.name<br>
### Use-case 3: input + auto validation styling
Import the component `import {Input} from 'react-easy-input'`<br>
Then in the render function put `<Input this={this} linkTo="email" type="email" invalidStyle={{backgroundColor:"red"}}/>`<br>
Because type="email" is one of the easy-input builtin types, it will automatically validate and switch to the invalidStyle whenever the input isn't an email.
### Use-case 4: input + checking if valid (most common use case)
First Import the tools `import {Input, isInvalid} from 'react-easy-input'`<br>
Then in the render function put `<Input this={this} linkTo="name" type="email"/>`<br>
Now in any other function in your component, you can call `isValid(this.state.email)` and it will return true/false based on if the input is valid.
To get the value of the input box do `this.state.email.valueOf()`<br>
<*> See the "# What does example usage look like?" for an example of this
### Use-case 5: input + custom validator + errorMsg
First Import the tools `import {Input, Invalid, isInvalid} from 'react-easy-input'`<br>
Then somewhere in the file, create a function like this
```javascript
function passwordInputer (userInput) {
    // if longer than 10, its considered valid
    if (userInput.length > 10) {
        // return user input if valid
        return userInput
    } else {
        // return new Invalid obj, if value is Invalid
        return new Invalid(userInput, "password needs to be 10 characters or more")
    }
```
The function should 
1. accept userInput as the first argument 
2. return userInput when valid 
3. return new Invalid(userInput) when invalid
Then in the render function put `<Input this={this} linkTo="password" type="password" inputer={passwordInputer}/>`<br>
And if you'd like to display an error message, you can add this to render <br>
`{ isInvalid(this.state.passwordState) && <div>{this.state.passwordState.errorMsg}</div> }`
<br>Here is a full example
```jsx
import React from 'react'
import {Input, Invalid, isInvalid} from 'react-easy-input'


class dummyComponent extends React.Component {
    constructor (props) {
        super(props)
        this.state ={
            emailState:"",
            passwordState:"",
        }
    }
    
    passwordInputter = (userInput) => {
        if (userInput.match(/.*[0-9].*/) // has number
        && userInput.match(/.*[a-z].*/)  // has lowercase letter
        && userInput.match(/.*[A-Z].*/)  // has uppercase letter
        && userInput.length > 10) {      // longer than 10 chars
            return userInput
        }
        // else
        return new Invalid(userInput, "Needs to be >10 charaters include a number, uppercase letter, and lowercase letter")
    }
    
    onSubmit = () => {
        // if both values are valid
        if ( !isInvalid(this.state.emailState && !isInvalid(this.state.passwordState) ) {
            alert('Your input is formatted correctly!')
        // if either are invalid
        } else {
            alert('Your input is NOT formatted correctly!')
        }
    }
    
    render() {
        return <div>
            <h1>Hello World</h1>
            
            {/* Email */}
            <Input 
                this={this} 
                placeholder="Email" 
                linkTo="emailState" 
                type="email"
                />
            { isInvalid(this.state.emailState) && <div>{this.state.emailState.errorMsg}</div> }

            {/* Password */}
            <Input 
                this={this} 
                placeholder="Password" 
                linkTo="passwordState" 
                type="password"
                inputer={this.passwordInputter}
                />
            { isInvalid(this.state.passwordState) && <div>{this.state.passwordState.errorMsg}</div> }
            
            <button onClick={this.onSubmit}>Click Me</button>
        </div>
    }
}
export default dummyComponent
```

### Use-case 6: input + masking + validator
**yet to be documented**<br>





