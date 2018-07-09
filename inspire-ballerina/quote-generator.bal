import ballerina/http;
import ballerina/io;
import ballerina/log;
import ballerina/config;

endpoint http:Client quoteEndpoint {
    url: "https://quotes.p.mashape.com"
};



function getQuote() returns string {
    http:Request req = new;
    req.addHeader("X-Mashape-Key",config:getAsString(X_MASHAPE_KEY));

    var response = quoteEndpoint->get("/?category=inspirational", message = req);
    match response {
        http:Response resp => {
            var msg = resp.getJsonPayload();
            match msg {
                json jsonPayload => {
                    string resultMessage = jsonPayload["quote"].toString()+" -"+jsonPayload["author"].toString();
                    io:println(resultMessage);
                    return resultMessage;
                }
                error err => {
                    log:printError(err.message, err = err);

                }
            }
        }
        error err => { 
            log:printError(err.message, err = err);

        }
    }
    return "err";
}

function getRandomInspireQuote() returns string{
    string resultMessage;
    resultMessage= getQuote();
    while (resultMessage.length()>160) {
        resultMessage = getQuote();
    }
    return resultMessage;
}

