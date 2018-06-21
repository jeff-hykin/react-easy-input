# A class for indicating a value is invalid
# it is used for input validation
class Invalid 
    constructor: (value, errorMsg) ->
        valueCopy = value
        # unwrap any invalid values
        while (valueCopy instanceof Invalid) 
            valueCopy = valueCopy.value
        this[Symbol.toPrimitive] = (hint) ->
            return this.value
        this.value    = valueCopy
        this.errorMsg = errorMsg
    
    valueOf:  () => this.value
    toString: () => this.value
    
isInvalid = (value) ->
    if typeof value == "object" and value instanceof Invalid
        return true
    else
        return false

module.exports.Invalid = Invalid
module.exports.isInvalid = isInvalid
module.exports.converters = {
    bool: {
        outputer: (shouldBeBool) => 
            if shouldBeBool == true
                return "True"
            else if (shouldBeBool == false) 
                return "False"
            # If provided value is not boolean, then return the value itself
            return shouldBeBool
        ,
        inputer: (userInput) => 
            userInputLowerCased = userInput.toLowerCase()
            if userInputLowerCased == "true"
                return true
            else if userInputLowerCased == "false"
                return false
            # if not true or false, then its invalid
            return new Invalid(userInput, "Please enter either true or false")
    },
    digits: {
        inputer: (userInput) =>
            if  userInput.match /\d+/
                # convert string to number
                return userInput-0
            # if its not a number
            else
                return new Invalid(userInput, "Please only input numerical digits (0-9)")
    },
    "datetime-local": {
        outputer : (shouldBeDateTime) => 
            if shouldBeDateTime and shouldBeDateTime instanceof Date
                return shouldBeDateTime.toISOString().substring(0, 16)
            else
                return shouldBeDateTime
        ,
        inputer: (userInput) => 
            return new Date(userInput+'Z')
    }
    email : {
        inputer: (userInput) =>
            if userInput.match /.+@.+\..+/
                return userInput
            else
                return new Invalid(userInput, "Please enter a valid email")
    }
}