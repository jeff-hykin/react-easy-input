# React-Easy-Input
A react input component that has simple validation and masking. <br>
This readme will likely be updated within a week.


### Use-case 1: a controlled input
Import with `import {Input} from 'react-easy-input'`
React-render usage, `<Input this={this} linkTo="name"/>` this will bind the input field to this.state.name.
### Use-case 2: a controlled input + styling
Import with `import {Input} from 'react-easy-input'`
React-render usage, `<Input this={this} linkTo="name"/>` this will bind the input field to this.state.name.
Then in any css file in your project put
```
.easy-input {
    background-color: purple;
}
```
### Use-case 3: input + validation
* yet-to-be-documented *



Example usage within a react component:
```
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
        if (isInvalid(this.state.name)) {
            console.log(`Yo, the name is invalid`)
        }
    }
    
    render() {
        return <div>
            <h1>Hello World</h1>
            <div>What's you name?</div>
            <Input this={this} linkTo="name"/>
            <button onClick={this.onSubmit} />
        </div>
    }
}
export default dummyComponent
```




