import wso2/twilio;
import ballerina/config;
import ballerina/log;
import ballerina/http;

endpoint twilio:Client twilioClient {
    accountSId: config:getAsString(TWILIO_ACCOUNT_SID),
    authToken: config:getAsString(TWILIO_AUTH_TOKEN)
};

function sendTextMessage(string toMobile, string message) returns boolean {
    string fromMobile = config:getAsString(TWILIO_FROM_MOBILE);
    var details = twilioClient->sendSms(fromMobile, toMobile, message);
    match details {
        twilio:SmsResponse smsResponse => {
            if (smsResponse.sid != EMPTY_STRING) {
                log:printDebug("Twilio Connector -> SMS successfully sent to " + toMobile);
                return true;
            }
        }
        twilio:TwilioError err => {
            log:printDebug("Twilio Connector -> SMS failed sent to " + toMobile);
            log:printError(err.message);
        }
    }
    return false;
}

