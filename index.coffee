React = require("react")
dependencies = require("./converters")

# re-exports
converters = dependencies.converters; module.exports.converters = converters
Invalid    = dependencies.Invalid   ; module.exports.Invalid    = Invalid
isInvalid  = dependencies.isInvalid ; module.exports.isInvalid  = isInvalid


HandleChange = (thisFromComponent, stateAttribute, inputer=null) => (event) =>
    copyOfState = Object.assign(thisFromComponent.state)
    # create a copy of state instead of mutating the original
    newValue = event.target.value
    # if there is a converter function, then run the function before it returns to state
    # for example convert "True" into the boolean: true, or convert the string "Jan 12 2017" to dateTime(1,12,2017)
    if inputer
        newValue = inputer(newValue)
    
    eval "copyOfState."+stateAttribute+" = newValue"
    # if the Attribute is not nested
    # update the compoenent state once with the new state
    thisFromComponent.setState(copyOfState)

retrieveKeyValueNoExceptions = (object, nested_element, fail_value = "") -> 
    output = fail_value
    try
        output = eval("object" + nested_element)
    return output

module.exports.Input = (props) ->
        # create a mutable copy of props
        if props.linkTo    then linkTo     = props.linkTo    else linkTo    = null
        if props.className then className  = props.className else className = "easy-input"
        if props.classAdd  then classAdd   = props.classAdd  else classAdd  = ""
        expectedProps = ["linkTo","className", "classAdd"]
        otherProps = {}
        for each in Object.keys(props)
            if not expectedProps.includes(each)
                otherProps[each] = props[each]
        
        # add additional classes
        className = className + " " + classAdd
        # add error class if there is an "invalid" prop
        className = "easy-input-error " + className if otherProps.invalid
        
        
        # 
        # Controlled input
        # 
        if otherProps.this and linkTo
            # get the value from the component's state
            valueFromState = retrieveKeyValueNoExceptions(otherProps.this.state,"."+linkTo)
            
            # add error class if the value is invalid
            if isInvalid valueFromState and not (typeof otherProps.invalid == 'bool' and otherProps.invalid == false)
                className = "easy-input-error "+className
            # add the classname
            otherProps.className = className
            
            # retrieve converters
            if converters[otherProps.type] then converter = converters[otherProps.type] else converter = {}
            if otherProps.outputer then outputer = otherProps.outputer else outputer  = converter.outputer
            if otherProps.intputer then intputer = otherProps.intputer else intputer  = converter.intputer
            
            # convert the display value if needed
            if outputer then valueFromState = outputer(valueFromState)
            
            # always convert null values to "" (otherwise react will complain)
            if valueFromState is null or valueFromState is undefined then valueFromState = ""
            
            # attach default props
            if otherProps.value     then otherProps.value     = otherProps.value    else otherProps.value     = valueFromState
            if otherProps.onChange  then otherProps.onChange  = otherProps.onChange else otherProps.onChange  = HandleChange(otherProps.this, linkTo, inputer)
            
            return React.createElement('input', otherProps, null)
        
        # 
        # uncontrolled input
        # 
        
        # add error class if the value is invalid 
        className = "easy-input-error "+className if isInvalid otherProps.value
        
        # attach default props
        otherProps.className = className if not otherProps.className
        return React.createElement('input', otherProps, null)