"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.dailyTimer = void 0;
const admin = require("firebase-admin");
const functions = require("firebase-functions");
admin.initializeApp(functions.config().firebase);
// const serviceAccount = serviceAccountCredentials as admin.ServiceAccount
// admin.initializeApp({
//     credential: admin.credential.cert(
//         "functions/serviceAccount.json"
//     ),
// });
exports.dailyTimer = functions.pubsub
    .schedule("55 08,11,14,17,20 * * *")
    // .schedule("*/1 * * * *")
    .timeZone("Asia/Kolkata")
    .onRun(async () => {
    console.log("notification sending now");
    await sendNotification();
});
// eslint-disable-next-line require-jsdoc
async function sendNotification() {
    const title = "Exam start now";
    const description = "Few Minute is Left Please hurry up!";
    const payload = {
        notification: {
            title: title,
            body: description,
            sound: "default",
            badge: "1",
        },
    };
    // const multiCastPayLoad = {
    //     data: payload,
    //     tokens: fcmTokenIds
    // }
    try {
        await admin.messaging().sendToTopic("notification_topic", payload);
        return true;
    }
    catch (e) {
        console.log("ERROR IN NOTIFICATION SEND :- " + e.toString());
        return false;
    }
}
//# sourceMappingURL=index.js.map