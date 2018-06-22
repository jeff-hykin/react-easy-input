React           = require("react")
converterModule = require("./converters")
invalidModule   = require('./Invalid')

# re-exports
converters = converterModule.converters ; module.exports.converters = converters
Invalid    = invalidModule.Invalid      ; module.exports.Invalid    = Invalid
isInvalid  = invalidModule.isInvalid    ; module.exports.isInvalid  = isInvalid

# helper function
HandleChange = (thisFromComponent, stateAttribute, incomingFilter=null) => (event) =>
    copyOfState = Object.assign(thisFromComponent.state)
    # create a copy of state instead of mutating the original
    newValue = event.target.value
    # if there is a converter function, then run the function before it returns to state
    # for example convert "True" into the boolean: true, or convert the string "Jan 12 2017" to dateTime(1,12,2017)
    if incomingFilter
        newValue = incomingFilter(newValue)
    
    eval "copyOfState."+stateAttribute+" = newValue"
    # if the Attribute is not nested
    # update the compoenent state once with the new state
    thisFromComponent.setState(copyOfState)

# helper function
retrieveKeyValueNoExceptions = (object, nested_element, fail_value = "") -> 
    output = fail_value
    try
        output = eval("object" + nested_element)
    return output

# actual main-code
module.exports.Input = (props) ->
        # extract values from props
        expectedProps = []
        expectedProps.push("invalidStyle"        ); if props.invalidStyle         then invalidStyle         = props.invalidStyle        else invalidStyle        = null        
        expectedProps.push("linkTo"              ); if props.linkTo               then linkTo               = props.linkTo              else linkTo              = null        
        expectedProps.push("className"           ); if props.className            then className            = props.className           else className           = "easy-input"
        expectedProps.push("classAdd"            ); if props.classAdd             then classAdd             = props.classAdd            else classAdd            = ""          
        expectedProps.push("incomingFilter"      ); if props.incomingFilter       then incomingFilter       = props.incomingFilter      else incomingFilter      = null        
        expectedProps.push("outgoingFilter"      ); if props.outgoingFilter       then outgoingFilter       = props.outgoingFilter      else outgoingFilter     = null        
        # create a mutable version of props
        newProps = {}
        for each in Object.keys(props)
            if not expectedProps.includes(each)
                newProps[each] = props[each]
        
        
        # if input is linked
        if newProps.this and linkTo
            #
            #   Compute value
            #
            # retrieve converters
            if converters[newProps.type] then converter = converters[newProps.type] else converter = {}
            if not outgoingFilter then outgoingFilter = converter.outgoingFilter
            if not incomingFilter then incomingFilter = converter.incomingFilter
            
            # FIXME, wrap the incomingFilter to make sure it always receives non-Invalid() values
            
            # retrieve the actual value from the component's state
            valueFromState = retrieveKeyValueNoExceptions(newProps.this.state,"."+linkTo)
            # convert the value if needed
            console.log 'outgoingFilter is',outgoingFilter
            if outgoingFilter then valueFromState = outgoingFilter(valueFromState)
            # always convert null values to "" (otherwise react will complain)
            if valueFromState is null or valueFromState is undefined then valueFromState = ""
            newProps.value = valueFromState
            
            #
            #   Compute onChange
            #
            if not newProps.onChange
                newProps.onChange  = HandleChange(newProps.this, linkTo, incomingFilter)
        
        #
        # Calculate styling/css class
        #
        # add additional classes
        newProps.className = className + " " + classAdd
        displayInvalid = no
        # if 'invalid' prop was set to something (true/false)
        if typeof newProps.invalid == 'bool'
            # and if 'invalid' is true
            if newProps.invalid is true
                # then display it
                displayInvalid = yes
            # if 'invalid' is false, dont add error class
        # if 'invalid' prop was not set, but the state value is indeed invalid, then displayInvalid
        else if isInvalid newProps.value
            # then display it
            displayInvalid = yes

        if displayInvalid is yes
            # add the error css class
            className = "easy-input-error " + className
            # check if there is an invalid style
            if invalidStyle
                # if there is one then attach it
                newProps.style = invalidStyle

        # return the react input component
        return React.createElement('input', newProps, null)