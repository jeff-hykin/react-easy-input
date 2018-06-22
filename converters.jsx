// A class for indicating a value is invalid
// it is used for input validation
class Invalid {
    constructor(value, errorMsg) {
        var valueCopy = value
        // unwrap any invalid values
        while (valueCopy instanceof Invalid) {
            valueCopy = valueCopy.value
        }
        this.value = valueCopy
        this.errorMsg = errorMsg
    }
    valueOf(){
        return this.value
    }
    toString(){
        return this.value
    }
}
var isInvalid = function (value) {
    if (typeof value == "object" && value instanceof Invalid) {
        return true
    }
    return false
}
module.exports.Invalid = Invalid
module.exports.isInvalid = isInvalid
module.exports.converters = {
    bool: {
        outgoingFilter: (shouldBeBool) => {
            if (shouldBeBool === true) {
                return "True"
            } else if (shouldBeBool === false) {
                return "False"
            }
            // If provided value is not boolean, then return the value itself
            return shouldBeBool
        },
        incomingFilter: (userInput) => {
            var userInputLowerCased = userInput.toLowerCase()
            if (userInputLowerCased == "true") {
                return true
            } else if (userInputLowerCased == "false") {
                return false
            }
            // if not true or false, then its invalid
            return new Invalid(userInput)
        }
    },
    digits: {
        incomingFilter: (userInput)=>{
            if (userInput.match(/\d+/)) {
                // convert string to number
                return userInput-0
            }
            // if its not a number
            return new Invalid(userInput, "Please only input numerical digits (0-9)")
        }
    },
    "datetime-local": {
        outgoingFilter : (shouldBeDateTime) => {
            if (shouldBeDateTime && shouldBeDateTime instanceof Date) {
                return shouldBeDateTime.toISOString().substring(0, 16)
            }
            return shouldBeDateTime
        },
        incomingFilter: (userInput) => {
            return new Date(userInput+'Z')
        }
    }
}