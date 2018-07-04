# A class for indicating a value is invalid
# it is used for input validation
InvalidModule = require('./Invalid')
Invalid = InvalidModule.Invalid
isInvalid = InvalidModule.isInvalid

module.exports.converters = {
    bool: {
        outgoingFilter: (shouldBeBool) => 
            if shouldBeBool == true
                return "True"
            else if (shouldBeBool == false) 
                return "False"
            # If provided value is not boolean, then return the value itself
            return shouldBeBool
        ,
        incomingFilter: (userInput) => 
            userInputLowerCased = userInput.toLowerCase()
            if userInputLowerCased == "true"
                return true
            else if userInputLowerCased == "false"
                return false
            # if not true or false, then its invalid
            return new Invalid(userInput, "Please enter either true or false")
    },
    digits: {
        incomingFilter: (userInput) =>
            userInput = userInput.replace( /[^\d]/g, "" )
            return userInput
    },
    decimal: {
        incomingFilter: (userInput) =>
            # remove all additional decimals
            while userInput.match(/\..*\./)
                userInput = userInput.replace( /(\..*)\./g, "$1" )
            # get rid of extraneous characters 
            userInput = userInput.replace( /[^\d\.]/g, "" )
            # make sure its in the correct format
            userInput = userInput.replace( /^.*?(\d*).*?(\.?).*?(\d*).*?$/g, "$1$2$3" )
            # check for the one major invalid case
            if userInput == "."
                return new Invalid(userInput)
            else
                return userInput
        
    },
    numeric: {
        incomingFilter: (userInput) =>
            userInput = userInput.replace( /[^\d\.]/g, "" )
            return userInput
    },
    "datetime-local": {
        outgoingFilter : (shouldBeDateTime) => 
            if shouldBeDateTime and shouldBeDateTime instanceof Date
                return shouldBeDateTime.toISOString().substring(0, 16)
            else
                return shouldBeDateTime
        ,
        incomingFilter: (userInput) => 
            return new Date(userInput+'Z')
    }
    email : {
        incomingFilter: (userInput) =>
            if userInput.match /.+@.+\..+/
                return userInput
            else
                return new Invalid(userInput, "Please enter a valid email")
    },
    phone : {
        incomingFilter: (value) => 
            # don't allow any characters that are not 0-9 or () or - or .
            value = value.replace(/[^\d]/g, "")
            value = value.substring(0, 11)
            if  value.length >= 10
                return value - 0
            # otherwise, just report it as invalid
            return new Invalid(value)
    },
    # numerical : {
    #     incomingFilter: (value) => 
    #         # don't allow any characters that are not 0-9 or () or - or .
    #         value = value.replace(/[^\d]/g, "")
    #         value = value.substring(0, 11)
    #         if  value.length >= 10
    #             return value - 0
    #         # otherwise, just report it as invalid
    #         return new Invalid(value)
    # }
}