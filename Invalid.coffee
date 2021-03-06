get = (obj, keyList, failValue=null) ->
    if typeof keyList == 'string'
        keyList = keyList.split '.'
    
    for each in keyList
        try
            obj = obj[each]
        catch
            return failValue
    
    if obj == null
        return failValue
    else
        return obj

set = (obj, attributeList, value) ->
    if typeof attributeList == 'string'
        attributeList = attributeList.split '.'
        
    lastAttribute = attributeList.pop()
    for elem in attributeList
        if (!obj[elem] instanceof Object)
            obj[elem] = {}
        obj = obj[elem]
    obj[lastAttribute] = value

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
    name = get(value, ["constructor", "name"])
    if (name == "Invalid")
        return true
    else
        return false

module.exports.Invalid   = Invalid
module.exports.isInvalid = isInvalid
module.exports.set       = set
module.exports.get       = get