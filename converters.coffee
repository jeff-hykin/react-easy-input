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
            if  userInput.match /\d+/
                # convert string to number
                return userInput-0
            # if its not a number
            else
                return new Invalid(userInput, "Please only input numerical digits (0-9)")
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
        outgoingFilter: (shouldBeNumber)=>
            # extract the digits/numbers
            numAsString = (shouldBeNumber+"").replace(/[^\d]/g,"")
            areaCode   = numAsString.substring(0,3)  # first 3 digits (if they exist)
            secondPart = numAsString.substring(3,6)  # next 3 (if they exist)
            lastPart   = numAsString.substring(6,10) # last 4 (if they exist)
            numLength  = numAsString.length
            if numLength == 0        then return "" 
            else if (numLength <= 3) then return "("+areaCode 
            else if (numLength <= 6) then return "("+areaCode+")-"+secondPart 
            else                          return "("+areaCode+")-"+secondPart+"-"+lastPart
        ,
        incomingFilter: (value)=>
            # don't allow any character that are not 0-9()-
            value = value.replace(/[^\d\(\)-]/g,"")
            # if it matches a full phone number, then convert it to a number
            if value.match(/\(\d\d\d\)-\d\d\d-\d\d\d\d/)
                return value.replace(/[^\d]/g,"")-0
            # otherwise, just report it as invalid
            return new Invalid(value)
    }
}