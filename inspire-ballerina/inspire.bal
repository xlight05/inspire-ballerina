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


    runtime:sleep(30000); // "Temp. workaround to stop the process from exiting." Really don't know what this is :(


}
function getSubscriberData() returns error?{
    io:println("In subs");
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
        io:println(row.id);
    }
    return ();
}


//function cleanup() returns error? {
//    count = count + 1;
//    io:println("Cleaning up...");
//    io:println(count);
//
//
//    if (count >= 10) {
//        timer.stop();
//        io:println("Stopped timer");
//    }
//    return ();
//}

function cleanupError(error e) {
    io:print("[ERROR] cleanup failed");
    io:println(e);
}


