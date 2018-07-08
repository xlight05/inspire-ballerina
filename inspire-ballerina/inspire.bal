import ballerina/config;
import ballerina/log;
import ballerina/http;
import ballerina/mysql;
import ballerina/io;
import ballerina/task;
import ballerina/math;
import ballerina/runtime;


task:Timer? timer;

endpoint mysql:Client testDB {
    host: "localhost",
    port: 3306,
    name: "inspire-ballerina",
    username: "root",
    password: "",
    poolOptions: { maximumPoolSize: 5 },
    dbOptions: { useSSL: false }
};

type Subscriber record{
    int id,
    string name,
    string phoneNumber,
};

function main(string... args) {



    (function() returns error?) onTriggerFunction = getSubscriberData;

    function(error) onErrorFunction = cleanupError;

    timer = new task:Timer(onTriggerFunction, onErrorFunction,
        5000, delay = 0);


    timer.start();


    runtime:sleep(30000); // "Temp. workaround to stop the process from exiting."


}
function getSubscriberData() returns error?{
    var selectRet = testDB->select("SELECT * FROM subscribers",Subscriber);
    table<Subscriber> dt;

    match selectRet {
        table tableReturned => dt = tableReturned;
        error e => io:println("Select data from student table failed: "
                + e.message);
    }

    error? x = sendQuotesToUsers(dt);
    return ();
}

function sendQuotesToUsers(table <Subscriber> dt) returns error? {
    string message = getRandomInspireQuote();
    foreach row in dt {
        
        if (sendTextMessage(row.phoneNumber,message)){
            io:println("Sent");
        }
        else {
            io:println("noooo");
        }
    }
    return ();
}


function cleanupError(error e) {
    io:print("[ERROR] Error Occured");
    io:println(e);
}


