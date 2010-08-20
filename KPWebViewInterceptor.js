
var KP_INTERCEPTOR_INVOCATION_COMMAND = "invoke"
var KP_INTERCEPTOR_SEPERATOR = ":"

function objc_msgsend() {
    var selector = arguments[0];
    var invocation = selector;
    
    if ( arguments.length > 1 ) {
        
        for( var i = 1; i < arguments.length; i++ ) {
            invocation = invocation + KP_INTERCEPTOR_SEPERATOR + arguments[i];
        }
    }
    
    window.location = KP_INTERCEPTOR_INVOCATION_COMMAND + KP_INTERCEPTOR_SEPERATOR + invocation;
}

