var dependencies = require("./converters")

var converters = dependencies.converters
var Invalid = dependencies.Invalid
var isInvalid = dependencies.isInvalid
module.exports.converters = converters
module.exports.Invalid = Invalid
module.exports.isInvalid = isInvalid


HandleChange = (thisFromComponent, stateAttribute, userInputToStateConverter=null) => event => {
    // create a copy of state instead of mutating the original
    var newValue = event.target.value
    // if there is a converter function, then run the function before it returns to state
    // for example convert "True" into the boolean: true, or convert the string "Jan 12 2017" to dateTime(1,12,2017)
    if (userInputToStateConverter) {
        newValue = userInputToStateConverter(newValue)
    }
    eval("copyOfState."+stateAttribute+" = newValue")
    // if the Attribute is not nested 
    // update the compoenent state once with the new state
    thisFromComponent.setState(copyOfState)
};


module.exports.Input = function({linkTo, className="input-box", classAdd="", ...otherProps}) 
    {
        // add additional classes
        className = className + " " + classAdd
        // add error class if there is an "invalid" prop
        className = otherProps.invalid?"input-err "+className : className
        
        // 
        // Controlled input
        // 
        if (otherProps.this && linkTo) {
            // get the value from the component's state
            var valueFromState = retrieveKeyValueNoExceptions(otherProps.this.state,"."+linkTo)
            if (isInvalid(valueFromState)) {
                // add error class if the value is invalid
                className = "input-error "+className
            }
            // retrieve converters
            var stateToUserConverter      = retrieveKeyValueNoExceptions(converters,"['"+otherProps.type+"'].stateToUserConverter")
            var userInputToStateConverter = retrieveKeyValueNoExceptions(converters,"['"+otherProps.type+"'].userInputToStateConverter")
            // convert the display value if needed
            if (stateToUserConverter) {
                valueFromState = stateToUserConverter(valueFromState)
            }
            // always convert null values to "" (otherwise react will complain)
            if (valueFromState == null) {
                valueFromState = ""
            }
            return <input value={valueFromState} onChange={HandleChange(otherProps.this, linkTo, userInputToStateConverter)} className={className}  {...otherProps} />
        }
        
        // 
        // uncontrolled input
        // 
        
        // if there is a value, and if it is invalid
        if (isInvalid(otherProps.value)) {
            // add error class if the value is invalid
            className = "input-error "+className
            
        }
        
        return <input className={className} {...otherProps} />
    }