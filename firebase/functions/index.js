const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp(functions.config().functions);
var token;
exports.chatMessage = functions.firestore.document("message/{messageKey}/timestamp/{timestamp}").onCreate(async (snapshot, context)=>{
    if(!snapshot.exists){
        console.log("Data does not exist");
        return;
    }
    var messageData = snapshot.data();
    var messageKey = context.params.messageKey;
    var senderToken = messageKey.replace("-","").replace(messageData.token, "");
    const db = admin.firestore();
    db.collection("user").doc(senderToken).get().then(doc=> {
        if(!doc.exists){
            console.log("No data exist");
        }else{
            token = doc.data().fcmToken;
            var payload = {
                notification: {title: messageData.name, body: messageData.message, sound: "default"},
                data: {click_action: "FLUTTER_NOTIFICATION_CLICK", message: "Sample Push Message"}
            }
            try{
                admin.messaging().sendToDevice(token,payload);
                console.log("Notification sent successfully");
            }catch(e){
                console.log("Error while sending notification :", e);
            }
        }
    });
});