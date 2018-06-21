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
        # extract values from props
        expectedProps = []
        expectedProps.push("linkTo"     ); if props.linkTo     then linkTo      = props.linkTo     else linkTo     = null        
        expectedProps.push("className"  ); if props.className  then className   = props.className  else className  = "easy-input"
        expectedProps.push("classAdd"   ); if props.classAdd   then classAdd    = props.classAdd   else classAdd   = ""          
        expectedProps.push("inputer"    ); if props.inputer    then inputer     = props.inputer    else inputer    = null        
        expectedProps.push("outputer"   ); if props.outputer   then outputer    = props.outputer   else outputer   = null        
        # create a mutable version of props
        otherProps = {}
        for each in Object.keys(props)
            if not expectedProps.includes(each)
                otherProps[each] = props[each]

        # 
        # Controlled input
        # 
        if otherProps.this and linkTo
            
            
            #
            #   Compute value
            #
            # retrieve converters
            if converters[otherProps.type] then converter = converters[otherProps.type] else converter = {}
            if outputer is null then outputer   = converter.outputer
            if inputer  is null then inputer    = converter.inputer
            
            # retrieve the actual value from the component's state
            valueFromState = retrieveKeyValueNoExceptions(otherProps.this.state,"."+linkTo)
            # convert the value if needed
            if outputer then valueFromState = outputer(valueFromState)
            # always convert null values to "" (otherwise react will complain)
            if valueFromState is null or valueFromState is undefined then valueFromState = ""
            
            #
            # Calculate error styling/css class
            #
            # add additional classes
            className = className + " " + classAdd
            # if invalid was set to something (true/false)
            if typeof otherProps.invalid == 'bool'
                # if invalid is true
                if otherProps.invalid is true
                    # add error class if there is an "invalid" prop
                    className = "easy-input-error " + className
                # if invalid is false, dont add error class
            # if invalid was not set, but the state value is invalid, then add the error class
            else if isInvalid valueFromState
                className = "easy-input-error "+className
            # FIXME, check for a errorStyle
            
            #
            #   Attach values to otherProps
            #
            otherProps.className = className
            if not otherProps.value     then otherProps.value     = valueFromState
            if not otherProps.onChange  then otherProps.onChange  = HandleChange(otherProps.this, linkTo, inputer)
            
            return React.createElement('input', otherProps, null)
        # 
        # uncontrolled input
        # 
        else
            #
            # Calculate error styling/css class
            #
            # add additional classes
            className = className + " " + classAdd
            # if invalid was set to something (true/false)
            if typeof otherProps.invalid == 'bool'
                # if invalid is true
                if otherProps.invalid is true
                    # add error class if there is an "invalid" prop
                    className = "easy-input-error " + className
                # if invalid is false, dont add error class
            # if invalid was not set, but the value is invalid, then add the error class
            else if isInvalid otherProps.value
                className = "easy-input-error "+classNam
            
            #
            #   Attach values to otherProps
            #
            otherProps.className = className if not otherProps.className
            return React.createElement('input', otherProps, null)