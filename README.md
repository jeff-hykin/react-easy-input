# React-Easy-Input
A react input component that has simple validation and masking. <br>
This readme will likely be updated within a week.


# Usage
Basic usage, `<Input this={this} linkTo="name"/>` is enough to bind the input field to this.state.name.


Example usage within a react component:
```
import React from 'react'
import Input, {isInvalid} from 'react-easy-input'


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
            <button onClick={this.onSubmit} >
        </div>
    }
}
export default dummyComponent
```




