import ballerina/http;
import ballerina/io;
import ballerina/log;

endpoint http:Client quoteEndpoint {
    url: "https://quotes.p.mashape.com"
};



function getRandomInspireQuote() returns string {
    http:Request req = new;
    req.addHeader("X-Mashape-Key","kEdPZDbPqVmshEdHZFVfT1Pgm0Y0p1tVQOHjsnpLRhpB0Cp4ZU");

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

