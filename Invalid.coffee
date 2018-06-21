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

module.exports.Invalid   = Invalid
module.exports.isInvalid = isInvalid