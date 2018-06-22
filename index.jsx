var React = require("react")
var dependencies = require("./converters")

var converters = dependencies.converters
var Invalid = dependencies.Invalid
var isInvalid = dependencies.isInvalid
module.exports.converters = converters
module.exports.Invalid = Invalid
module.exports.isInvalid = isInvalid


HandleChange = (thisFromComponent, stateAttribute, incomingFilter=null) => event => {
    // create a copy of state instead of mutating the original
    var newValue = event.target.value
    // if there is a converter function, then run the function before it returns to state
    // for example convert "True" into the boolean: true, or convert the string "Jan 12 2017" to dateTime(1,12,2017)
    if (incomingFilter) {
        newValue = incomingFilter(newValue)
    }
    eval("copyOfState."+stateAttribute+" = newValue")
    // if the Attribute is not nested
    // update the compoenent state once with the new state
    thisFromComponent.setState(copyOfState)
};

function retrieveKeyValueNoExceptions (object, nested_element, fail_value = "") {
    var output = fail_value
    try { output = eval("object" + nested_element) } catch (e) { }
    return output
}


module.exports.Input = function(props) 
    {
        var otherProps = {}
        for (var each of Object.keys(props)) {
            otherProps[each] = props[each]
        }
        // extract the needed props
        var linkTo    = otherProps.linkTo    ? otherProps.linkTo    : null        ; delete otherProps.linkTo
        var className = otherProps.className ? otherProps.className : "easy-input"; delete otherProps.className
        var classAdd  = otherProps.classAdd  ? otherProps.classAdd  : ""          ; delete otherProps.classAdd
        
        
        
        // add additional classes
        className = className + " " + classAdd
        // add error class if there is an "invalid" prop
        className = otherProps.invalid ? "easy-input-error "+ className : className
        
        // 
        // Controlled input
        // 
        if (otherProps.this && linkTo) {
            // get the value from the component's state
            var valueFromState = retrieveKeyValueNoExceptions(otherProps.this.state,"."+linkTo)
            if (isInvalid(valueFromState)) {
                // add error class if the value is invalid
                className = "easy-input-error "+className
            }
            // retrieve converters
            var converter              = otherProps.type          in converters ? converters[otherProps.type]      : {}
            var outgoingFilter = 'outgoingFilter' in converter  ? converter.outgoingFilter : null
            var incomingFilter  = 'incomingFilter'  in converter  ? converter.incomingFilter  : null
            // convert the display value if needed
            if (outgoingFilter) {
                valueFromState = outgoingFilter(valueFromState)
            }
            
            // always convert null values to "" (otherwise react will complain)
            if (valueFromState == null) {
                valueFromState = ""
            }
            // attach default props
            otherProps.value     = otherProps.value? otherProps.value         : valueFromState
            otherProps.onChange  = otherProps.onChange? otherProps.onChange   : HandleChange(otherProps.this, linkTo, incomingFilter),  
            otherProps.className = otherProps.className? otherProps.className : className
            return React.createElement('input', otherProps, null)
        }
        
        // 
        // uncontrolled input
        // 
        
        // if there is a value, and if it is invalid
        if (isInvalid(otherProps.value)) {
            // add error class if the value is invalid
            className = "easy-input-error "+className
            
        }
        // attach default props
        otherProps.className = otherProps.className? otherProps.className : className
        return React.createElement('input', otherProps, null)
    }