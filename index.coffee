React = require("react")
dependencies = require("./converters")

# re-exports
converters = dependencies.converters then module.exports.converters = converters
Invalid    = dependencies.Invalid    then module.exports.Invalid    = Invalid
isInvalid  = dependencies.isInvalid  then module.exports.isInvalid  = isInvalid


HandleChange = (thisFromComponent, stateAttribute, inputer=null) => event =>
    # create a copy of state instead of mutating the original
    newValue = event.target.value
    # if there is a converter function, then run the function before it returns to state
    # for example convert "True" into the boolean: true, or convert the string "Jan 12 2017" to dateTime(1,12,2017)
    newValue = inputer(newValue) if inputer
    
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
        otherProps = {}
        for each of Object.keys(props)
            otherProps[each] = props[each]
        
        # extract the needed props
        linkTo      = null         then linkTo    = otherProps.linkTo    if otherProps.linkTo    then delete otherProps.linkTo
        className   = "easy-input" then className = otherProps.className if otherProps.className then delete otherProps.className
        classAdd    = ""           then classAdd  = otherProps.classAdd  if otherProps.classAdd  then delete otherProps.classAdd

        # add additional classes
        className = className + " " + classAdd
        # add error class if there is an "invalid" prop
        className = "easy-input-error " if otherProps.invalid
        
        # 
        # Controlled input
        # 
        if otherProps.this and linkTo
            # get the value from the component's state
            valueFromState = retrieveKeyValueNoExceptions(otherProps.this.state,"."+linkTo)
            
            # add error class if the value is invalid
            className = "easy-input-error "+className if isInvalid valueFromState
            
            # retrieve converters
            converter = {}   then converter = converters[otherProps.type] if otherProps.type in converters
            outputer  = null then outputer  = converter.outputer          if 'outputer'      in converter 
            inputer   = null then inputer   = converter.inputer           if 'inputer'       in converter 
            
            # convert the display value if needed
            valueFromState = outputer(valueFromState) if outputer
            
            # always convert null values to "" (otherwise react will complain)
            valueFromState = "" if valueFromState is null or valueFromState is undefined
            
            # attach default props
            otherProps.value     = valueFromState                                 then otherProps.value     = otherProps.value     if otherProps.value     
            otherProps.onChange  = HandleChange(otherProps.this, linkTo, inputer) then otherProps.onChange  = otherProps.onChange  if otherProps.onChange  
            otherProps.className = className                                      then otherProps.className = otherProps.className if otherProps.className 
            return React.createElement('input', otherProps, null)
        
        # 
        # uncontrolled input
        # 
        
        # add error class if the value is invalid 
        className = "easy-input-error "+className if isInvalid otherProps.value
        
        # attach default props
        otherProps.className = className if not otherProps.className
        return React.createElement('input', otherProps, null)